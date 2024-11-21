import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationUtils {
  // 펄스 애니메이션 컨트롤러 생성
  static AnimationController createPulseController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  // 회전 애니메이션 컨트롤러 생성
  static AnimationController createRotationController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  // 네온 효과 애니메이션
  static Widget addNeonEffect(
    Widget child, {
    required Color color,
    double intensity = 1.0,
    Duration duration = const Duration(seconds: 2),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3 * value * intensity),
                blurRadius: 20 * value,
                spreadRadius: 2 * value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // 물결 효과 애니메이션
  static Widget addRippleEffect(
    Widget child, {
    required Color color,
    required double size,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(3, (index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 2),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1 + (value * 0.5),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withOpacity((1 - value) * 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            child,
          ],
        );
      },
    );
  }

  // 페이드 인/아웃 트랜지션
  static Widget fadeTransition(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // 슬라이드 트랜지션
  static Widget slideTransition(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Offset beginOffset = const Offset(1.0, 0.0),
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: beginOffset, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // 스케일 트랜지션
  static Widget scaleTransition(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    double beginScale = 0.0,
    Curve curve = Curves.easeInOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: beginScale, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // 파티클 효과
  static Widget addParticleEffect(
    Widget child, {
    required Color color,
    int particleCount = 10,
    double maxRadius = 100,
  }) {
    return ParticleWidget(
      child: Stack(
        children: [
          child,
          ...List.generate(particleCount, (index) {
            final random = math.Random();
            final angle = random.nextDouble() * 2 * math.pi;
            final radius = random.nextDouble() * maxRadius;

            return Positioned(
              left: maxRadius + (radius * math.cos(angle)),
              top: maxRadius + (radius * math.sin(angle)),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 1 + random.nextInt(2)),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1 - value,
                    child: Opacity(
                      opacity: 1 - value,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ParticleWidget extends StatefulWidget {
  final Widget child;

  const ParticleWidget({
    super.key,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _StatefulWidgetState();
}

class _StatefulWidgetState extends State<ParticleWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
