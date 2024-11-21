import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NeonContainer extends StatelessWidget {
  final Widget child;
  final Color neonColor;
  final double borderRadius;
  final double spreadRadius;
  final double blurRadius;
  final EdgeInsets padding;

  const NeonContainer({
    super.key,
    required this.child,
    this.neonColor = AppColors.neonGreen,
    this.borderRadius = 20,
    this.spreadRadius = 1,
    this.blurRadius = 15,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: neonColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          // 외부 그림자
          BoxShadow(
            color: neonColor.withOpacity(0.2),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          // 내부 효과를 위한 추가 그림자들
          BoxShadow(
            color: neonColor.withOpacity(0.1),
            blurRadius: blurRadius / 2,
            spreadRadius: -spreadRadius,
          ),
          BoxShadow(
            color: neonColor.withOpacity(0.05),
            blurRadius: blurRadius / 4,
            spreadRadius: -spreadRadius * 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

// 애니메이션이 있는 네온 컨테이너
class AnimatedNeonContainer extends StatefulWidget {
  final Widget child;
  final Color neonColor;
  final double borderRadius;
  final EdgeInsets padding;

  const AnimatedNeonContainer({
    super.key,
    required this.child,
    this.neonColor = AppColors.neonGreen,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<AnimatedNeonContainer> createState() => _AnimatedNeonContainerState();
}

class _AnimatedNeonContainerState extends State<AnimatedNeonContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.neonColor.withOpacity(_animation.value),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.neonColor.withOpacity(_animation.value - 0.1),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color:
                    widget.neonColor.withOpacity((_animation.value - 0.1) / 2),
                blurRadius: 8,
                spreadRadius: -1,
              ),
              BoxShadow(
                color:
                    widget.neonColor.withOpacity((_animation.value - 0.1) / 4),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
