import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/calendar_widget.dart';
import '../widgets/event_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedMonth = DateTime(2026, 9);
  DateTime _selectedDate = DateTime(2026, 9, 21);

  static const _months = <String>[
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  final List<CalendarEvent> _events = [
    CalendarEvent(
      date: DateTime(2026, 9, 5),
      title: 'Reunión de equipo',
      description: 'Sala virtual · Proyecto Flutter',
      time: '10:00 a. m.',
      category: 'Trabajo',
      icon: Icons.groups_rounded,
      color: Color(0xFF5B7CFA),
    ),
    CalendarEvent(
      date: DateTime(2026, 9, 12),
      title: 'Examen de programación',
      description: 'Widgets, Row y Column',
      time: '9:00 a. m.',
      category: 'Estudio',
      icon: Icons.edit_note_rounded,
      color: Color(0xFFF15B92),
    ),
    CalendarEvent(
      date: DateTime(2026, 9, 21),
      title: 'Presentación de proyecto',
      description: 'Entrega visual del calendario',
      time: '2:00 p. m.',
      category: 'Personal',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF22A978),
    ),
    CalendarEvent(
      date: DateTime(2026, 10, 8),
      title: 'Retrospectiva mensual',
      description: 'Revisión de avances y objetivos',
      time: '4:30 p. m.',
      category: 'Trabajo',
      icon: Icons.insights_rounded,
      color: Color(0xFF5B7CFA),
    ),
  ];

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<CalendarEvent> get _monthEvents => _events
      .where(
        (event) =>
            event.date.year == _focusedMonth.year &&
            event.date.month == _focusedMonth.month,
      )
      .toList();

  List<CalendarEvent> get _selectedEvents =>
      _events.where((event) => _sameDay(event.date, _selectedDate)).toList();

  Map<DateTime, List<Color>> get _eventColors {
    final result = <DateTime, List<Color>>{};
    for (final event in _events) {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      result.putIfAbsent(day, () => []).add(event.color);
    }
    return result;
  }

  String get _monthTitle {
    final month = _months[_focusedMonth.month - 1];
    return '${month[0].toUpperCase()}${month.substring(1)} ${_focusedMonth.year}';
  }

  String get _selectedDateLabel =>
      '${_selectedDate.day} de ${_months[_selectedDate.month - 1]}';

  String _formatTime(TimeOfDay value) {
    final hour = value.hourOfPeriod == 0 ? 12 : value.hourOfPeriod;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.period == DayPeriod.am ? 'a. m.' : 'p. m.';
    return '$hour:$minute $period';
  }

  void _changeMonth(int offset) {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + offset);
    setState(() {
      _focusedMonth = next;
      _selectedDate = DateTime(next.year, next.month);
    });
  }

  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _focusedMonth = DateTime(today.year, today.month);
      _selectedDate = DateTime(today.year, today.month, today.day);
    });
  }

  Future<void> _showMonthPicker() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035, 12, 31),
      helpText: 'ELIGE UNA FECHA',
      cancelText: 'CANCELAR',
      confirmText: 'IR A LA FECHA',
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedDate = selected;
        _focusedMonth = DateTime(selected.year, selected.month);
      });
    }
  }

  Future<void> _showAddEventDialog() async {
    final titleController = TextEditingController();
    final detailController = TextEditingController();
    var category = 'Trabajo';
    var time = const TimeOfDay(hour: 9, minute: 0);
    var hasTitle = false;

    final created = await showDialog<CalendarEvent>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final color = switch (category) {
            'Estudio' => const Color(0xFFF15B92),
            'Personal' => const Color(0xFF22A978),
            _ => const Color(0xFF5B7CFA),
          };
          final icon = switch (category) {
            'Estudio' => Icons.school_rounded,
            'Personal' => Icons.favorite_rounded,
            _ => Icons.work_rounded,
          };
          return AlertDialog(
            backgroundColor: const Color(0xFFFCFBFE),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 21),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nuevo evento',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      key: const Key('event_title_field'),
                      controller: titleController,
                      autofocus: true,
                      onChanged: (value) => setDialogState(
                        () => hasTitle = value.trim().isNotEmpty,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        hintText: '¿Qué tienes planeado?',
                        prefixIcon: Icon(Icons.edit_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: detailController,
                      decoration: const InputDecoration(
                        labelText: 'Detalle (opcional)',
                        prefixIcon: Icon(Icons.notes_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        prefixIcon: Icon(Icons.category_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Trabajo',
                          child: Text('Trabajo'),
                        ),
                        DropdownMenuItem(
                          value: 'Estudio',
                          child: Text('Estudio'),
                        ),
                        DropdownMenuItem(
                          value: 'Personal',
                          child: Text('Personal'),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => category = value!),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: time,
                              );
                              if (picked != null) {
                                setDialogState(() => time = picked);
                              }
                            },
                            icon: const Icon(Icons.schedule_rounded, size: 18),
                            label: Text(_formatTime(time)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F0F8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _selectedDateLabel,
                              style: const TextStyle(
                                color: Color(0xFF686C80),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                key: const Key('save_event_button'),
                onPressed: !hasTitle
                    ? null
                    : () => Navigator.pop(
                        dialogContext,
                        CalendarEvent(
                          date: _selectedDate,
                          title: titleController.text.trim(),
                          description: detailController.text.trim().isEmpty
                              ? 'Actividad personal'
                              : detailController.text.trim(),
                          time: _formatTime(time),
                          category: category,
                          icon: icon,
                          color: color,
                        ),
                      ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Añadir'),
              ),
            ],
          );
        },
      ),
    );

    if (created != null && mounted) {
      setState(() => _events.add(created));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('“${created.title}” se añadió a tu agenda.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // The route finishes its exit animation before its text fields are released.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    titleController.dispose();
    detailController.dispose();
  }

  void _deleteEvent(CalendarEvent event) {
    setState(() => _events.remove(event));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('“${event.title}” fue eliminado.'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () => setState(() => _events.add(event)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final showDevice = constraints.maxWidth >= 700;
          final height = showDevice
              ? math.min(900.0, constraints.maxHeight - 36)
              : constraints.maxHeight;
          return Stack(
            children: [
              const _AmbientBackground(),
              Center(
                child: _PhoneShell(
                  showDeviceFrame: showDevice,
                  height: height,
                  child: Column(
                    children: [
                      const _PhoneStatusBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TopBar(
                                onToday: _goToToday,
                                onAdd: _showAddEventDialog,
                              ),
                              const SizedBox(height: 18),
                              _HeroHeader(
                                monthTitle: _monthTitle,
                                eventCount: _monthEvents.length,
                              ),
                              const SizedBox(height: 18),
                              _buildCalendar(),
                              const SizedBox(height: 18),
                              _buildAgenda(),
                              const SizedBox(height: 18),
                              const _PhoneBottomNav(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar() => CalendarWidget(
    focusedMonth: _focusedMonth,
    selectedDate: _selectedDate,
    eventColors: _eventColors,
    onDateSelected: (date) {
      setState(() {
        _selectedDate = date;
        if (date.month != _focusedMonth.month ||
            date.year != _focusedMonth.year) {
          _focusedMonth = DateTime(date.year, date.month);
        }
      });
    },
    onPreviousMonth: () => _changeMonth(-1),
    onNextMonth: () => _changeMonth(1),
    onMonthTitleTap: _showMonthPicker,
  );

  Widget _buildAgenda() {
    final events = _selectedEvents;
    final monthShort = _months[_selectedDate.month - 1]
        .substring(0, 3)
        .toUpperCase();
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F1535),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 62,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6251D2), Color(0xFF9668D7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x306750E8),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthShort,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '${_selectedDate.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Agenda del día',
                      style: TextStyle(
                        color: Color(0xFF1D2340),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      events.isEmpty
                          ? 'Todo despejado por ahora'
                          : 'Tus momentos importantes',
                      style: const TextStyle(
                        color: Color(0xFF8589A3),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F0FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${events.length} ${events.length == 1 ? 'evento' : 'eventos'}',
                  style: const TextStyle(
                    color: Color(0xFF6750E8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: events.isEmpty
                ? _EmptyAgenda(
                    key: ValueKey(_selectedDate),
                    onAdd: _showAddEventDialog,
                  )
                : Column(
                    key: ValueKey(_selectedDate),
                    children: [
                      for (var i = 0; i < events.length; i++) ...[
                        EventCard(
                          event: events[i],
                          onDelete: () => _deleteEvent(events[i]),
                        ),
                        if (i != events.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFE9E7F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xFFF29E38),
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Selecciona un día marcado para ver sus detalles.',
                  style: TextStyle(
                    color: const Color(0xFF565C76).withValues(alpha: 0.88),
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhoneShell extends StatelessWidget {
  const _PhoneShell({
    required this.showDeviceFrame,
    required this.height,
    required this.child,
  });

  final bool showDeviceFrame;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: showDeviceFrame ? 430 : double.infinity,
      height: height,
      margin: EdgeInsets.all(showDeviceFrame ? 18 : 0),
      padding: EdgeInsets.all(showDeviceFrame ? 9 : 0),
      decoration: BoxDecoration(
        gradient: showDeviceFrame
            ? const LinearGradient(
                colors: [Color(0xFF252333), Color(0xFF08080D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(showDeviceFrame ? 50 : 0),
        border: showDeviceFrame
            ? Border.all(color: const Color(0xFF4B475B), width: 1.2)
            : null,
        boxShadow: showDeviceFrame
            ? const [
                BoxShadow(
                  color: Color(0x4D18102F),
                  blurRadius: 60,
                  spreadRadius: 5,
                  offset: Offset(0, 30),
                ),
                BoxShadow(
                  color: Color(0x267A5CFF),
                  blurRadius: 90,
                  spreadRadius: 12,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 4,
                  offset: Offset(5, 8),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(showDeviceFrame ? 40 : 0),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F6FD), Color(0xFFF0EDF8), Color(0xFFF8F5F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PhoneStatusBar extends StatelessWidget {
  const _PhoneStatusBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '9:41',
                  style: TextStyle(
                    color: Color(0xFF24283E),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.signal_cellular_alt_rounded,
                      size: 14,
                      color: Color(0xFF24283E),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.wifi_rounded,
                      size: 14,
                      color: Color(0xFF24283E),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 19,
                      height: 9,
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF24283E)),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF24283E),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 92,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF121218),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x26000000), blurRadius: 8),
              ],
            ),
            child: Align(
              alignment: const Alignment(0.68, 0),
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF25243A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneBottomNav extends StatelessWidget {
  const _PhoneBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180F1535),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(icon: Icons.home_rounded, label: 'Inicio'),
          _NavIcon(
            icon: Icons.calendar_month_rounded,
            label: 'Calendario',
            active: true,
          ),
          _NavIcon(icon: Icons.notifications_rounded, label: 'Avisos'),
          _NavIcon(icon: Icons.person_rounded, label: 'Perfil'),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEEEAFE) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 21,
            color: active ? const Color(0xFF6750E8) : const Color(0xFFAAAAB7),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF6750E8) : const Color(0xFFAAAAB7),
              fontSize: 8.5,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onToday, required this.onAdd});

  final VoidCallback onToday;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        return Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7258F3), Color(0xFF9B62F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x406750E8),
                    blurRadius: 18,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(Icons.bolt_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LÚMINA',
                    style: TextStyle(
                      color: Color(0xFF20253E),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.2,
                    ),
                  ),
                  Text(
                    'Tu tiempo, en armonía',
                    style: TextStyle(color: Color(0xFF8B8FA5), fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!compact) ...[
              TextButton.icon(
                key: const Key('today_button'),
                onPressed: onToday,
                icon: const Icon(Icons.near_me_rounded, size: 17),
                label: const Text('Hoy'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5B49C9),
                  backgroundColor: Colors.white.withValues(alpha: 0.78),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Color(0xFFE8E4F5)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ] else ...[
              IconButton(
                key: const Key('today_button'),
                onPressed: onToday,
                tooltip: 'Ir a hoy',
                icon: const Icon(Icons.near_me_rounded, size: 18),
                color: const Color(0xFF5B49C9),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.78),
                  fixedSize: const Size(42, 42),
                ),
              ),
              const SizedBox(width: 7),
            ],
            FilledButton.icon(
              key: const Key('add_event_button'),
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 19),
              label: compact
                  ? const SizedBox.shrink()
                  : const Text('Nuevo evento'),
              style: FilledButton.styleFrom(
                elevation: 0,
                minimumSize: compact ? const Size(46, 46) : null,
                padding: compact
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                backgroundColor: const Color(0xFF6251D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.monthTitle, required this.eventCount});

  final String monthTitle;
  final int eventCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 205,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26264D), Color(0xFF49377D), Color(0xFF7955B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x5944306F),
            blurRadius: 28,
            offset: Offset(0, 15),
          ),
          BoxShadow(
            color: Color(0x267D61E8),
            blurRadius: 3,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              right: -38,
              top: -54,
              child: Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                    width: 28,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -19,
              bottom: -4,
              child: Image.asset(
                'assets/images/calendar_3d.png',
                width: 162,
                height: 162,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 18, 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.11),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'MI ESPACIO',
                        style: TextStyle(
                          color: Color(0xFFDAD2FF),
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 235,
                      child: Text(
                        monthTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 215,
                      child: Text(
                        'Organiza. Respira. Disfruta.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.68),
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16152A).withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFFFFD7A5),
                            size: 15,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '$eventCount ${eventCount == 1 ? 'evento' : 'eventos'} este mes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAgenda extends StatelessWidget {
  const _EmptyAgenda({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6FB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECEAF2)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEAFB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.spa_outlined,
              color: Color(0xFF8878C5),
              size: 27,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Un día sin pendientes',
            style: TextStyle(
              color: Color(0xFF42475E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Disfruta el espacio libre o planifica algo nuevo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9295A6), fontSize: 12),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 17),
            label: const Text('Crear un evento'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6750E8),
              side: const BorderSide(color: Color(0xFFD7D0F4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F6FC), Color(0xFFF0EDF8), Color(0xFFF8F5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -70,
              child: _orb(const Color(0x337E63E8), 300),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: _orb(const Color(0x26EE87A7), 280),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _orb(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
