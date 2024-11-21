import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/common/glass_container.dart';
import '../widgets/common/neon_container.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 타이틀과 포인트 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlassContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: AppColors.neonPink,
                          size: 24,
                        ).animate().fadeIn().scale(),
                        const SizedBox(width: 8),
                        Text(
                          'Shop',
                          style: TextStyle(
                            color: AppColors.neonPink,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn().slideX(),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.neonGreen.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: AppColors.neonGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '1,234',
                            style: TextStyle(
                              color: AppColors.neonGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 상품 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildShopItem(index)
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 100 * index))
                        .slideX(delay: Duration(milliseconds: 100 * index)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopItem(int index) {
    return NeonContainer(
      neonColor: _getItemColor(index),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getItemColor(index).withOpacity(0.5),
              ),
            ),
            child: Icon(
              _getItemIcon(index),
              color: _getItemColor(index),
              size: 40,
            )
                .animate(
                  onComplete: (controller) => controller.repeat(),
                )
                .shimmer(
                  duration: 2.seconds,
                  color: _getItemColor(index).withOpacity(0.5),
                ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getItemName(index),
                  style: TextStyle(
                    color: _getItemColor(index),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getItemDescription(index),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildBuyButton(_getItemPrice(index), _getItemColor(index)),
        ],
      ),
    );
  }

  Widget _buildBuyButton(int price, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // 구매 로직
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: color,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  price.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getItemColor(int index) {
    final colors = [
      AppColors.neonGreen,
      AppColors.neonBlue,
      AppColors.neonPurple,
      AppColors.neonPink,
      AppColors.neonYellow,
    ];
    return colors[index % colors.length];
  }

  IconData _getItemIcon(int index) {
    final icons = [
      Icons.speed,
      Icons.shield,
      Icons.flash_on,
      Icons.radar,
      Icons.catching_pokemon,
    ];
    return icons[index % icons.length];
  }

  String _getItemName(int index) {
    final names = [
      'Speed Boost',
      'Shield Generator',
      'Power Amplifier',
      'Range Extender',
      'Point Multiplier',
    ];
    return names[index % names.length];
  }

  String _getItemDescription(int index) {
    final descriptions = [
      'Increases movement speed by 30%',
      'Provides immunity for 10 seconds',
      'Doubles power for 30 seconds',
      'Extends collection range by 50%',
      'Doubles points for 1 minute',
    ];
    return descriptions[index % descriptions.length];
  }

  int _getItemPrice(int index) {
    final prices = [100, 200, 300, 400, 500];
    return prices[index % prices.length];
  }
}
