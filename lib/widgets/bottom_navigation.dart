import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xE61A2551), Color(0xE6251C49)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0x665F85FF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x551B6FFF),
            blurRadius: 24,
            offset: Offset(-7, 8),
          ),
          BoxShadow(
            color: Color(0x44FF4DC8),
            blurRadius: 22,
            offset: Offset(7, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: _NavItem(icon: Icons.home_rounded, label: 'Inicio'),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.calendar_month_rounded,
              label: 'Calendario',
              active: true,
            ),
          ),
          Expanded(
            child: _NavItem(icon: Icons.notifications_rounded, label: 'Avisos'),
          ),
          Expanded(
            child: _NavItem(icon: Icons.person_rounded, label: 'Perfil'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: active
          ? BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1B7CFF),
                  Color(0xFF7048FF),
                  Color(0xFFFF4ECD),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xB02C76FF),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
                BoxShadow(color: Color(0x80FF4DCE), blurRadius: 14),
              ],
            )
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: active ? Colors.white : const Color(0xFFC7D2FF),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFFC7D2FF),
              fontSize: 8.5,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
