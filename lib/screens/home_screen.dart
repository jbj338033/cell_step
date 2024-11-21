import 'package:cell_step/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import 'map_screen.dart';
import 'inventory_screen.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MapScreen(),
    const InventoryScreen(),
    const ShopScreen(),
    const ProfileScreen(),
    const LoginScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.inactive,
              items: [
                _buildNavItem(Icons.map_outlined, Icons.map, 'Map', 0),
                _buildNavItem(
                    Icons.backpack_outlined, Icons.backpack, 'Inventory', 1),
                _buildNavItem(Icons.store_outlined, Icons.store, 'Shop', 2),
                _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
                _buildNavItem(Icons.login_outlined, Icons.login, 'Login', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(icon)
          .animate(target: _currentIndex == index ? 1 : 0)
          .scale(begin: const Offset(1, 1), end: const Offset(0.9, 0.9))
          .fade(),
      activeIcon: Icon(activeIcon)
          .animate()
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1))
          .fade()
          .shimmer(
              duration: 1200.ms, color: AppColors.primary.withOpacity(0.3)),
      label: label,
    );
  }
}
