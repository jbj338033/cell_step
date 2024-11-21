import 'package:flutter/material.dart';
import '../../models/point.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PointMarkerWidget extends StatelessWidget {
  final GamePoint point;

  const PointMarkerWidget({
    super.key,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          duration: 1.seconds,
          curve: Curves.easeInOut,
        ),
        ScaleEffect(
          duration: 2.seconds,
          curve: Curves.easeInOut,
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: point.color.withOpacity(0.3),
          border: Border.all(
            color: point.color,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: point.color.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Animate(
          onComplete: (controller) => controller.repeat(),
          effects: [
            ScaleEffect(
              duration: 1.5.seconds,
              curve: Curves.easeInOut,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
            ),
            FadeEffect(
              duration: 1.5.seconds,
              curve: Curves.easeInOut,
              begin: 1,
              end: 0.7,
            ),
          ],
        ),
      ),
    );
  }
}

class PointValueIndicator extends StatelessWidget {
  final int value;
  final Color color;

  const PointValueIndicator({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        '+$value',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
        .animate(
          onComplete: (controller) => controller.repeat(),
        )
        .moveY(
          duration: 1.seconds,
          begin: 0,
          end: -20,
        )
        .fadeOut(
          duration: 800.milliseconds,
          delay: 200.milliseconds,
        );
  }
}
