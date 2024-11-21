import 'package:flutter/material.dart';
import 'dart:ui';
import '../../constants/colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final double blur;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.color,
    this.blur = 10,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: AppColors.glassBorder,
                  width: 1.5,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final double blur;

  const AnimatedGlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.color,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return GlassContainer(
          padding: padding,
          borderRadius: borderRadius,
          blur: blur * value,
          color: color?.withOpacity(0.1 * value),
          border: Border.all(
            color: AppColors.glassBorder.withOpacity(0.2 * value),
            width: 1.5 * value,
          ),
          child: child!,
        );
      },
      child: child,
    );
  }
}
