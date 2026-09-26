import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.eventColors,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onMonthTitleTap,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<DateTime, List<Color>> eventColors;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onMonthTitleTap;

  static const monthNames = <String>[
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
  static const _shortWeekdays = <String>['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  static const _longWeekdays = <String>[
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Color> _colorsFor(DateTime date) {
    for (final entry in eventColors.entries) {
      if (_sameDay(entry.key, date)) return entry.value;
    }
    return const [];
  }

  List<DateTime> _visibleDays() {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final gridStart = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    return List.generate(42, (index) => gridStart.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final visibleDays = _visibleDays();
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F1535),
            blurRadius: 34,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacious = constraints.maxWidth > 430;
          final weekdays = spacious ? _longWeekdays : _shortWeekdays;
          return Column(
            children: [
              Row(
                children: [
                  _NavigationButton(
                    key: const Key('previous_month'),
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: 'Mes anterior',
                    onPressed: onPreviousMonth,
                  ),
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: 'Elegir mes y año',
                      child: InkWell(
                        onTap: onMonthTitleTap,
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween(
                                      begin: 0.97,
                                      end: 1.0,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                            child: Column(
                              key: ValueKey(
                                '${focusedMonth.year}-${focusedMonth.month}',
                              ),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'VISTA MENSUAL',
                                      style: TextStyle(
                                        color: Color(0xFF9B9EAE),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.45,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.expand_more_rounded,
                                      color: const Color(0xFF9B9EAE),
                                      size: spacious ? 17 : 15,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${monthNames[focusedMonth.month - 1]} ${focusedMonth.year}',
                                  style: TextStyle(
                                    color: const Color(0xFF20253D),
                                    fontSize: spacious ? 20 : 17,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _NavigationButton(
                    key: const Key('next_month'),
                    icon: Icons.arrow_forward_ios_rounded,
                    tooltip: 'Mes siguiente',
                    onPressed: onNextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7FC),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: List.generate(
                    7,
                    (index) => Expanded(
                      child: Center(
                        child: Text(
                          weekdays[index],
                          style: TextStyle(
                            color: index > 4
                                ? const Color(0xFF9B72A5)
                                : const Color(0xFF898D9F),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleDays.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: spacious ? 6 : 3,
                  crossAxisSpacing: spacious ? 6 : 3,
                  childAspectRatio: spacious ? 1.12 : 0.98,
                ),
                itemBuilder: (context, index) {
                  final date = visibleDays[index];
                  return _DayCell(
                    key: ValueKey('day_${date.year}_${date.month}_${date.day}'),
                    date: date,
                    isInMonth: date.month == focusedMonth.month,
                    isSelected: _sameDay(date, selectedDate),
                    isToday: _sameDay(date, DateTime.now()),
                    isWeekend: date.weekday >= DateTime.saturday,
                    eventColors: _colorsFor(date),
                    onTap: () => onDateSelected(date),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: Color(0xFF5B7CFA), label: 'Trabajo'),
                  SizedBox(width: 16),
                  _LegendDot(color: Color(0xFFF15B92), label: 'Estudio'),
                  SizedBox(width: 16),
                  _LegendDot(color: Color(0xFF22A978), label: 'Personal'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 16),
      color: const Color(0xFF5C50B6),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF1EFF9),
        hoverColor: const Color(0xFFE6E1FB),
        fixedSize: const Size(42, 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _DayCell extends StatefulWidget {
  const _DayCell({
    super.key,
    required this.date,
    required this.isInMonth,
    required this.isSelected,
    required this.isToday,
    required this.isWeekend,
    required this.eventColors,
    required this.onTap,
  });

  final DateTime date;
  final bool isInMonth;
  final bool isSelected;
  final bool isToday;
  final bool isWeekend;
  final List<Color> eventColors;
  final VoidCallback onTap;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final label = '${widget.date.day}/${widget.date.month}/${widget.date.year}';
    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.eventColors.isEmpty ? label : '$label, con evento',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(0, _hovered ? -1 : 0, 0),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF5E52D8), Color(0xFF9566D7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: widget.isSelected
                    ? null
                    : widget.isToday
                    ? const Color(0xFFF0ECFF)
                    : _hovered
                    ? const Color(0xFFF5F2FC)
                    : widget.isWeekend && widget.isInMonth
                    ? const Color(0xFFFCF9FC)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: widget.isToday && !widget.isSelected
                    ? Border.all(color: const Color(0xFFAFA2EF), width: 1.2)
                    : null,
                boxShadow: widget.isSelected
                    ? const [
                        BoxShadow(
                          color: Color(0x3D6750E8),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.date.day}',
                    style: TextStyle(
                      color: widget.isSelected
                          ? Colors.white
                          : !widget.isInMonth
                          ? const Color(0xFFC9CAD2)
                          : widget.isWeekend
                          ? const Color(0xFF825E8E)
                          : const Color(0xFF33384F),
                      fontSize: 13.5,
                      fontWeight: widget.isSelected || widget.isToday
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final color in widget.eventColors.take(3)) ...[
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: widget.isSelected ? Colors.white : color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (color != widget.eventColors.take(3).last)
                            const SizedBox(width: 2),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF989AAA),
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
