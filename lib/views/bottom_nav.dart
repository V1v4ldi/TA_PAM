import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/modelviews/login_view_models.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 4:
        Future.microtask(() => Provider.of<LoginViewModels>(context, listen: false).logout());
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteOpacity10,
        border: Border(
          top: BorderSide(color: AppColors.whiteOpacity20, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOpacity30,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_rounded, 'Home', 0),
              _buildNavItem(context, Icons.search_rounded, 'Search', 1),
              _buildNavItem(context, Icons.person_rounded, 'Profile', 2),
              _buildNavItem(context, Icons.settings_rounded, 'Settings', 3),
              _buildNavItem(context, Icons.logout, 'Logout', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.purplePinkGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.grey300,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.grey300,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
