import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';
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

  final Map<DateTime, String> _holidays = {
    DateTime(2026, 1, 1): 'Año Nuevo',
    DateTime(2026, 4, 2): 'Jueves Santo',
    DateTime(2026, 4, 3): 'Viernes Santo',
    DateTime(2026, 5, 1): 'Día del Trabajo',
    DateTime(2026, 6, 7): 'Batalla de Arica y Día de la Bandera',
    DateTime(2026, 6, 29): 'San Pedro y San Pablo',
    DateTime(2026, 7, 23): 'Día de la Fuerza Aérea del Perú',
    DateTime(2026, 7, 28): 'Fiestas Patrias',
    DateTime(2026, 7, 29): 'Fiestas Patrias',
    DateTime(2026, 8, 6): 'Batalla de Junín',
    DateTime(2026, 8, 30): 'Santa Rosa de Lima',
    DateTime(2026, 9, 8): 'Nuestra Señora de Cocharcas · Regional',
    DateTime(2026, 9, 13): 'Creación del departamento de Junín · Regional',
    DateTime(2026, 9, 14): 'Señor de Locumba · Regional',
    DateTime(2026, 10, 8): 'Combate de Angamos',
    DateTime(2026, 11, 1): 'Día de Todos los Santos',
    DateTime(2026, 12, 8): 'Inmaculada Concepción',
    DateTime(2026, 12, 9): 'Batalla de Ayacucho',
    DateTime(2026, 12, 25): 'Navidad',
  };

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

  String? get _selectedHoliday {
    for (final entry in _holidays.entries) {
      if (_sameDay(entry.key, _selectedDate)) return entry.value;
    }
    return null;
  }

  Map<DateTime, List<Color>> get _eventColors {
    final result = <DateTime, List<Color>>{};
    for (final event in _events) {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      result.putIfAbsent(day, () => []).add(event.color);
    }
    return result;
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
          final dialogTheme =
              ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6750E8),
                  brightness: Brightness.light,
                ),
              ).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFFF8F7FC),
                  labelStyle: const TextStyle(color: Color(0xFF5D6277)),
                  hintStyle: const TextStyle(color: Color(0xFF8B8FA1)),
                  prefixIconColor: const Color(0xFF6750E8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD7D4E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF6750E8),
                      width: 2,
                    ),
                  ),
                ),
              );
          return Theme(
            data: dialogTheme,
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 24,
              ),
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
                    style: TextStyle(
                      color: Color(0xFF252045),
                      fontWeight: FontWeight.w900,
                    ),
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
                              icon: const Icon(
                                Icons.schedule_rounded,
                                size: 18,
                              ),
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
              actionsPadding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
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
            ),
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

  Future<void> _showAllEventsDialog() {
    final events = List<CalendarEvent>.of(_events)
      ..sort((first, second) => first.date.compareTo(second.date));

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFCFBFE),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Todos los eventos',
          style: TextStyle(
            color: Color(0xFF443C91),
            fontWeight: FontWeight.w800,
          ),
        ),
        content: SizedBox(
          width: 420,
          height: math.min(
            420.0,
            MediaQuery.sizeOf(dialogContext).height * 0.55,
          ),
          child: events.isEmpty
              ? const Center(child: Text('Aún no hay eventos programados.'))
              : ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final month = _months[event.date.month - 1]
                        .substring(0, 3)
                        .toUpperCase();
                    return Material(
                      color: const Color(0xFFF5F3FA),
                      borderRadius: BorderRadius.circular(16),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: event.color.withValues(alpha: 0.14),
                          child: Icon(event.icon, color: event.color, size: 20),
                        ),
                        title: Text(
                          event.title,
                          style: const TextStyle(
                            color: Color(0xFF443C91),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          '${event.date.day} $month ${event.date.year} · ${event.time}',
                          style: const TextStyle(color: Color(0xFF59647D)),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: event.color,
                          size: 15,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedDate = event.date;
                            _focusedMonth = DateTime(
                              event.date.year,
                              event.date.month,
                            );
                          });
                          Navigator.pop(dialogContext);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final showDevice = constraints.maxWidth >= 900;
          final height = showDevice
              ? math.min(860.0, constraints.maxHeight * 0.94)
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
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TopBar(
                                onToday: _goToToday,
                                onAdd: _showAddEventDialog,
                              ),
                              const SizedBox(height: 12),
                              CalendarHeader(
                                dayLabel: _selectedDateLabel,
                                eventCount: _monthEvents.length,
                              ),
                              const SizedBox(height: 12),
                              CalendarGrid(
                                focusedMonth: _focusedMonth,
                                selectedDate: _selectedDate,
                                eventColors: _eventColors,
                                holidayLabels: _holidays,
                                onDateSelected: (date) {
                                  setState(() {
                                    _selectedDate = date;
                                    if (date.month != _focusedMonth.month ||
                                        date.year != _focusedMonth.year) {
                                      _focusedMonth = DateTime(
                                        date.year,
                                        date.month,
                                      );
                                    }
                                  });
                                },
                                onPreviousMonth: () => _changeMonth(-1),
                                onNextMonth: () => _changeMonth(1),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xE6224F9D),
                                      Color(0xE631245E),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0x806FA5FF),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x55256FFF),
                                      blurRadius: 20,
                                      offset: Offset(-5, 7),
                                    ),
                                    BoxShadow(
                                      color: Color(0x44FF4EC7),
                                      blurRadius: 18,
                                      offset: Offset(6, 7),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.event_note_rounded,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                    const SizedBox(width: 9),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Eventos destacados',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Revisa tus próximos eventos',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color(0xFFC9D5FF),
                                              fontSize: 9.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    TextButton.icon(
                                      key: const Key('all_events_button'),
                                      onPressed: _showAllEventsDialog,
                                      icon: const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 16,
                                      ),
                                      label: const Text('Ver todos'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(
                                          0x405F62FF,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0x99C8C5FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildAgenda(),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 18),
                        child: BottomNavigation(),
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

  Widget _buildAgenda() {
    final events = _selectedEvents;
    final holiday = _selectedHoliday;
    final monthShort = _months[_selectedDate.month - 1]
        .substring(0, 3)
        .toUpperCase();
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.98)),
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
                        color: Color(0xFF4B438D),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      events.isEmpty
                          ? 'Todo despejado por ahora'
                          : 'Tus momentos importantes',
                      style: const TextStyle(
                        color: Color(0xFF626B84),
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
          if (holiday != null) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF1F2), Color(0xFFFFE5E8)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFC4CB)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18E53950),
                    blurRadius: 14,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 39,
                    height: 39,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE63C51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FERIADO',
                          style: TextStyle(
                            color: Color(0xFFE2384E),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.25,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          holiday,
                          style: const TextStyle(
                            color: Color(0xFF792B37),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    final phone = Stack(
      clipBehavior: Clip.none,
      children: [
        if (showDeviceFrame) ...[
          const Positioned(
            left: -4,
            top: 155,
            child: _SideButton(width: 4, height: 68),
          ),
          const Positioned(
            left: -4,
            top: 240,
            child: _SideButton(width: 4, height: 42),
          ),
          const Positioned(
            right: -4,
            top: 205,
            child: _SideButton(width: 4, height: 86),
          ),
        ],
        Container(
          width: showDeviceFrame ? 390 : double.infinity,
          height: height,
          padding: EdgeInsets.all(showDeviceFrame ? 8 : 0),
          decoration: BoxDecoration(
            gradient: showDeviceFrame
                ? const LinearGradient(
                    colors: [
                      Color(0xFF4D4A5A),
                      Color(0xFF171620),
                      Color(0xFF090A10),
                    ],
                    stops: [0, 0.42, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(showDeviceFrame ? 42 : 0),
            border: showDeviceFrame
                ? Border.all(color: const Color(0xFF9B7CFF), width: 1.3)
                : null,
            boxShadow: showDeviceFrame
                ? const [
                    BoxShadow(
                      color: Color(0x4D121826),
                      blurRadius: 42,
                      spreadRadius: 2,
                      offset: Offset(0, 24),
                    ),
                    BoxShadow(
                      color: Color(0x55475EFF),
                      blurRadius: 86,
                      spreadRadius: 10,
                      offset: Offset(0, 0),
                    ),
                    BoxShadow(
                      color: Color(0x4DFF4FCC),
                      blurRadius: 35,
                      spreadRadius: 1,
                      offset: Offset(8, 3),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(showDeviceFrame ? 34 : 0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/cosmic_background.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        color: const Color(0xB80A0D22),
                        colorBlendMode: BlendMode.darken,
                        filterQuality: FilterQuality.medium,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xA8080B20),
                              Color(0xD90A0D24),
                              Color(0xF20A0B20),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      child,
                    ],
                  ),
                ),
                if (showDeviceFrame)
                  Positioned(
                    top: -120,
                    right: -112,
                    child: IgnorePointer(
                      child: Transform.rotate(
                        angle: -0.38,
                        child: Container(
                          width: 165,
                          height: 520,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0),
                                Colors.white.withValues(alpha: 0.055),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (showDeviceFrame)
                  Positioned(
                    bottom: 7,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 112,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1E1D27,
                          ).withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeOutBack,
      child: phone,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 22 * (1 - value)),
        child: Transform.scale(scale: 0.95 + (0.05 * value), child: child),
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF777181), Color(0xFF211F29)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 3,
            offset: Offset(1, 2),
          ),
        ],
      ),
    );
  }
}

class _PhoneStatusBar extends StatelessWidget {
  const _PhoneStatusBar();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: const Color(0xCC0A0F2A)),
      child: SizedBox(
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
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.signal_cellular_alt_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.wifi_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 19,
                        height: 9,
                        padding: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
      ),
    );
  }
}

// Legacy compact variant kept for small-screen experiments.
// ignore: unused_element
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xD91B2450), Color(0xD92B214C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D126BFF),
                blurRadius: 22,
                offset: Offset(-6, 8),
              ),
              BoxShadow(
                color: Color(0x33FF54D4),
                blurRadius: 20,
                offset: Offset(7, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2F7DFF),
                      Color(0xFF734CFF),
                      Color(0xFFFF63CE),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0x99FFFFFF)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x995B54FF),
                      blurRadius: 20,
                      spreadRadius: 1,
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
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                      ),
                    ),
                    Text(
                      'Tu tiempo, en armonía',
                      style: TextStyle(color: Color(0xFFC7D1FF), fontSize: 12),
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
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.10),
                    fixedSize: const Size(42, 42),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
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
                  minimumSize: compact ? const Size(46, 46) : null,
                  padding: compact
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 13,
                        ),
                  backgroundColor: const Color(0xFF754CFF),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xFFFF55D1),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Legacy illustrated header kept as a reusable visual fallback.
// ignore: unused_element
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
            const Positioned(
              right: -19,
              bottom: -4,
              child: _FloatingCalendarArt(),
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

class _FloatingCalendarArt extends StatefulWidget {
  const _FloatingCalendarArt();

  @override
  State<_FloatingCalendarArt> createState() => _FloatingCalendarArtState();
}

class _FloatingCalendarArtState extends State<_FloatingCalendarArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _float = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      child: Image.asset(
        'assets/images/calendar_3d.png',
        width: 162,
        height: 162,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 18 * (1 - _float.value)),
        child: Transform.rotate(
          angle: -0.08 * (1 - _float.value),
          child: child,
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6FB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECEAF2)),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEAFB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.spa_outlined,
              color: Color(0xFF8878C5),
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Un día sin pendientes',
            style: TextStyle(
              color: Color(0xFF4B438D),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Disfruta el espacio libre o planifica algo nuevo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF667087), fontSize: 12),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 17),
            label: const Text('Crear un evento'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6750E8),
              minimumSize: const Size(178, 42),
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/cosmic_background.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.62,
                colors: [Color(0x00000000), Color(0x8A02040D)],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x2606091B),
                  Color(0x00000000),
                  Color(0x4D03040E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Legacy procedural backdrop retained as an offline asset fallback.
// ignore: unused_element
class _FireWaterBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final scale = size.shortestSide;
    canvas.drawRect(bounds, Paint()..color = const Color(0xFF030407));

    void glow(Offset point, double radius, List<Color> colors) {
      canvas.drawCircle(
        point,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: colors,
          ).createShader(Rect.fromCircle(center: point, radius: radius))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.18),
      );
    }

    final waterCenter = Offset(size.width * 0.31, size.height * 0.52);
    final fireCenter = Offset(size.width * 0.69, size.height * 0.53);
    glow(waterCenter, scale * 0.72, const [
      Color(0xA8255D8A),
      Color(0x482D465F),
      Color(0x0003070B),
    ]);
    glow(fireCenter, scale * 0.76, const [
      Color(0xA8F06413),
      Color(0x633A0C12),
      Color(0x0003070B),
    ]);

    final waterBody = Path()
      ..moveTo(size.width * 0.43, size.height * 0.30)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.21,
        size.width * 0.03,
        size.height * 0.27,
        size.width * 0.00,
        size.height * 0.43,
      )
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.40,
        size.width * 0.25,
        size.height * 0.48,
        size.width * 0.45,
        size.height * 0.49,
      )
      ..cubicTo(
        size.width * 0.31,
        size.height * 0.60,
        size.width * 0.15,
        size.height * 0.67,
        size.width * 0.00,
        size.height * 0.69,
      )
      ..cubicTo(
        size.width * 0.19,
        size.height * 0.78,
        size.width * 0.40,
        size.height * 0.67,
        size.width * 0.51,
        size.height * 0.56,
      )
      ..cubicTo(
        size.width * 0.45,
        size.height * 0.46,
        size.width * 0.53,
        size.height * 0.39,
        size.width * 0.43,
        size.height * 0.30,
      )
      ..close();
    canvas.drawPath(
      waterBody,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB8F4FF), Color(0xFF337FA8), Color(0xFF071A30)],
          stops: [0.0, 0.42, 1.0],
        ).createShader(bounds)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, scale * 0.025),
    );

    final fireBody = Path()
      ..moveTo(size.width * 0.54, size.height * 0.49)
      ..cubicTo(
        size.width * 0.60,
        size.height * 0.37,
        size.width * 0.51,
        size.height * 0.27,
        size.width * 0.65,
        size.height * 0.18,
      )
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.31,
        size.width * 0.79,
        size.height * 0.28,
        size.width * 0.78,
        size.height * 0.10,
      )
      ..cubicTo(
        size.width * 0.91,
        size.height * 0.26,
        size.width * 0.82,
        size.height * 0.35,
        size.width * 0.99,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.52,
        size.width * 0.98,
        size.height * 0.59,
        size.width * 0.82,
        size.height * 0.76,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.84,
        size.width * 0.61,
        size.height * 0.76,
        size.width * 0.54,
        size.height * 0.62,
      )
      ..cubicTo(
        size.width * 0.50,
        size.height * 0.57,
        size.width * 0.51,
        size.height * 0.53,
        size.width * 0.54,
        size.height * 0.49,
      )
      ..close();
    canvas.drawPath(
      fireBody,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE2A1),
            Color(0xFFFF871D),
            Color(0xFFE32612),
            Color(0xFF641019),
          ],
          stops: [0.0, 0.34, 0.68, 1.0],
        ).createShader(bounds)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, scale * 0.02),
    );

    final innerFlame = Path()
      ..moveTo(size.width * 0.59, size.height * 0.60)
      ..cubicTo(
        size.width * 0.61,
        size.height * 0.47,
        size.width * 0.71,
        size.height * 0.46,
        size.width * 0.70,
        size.height * 0.33,
      )
      ..cubicTo(
        size.width * 0.80,
        size.height * 0.45,
        size.width * 0.77,
        size.height * 0.54,
        size.width * 0.86,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.79,
        size.height * 0.70,
        size.width * 0.67,
        size.height * 0.72,
        size.width * 0.59,
        size.height * 0.60,
      )
      ..close();
    canvas.drawPath(
      innerFlame,
      Paint()
        ..shader =
            const RadialGradient(
              colors: [Color(0xFFFFF5C5), Color(0xFFFFB12F), Color(0x00FF5A12)],
              stops: [0.0, 0.46, 1.0],
            ).createShader(
              Rect.fromCenter(
                center: fireCenter,
                width: scale * 0.56,
                height: scale * 0.72,
              ),
            ),
    );

    final waterRibbons = <Path>[
      Path()
        ..moveTo(size.width * 0.00, size.height * 0.35)
        ..cubicTo(
          size.width * 0.18,
          size.height * 0.27,
          size.width * 0.32,
          size.height * 0.46,
          size.width * 0.53,
          size.height * 0.43,
        ),
      Path()
        ..moveTo(size.width * 0.00, size.height * 0.72)
        ..cubicTo(
          size.width * 0.17,
          size.height * 0.77,
          size.width * 0.34,
          size.height * 0.55,
          size.width * 0.52,
          size.height * 0.57,
        ),
      Path()
        ..moveTo(size.width * 0.02, size.height * 0.50)
        ..cubicTo(
          size.width * 0.16,
          size.height * 0.45,
          size.width * 0.20,
          size.height * 0.63,
          size.width * 0.40,
          size.height * 0.68,
        ),
    ];
    for (var index = 0; index < waterRibbons.length; index++) {
      canvas.drawPath(
        waterRibbons[index],
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = scale * (index == 0 ? 0.027 : 0.014)
          ..shader = const LinearGradient(
            colors: [
              Color(0x00FFFFFF),
              Color(0xFFF3FCFF),
              Color(0xFF82DDF5),
              Color(0x00A7E9FF),
            ],
          ).createShader(bounds)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, scale * 0.008),
      );
    }

    final splashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = scale * 0.004
      ..color = const Color(0xAAE9FBFF);
    for (var index = 0; index < 9; index++) {
      final startX = size.width * (0.03 + (index % 3) * 0.11);
      final startY = size.height * (0.32 + index * 0.045);
      final path = Path()
        ..moveTo(startX, startY)
        ..quadraticBezierTo(
          size.width * 0.20,
          startY - size.height * 0.13,
          size.width * (0.34 + (index % 2) * 0.08),
          startY + size.height * 0.05,
        );
      canvas.drawPath(path, splashPaint);
    }

    final randomBubbles = <Offset>[
      const Offset(0.05, 0.18),
      const Offset(0.13, 0.23),
      const Offset(0.20, 0.15),
      const Offset(0.31, 0.25),
      const Offset(0.42, 0.31),
      const Offset(0.08, 0.57),
      const Offset(0.17, 0.65),
      const Offset(0.28, 0.75),
      const Offset(0.40, 0.70),
      const Offset(0.48, 0.62),
      const Offset(0.57, 0.25),
      const Offset(0.89, 0.21),
      const Offset(0.96, 0.33),
      const Offset(0.93, 0.71),
      const Offset(0.74, 0.83),
      const Offset(0.58, 0.79),
      const Offset(0.06, 0.82),
      const Offset(0.36, 0.87),
    ];
    for (var index = 0; index < randomBubbles.length; index++) {
      final bubble = randomBubbles[index];
      final radius = scale * (0.004 + (index % 4) * 0.002);
      final position = Offset(size.width * bubble.dx, size.height * bubble.dy);
      canvas.drawCircle(
        position,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = scale * 0.002
          ..color = index.isEven
              ? const Color(0xDDF7FCFF)
              : const Color(0xCCFFD4A0),
      );
      canvas.drawCircle(
        position.translate(-radius * 0.32, -radius * 0.38),
        radius * 0.18,
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );
    }

    final sparks = Paint()..strokeCap = StrokeCap.round;
    for (var index = 0; index < 54; index++) {
      final x = size.width * (0.47 + (index * 37 % 51) / 100);
      final y = size.height * (0.17 + (index * 61 % 68) / 100);
      final radius = scale * (0.0015 + (index % 4) * 0.001);
      sparks.color = index.isEven
          ? const Color(0xCCFFCB69)
          : const Color(0x99FF5825);
      canvas.drawCircle(Offset(x, y), radius, sparks);
    }

    final vignette = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.88,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.78)],
        stops: const [0.48, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
