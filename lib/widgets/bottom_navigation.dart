import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180B1025),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: const [
          Expanded(child: _NavItem(icon: Icons.home_rounded, label: 'Inicio')),
          Expanded(child: _NavItem(icon: Icons.calendar_month_rounded, label: 'Calendario', active: true)),
          Expanded(child: _NavItem(icon: Icons.notifications_rounded, label: 'Notificaciones')),
          Expanded(child: _NavItem(icon: Icons.person_rounded, label: 'Perfil')),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: active
              ? BoxDecoration(
                  gradient: AppColors.premiumGradient,
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Icon(
            icon,
            size: 20,
            color: active ? Colors.white : const Color(0xFF626A84),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: active ? AppColors.violet : const Color(0xFF626A84),
            fontSize: 9,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
