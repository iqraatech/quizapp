import 'dart:math';
import 'package:flutter/material.dart';

class FlipAnimation extends StatelessWidget {
  final bool showFront;
  final Widget front;
  final Widget back;

  const FlipAnimation({
    super.key,
    required this.showFront,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isFront = child!.key == const ValueKey('Front');
            var tilt = (animation.value - 0.5).abs() * 0.003;
            tilt = isFront ? tilt : -tilt;

            final value = isFront ? rotate.value : min(rotate.value, pi / 2);
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, tilt)
                ..rotateY(value),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
      layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
      child: showFront
          ? SizedBox(key: const ValueKey('Front'), child: front)
          : SizedBox(key: const ValueKey('Back'), child: back),
    );
  }
}