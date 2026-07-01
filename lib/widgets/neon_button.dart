import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NeonButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color neonColor;

  const NeonButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.neonColor = AppColors.neonYellow,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: widget.neonColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.neonColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.neonColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.neonColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}