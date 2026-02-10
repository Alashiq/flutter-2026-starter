import 'package:flutter/material.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';
import 'package:starter/core/theme/app_colors.dart';

class EmptyScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final String title;
  final String message;
  final bool logoutButton;

  const EmptyScreen({
    super.key,
    this.onRetry,
    this.title = 'لا توجد بيانات',
    this.message = 'هذه الصفحة لا تحتوي على أي عناصر حالياً.',
    this.logoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreenStatus(
      title: title,
      message: message,
      imagePath: 'assets/img/empty2.png',
      icon: null,
      onRetry: onRetry,
      retryText: 'تحديث البيانات',
      primaryColor: AppColors.primary,
      logoutButton: logoutButton,
    );
  }
}
