import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.icon,
    required this.color,
  });

  final DateTime date;
  final String title;
  final String description;
  final String time;
  final String category;
  final IconData icon;
  final Color color;
}

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.event, this.onDelete});

  final CalendarEvent event;
  final VoidCallback? onDelete;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        padding: const EdgeInsets.fromLTRB(14, 13, 10, 13),
        decoration: BoxDecoration(
          color: _hovered ? Colors.white : const Color(0xFFFAF9FD),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _hovered
                ? event.color.withValues(alpha: 0.28)
                : const Color(0xFFEDEAF3),
          ),
          boxShadow: _hovered
              ? const [
                  BoxShadow(
                    color: Color(0x120F1535),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 11),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: event.color.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(event.icon, color: event.color, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF252A41),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: event.color.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            color: event.color,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    event.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8C8FA2),
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: event.color,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        event.time,
                        style: TextStyle(
                          color: event.color,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.onDelete != null)
              PopupMenuButton<String>(
                tooltip: 'Opciones del evento',
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFFA5A6B2),
                  size: 20,
                ),
                onSelected: (value) {
                  if (value == 'delete') widget.onDelete?.call();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 19),
                        SizedBox(width: 10),
                        Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
