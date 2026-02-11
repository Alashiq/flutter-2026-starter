import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class BottomNavbarWidget extends StatelessWidget {
  final int activePageId;
  const BottomNavbarWidget({super.key, required this.activePageId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(4, 0, 4, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 25,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem('home.svg', 'الرئيسية', '/home', 1),
            _buildNavItem(
              'map.svg',
              'المدن',
              '/city_paginated',
              2,
            ), // Changed route/icon as per likely app flow
            _buildNavItem(
              'trade.svg',
              'إضافة',
              '/add_city',
              3,
            ), // Center item, now flat
            _buildNavItem('bill.svg', 'الإشعارات', '/notifications', 4),
            _buildNavItem('user.svg', 'حسابي', '/profile', 5),
          ],
        ),
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              padding: EdgeInsets.all(isActive ? 10 : 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                'assets/svg/$iconName',
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.primary : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11.8,
                fontFamily: isActive ? 'SomarSans-Medium' : 'SomarSans-Regular',
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
