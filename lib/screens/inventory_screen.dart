import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/common/glass_container.dart';
import '../widgets/common/neon_container.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 타이틀
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlassContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.backpack,
                      color: AppColors.neonGreen,
                      size: 24,
                    ).animate().fadeIn().scale(),
                    const SizedBox(width: 8),
                    Text(
                      'Inventory',
                      style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn().slideX(),
                  ],
                ),
              ),
            ),

            // 능력치 정보
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NeonContainer(
                neonColor: AppColors.neonBlue,
                child: Column(
                  children: [
                    _buildStatRow(context, 'Speed', 0.7),
                    _buildStatRow(context, 'Power', 0.5),
                    _buildStatRow(context, 'Range', 0.3),
                    _buildStatRow(context, 'Defense', 0.4),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 아이템 그리드
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassContainer(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 9, // 더미 데이터
                    itemBuilder: (context, index) {
                      return _buildInventoryItem(index)
                          .animate()
                          .fade(delay: Duration(milliseconds: 100 * index))
                          .scale(delay: Duration(milliseconds: 100 * index));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 8,
                    width: constraints.maxWidth * value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.neonBlue,
                          AppColors.neonBlue.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonBlue.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(int index) {
    return GestureDetector(
      onTap: () {
        // 아이템 상세 정보 표시
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.neonPurple.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPurple.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.diamond,
                color: AppColors.neonPurple,
                size: 32,
              )
                  .animate(
                    onComplete: (controller) => controller.repeat(),
                  )
                  .shimmer(
                    duration: 2.seconds,
                    color: AppColors.neonPurple.withOpacity(0.5),
                  ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'x${index + 1}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
