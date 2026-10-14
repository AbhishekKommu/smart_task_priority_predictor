import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final colors = dark
        ? const [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)]
        : const [Color(0xFFE0E7FF), Color(0xFFF5F3FF), Color(0xFFFCE7F3)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _blob(240, const Color(0xFF8B5CF6).withValues(alpha: dark ? 0.25 : 0.18)),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _blob(300, const Color(0xFF06B6D4).withValues(alpha: dark ? 0.20 : 0.15)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      );
}
