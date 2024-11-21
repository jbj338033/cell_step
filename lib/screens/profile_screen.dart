import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/common/glass_container.dart';
import '../widgets/common/neon_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 프로필 헤더
              GlassContainer(
                child: Column(
                  children: [
                    // 프로필 이미지
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.neonPurple,
                            AppColors.neonBlue,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPurple.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ).animate().scale().fadeIn(),

                    const SizedBox(height: 16),

                    // 플레이어 이름
                    Text(
                      'Player Name',
                      style: TextStyle(
                        color: AppColors.neonBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn().slideY(),

                    const SizedBox(height: 8),

                    // 레벨 및 경험치 바
                    _buildExperienceBar(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 통계 섹션
              NeonContainer(
                neonColor: AppColors.neonGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatGrid(),
                  ],
                ),
              ).animate().fadeIn().slideX(),

              const SizedBox(height: 16),

              // 업적 섹션
              NeonContainer(
                neonColor: AppColors.neonPink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: TextStyle(
                        color: AppColors.neonPink,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAchievements(),
                  ],
                ),
              ).animate().fadeIn().slideX(),

              const SizedBox(height: 16),

              // 설정 버튼
              _buildSettingsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: AppColors.neonYellow,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              'Level 42',
              style: TextStyle(
                color: AppColors.neonYellow,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black26,
          ),
          child: LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonYellow),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '7,500 / 10,000 XP',
          style: TextStyle(
            color: AppColors.neonYellow.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatGrid() {
    final stats = const [
      {'icon': Icons.timeline, 'label': 'Distance', 'value': '42.5 km'},
      {'icon': Icons.catching_pokemon, 'label': 'Points', 'value': '12,345'},
      {'icon': Icons.timer, 'label': 'Play Time', 'value': '24h 30m'},
      {'icon': Icons.emoji_events, 'label': 'Rank', 'value': '#123'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return GlassContainer(
          borderRadius: 12,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                stat['icon'] as IconData,
                color: AppColors.neonGreen,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                stat['value'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stat['label'] as String,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ).animate().scale(delay: Duration(milliseconds: index * 100));
      },
    );
  }

  Widget _buildAchievements() {
    final achievements = const [
      {'icon': Icons.speed, 'title': 'Speed Demon', 'progress': 0.8},
      {
        'icon': Icons.catching_pokemon,
        'title': 'Point Hunter',
        'progress': 0.6
      },
      {'icon': Icons.timeline, 'title': 'Marathon Runner', 'progress': 0.4},
      {'icon': Icons.whatshot, 'title': 'Power User', 'progress': 0.9},
    ];

    return Column(
      children: achievements.asMap().entries.map((entry) {
        final index = entry.key;
        final achievement = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassContainer(
            borderRadius: 12,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: AppColors.neonPink,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: achievement['progress'] as double,
                        backgroundColor: Colors.black26,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.neonPink),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${((achievement['progress'] as double) * 100).toInt()}%',
                  style: TextStyle(
                    color: AppColors.neonPink,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: index * 100)),
        );
      }).toList(),
    );
  }

  Widget _buildSettingsButton() {
    return GlassContainer(
      child: ListTile(
        leading: Icon(
          Icons.settings,
          color: AppColors.neonBlue,
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppColors.neonBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.neonBlue,
        ),
        onTap: () {
          // 설정 화면으로 이동
        },
      ),
    ).animate().fadeIn().slideX();
  }
}
