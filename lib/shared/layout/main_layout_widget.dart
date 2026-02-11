import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/shared/widgets/bottom_navbar_widget.dart';

class MainLayoutWidget extends StatelessWidget {
  final String title;
  final int activePageId;
  final Widget child;
  final List<Widget>? actions;

  const MainLayoutWidget({
    super.key,
    required this.title,
    required this.activePageId,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          child,
          BottomNavbarWidget(activePageId: activePageId),
        ],
      ),
    );
  }
}
