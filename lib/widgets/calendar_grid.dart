import 'package:flutter/material.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.eventColors,
    required this.holidayLabels,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<DateTime, List<Color>> eventColors;
  final Map<DateTime, String> holidayLabels;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  static const List<String> _weekdays = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime> _visibleDays() {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final start = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    return List.generate(42, (index) => start.add(Duration(days: index)));
  }

  List<Color> _colorsFor(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return eventColors[key] ?? const [];
  }

  String? _holidayFor(DateTime date) {
    for (final entry in holidayLabels.entries) {
      if (_sameDay(entry.key, date)) return entry.value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final visibleDays = _visibleDays();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.99),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x130B1025),
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _ArrowButton(
                key: const Key('previous_month'),
                icon: Icons.chevron_left_rounded,
                onPressed: onPreviousMonth,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Vista del mes',
                      style: TextStyle(
                        color: Color(0xFF747A8E),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_monthName(focusedMonth.month)} ${focusedMonth.year}',
                      style: const TextStyle(
                        color: Color(0xFF4B438D),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _ArrowButton(
                key: const Key('next_month'),
                icon: Icons.chevron_right_rounded,
                onPressed: onNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(7, (index) {
              final weekday = _weekdays[index];
              return Expanded(
                child: Center(
                  child: Text(
                    weekday,
                    style: TextStyle(
                      color: index >= 5
                          ? const Color(0xFF80568F)
                          : const Color(0xFF6E7488),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1.7,
            ),
            itemBuilder: (context, index) {
              final date = visibleDays[index];
              final isCurrentMonth = date.month == focusedMonth.month;
              final isSelected = _sameDay(date, selectedDate);
              final eventColorsForDay = _colorsFor(date);
              final holiday = _holidayFor(date);
              final isOutside = !isCurrentMonth;
              final isSelectedCore = isSelected && isCurrentMonth;

              return GestureDetector(
                key: ValueKey('day_${date.year}_${date.month}_${date.day}'),
                onTap: () => onDateSelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  alignment: Alignment.center,
                  decoration: isSelectedCore
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6F5AE8),
                              Color(0xFF8D64F6),
                              Color(0xFFB771FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x336255D8),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        )
                      : null,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 5,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelectedCore
                                ? Colors.white
                                : isOutside
                                ? const Color(0xFF858B9D)
                                : const Color(0xFF36416B),
                            fontSize: 13,
                            fontWeight: isSelectedCore
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (eventColorsForDay.isNotEmpty || holiday != null)
                        Positioned(
                          bottom: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final color in eventColorsForDay)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelectedCore
                                        ? Colors.white
                                        : color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              if (holiday != null)
                                Tooltip(
                                  message: 'Feriado: $holiday',
                                  child: Container(
                                    key: ValueKey(
                                      'holiday_marker_${date.year}_${date.month}_${date.day}',
                                    ),
                                    width: 7,
                                    height: 7,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE84D63),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFFFD4DA),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F1F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFF6157CD), size: 18),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
