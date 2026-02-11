import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../core/theme/app_colors.dart';

class BottomNavbarWidget extends StatelessWidget {
  final int activePageId;
  const BottomNavbarWidget({super.key, required this.activePageId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('home.svg', 'الرئيسية', '/home', 1),
          _buildNavItem('home.svg', 'البحث', '/search', 2),
          _buildCenterNavItem(),
          _buildNavItem('home.svg', 'الإشعارات', '/notifications', 3),
          _buildNavItem('home.svg', 'الملف', '/profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String iconName,
    String label,
    String route,
    int pageId,
  ) {
    final isActive = activePageId == pageId;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isActive) return;
          Get.toNamed(route);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/${iconName}',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isActive ? AppColors.primary : AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, -25),
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/add');
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/home.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -25),
            child: Text(
              'إضافة',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
