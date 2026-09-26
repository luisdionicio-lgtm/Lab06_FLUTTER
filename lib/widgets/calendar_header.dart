import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.dayLabel,
    required this.eventCount,
  });

  final String dayLabel;
  final int eventCount;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Transform.translate(
        offset: Offset(0, 8 * (1 - value)),
        child: Container(
          height: 104,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF315BFF),
                Color(0xFF176FFF),
                Color(0xFF824BFF),
                Color(0xFFFF55B8),
              ],
              stops: [0, 0.35, 0.72, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: Colors.white.withValues(alpha: 0.38)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x7A176FFF),
                blurRadius: 24,
                spreadRadius: 1,
                offset: Offset(-5, 10),
              ),
              BoxShadow(
                color: Color(0x66FF4FC8),
                blurRadius: 23,
                offset: Offset(8, 9),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Stack(
              children: [
                Positioned(
                  right: -20 + (18 * value),
                  top: -46,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Color(0x66FFFFFF), blurRadius: 24),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 19,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white.withValues(alpha: 0.94),
                    size: 27,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.17),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.46),
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0x4DFFFFFF), blurRadius: 14),
                          ],
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dayLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.35,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$eventCount ${eventCount == 1 ? 'evento' : 'eventos'} este mes',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
