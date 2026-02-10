import 'package:flutter/material.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';
import 'package:starter/core/theme/app_colors.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool logoutButton;

  const ErrorScreen({
    super.key,
    required this.message,
    this.onRetry,
    this.logoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreenStatus(
      title: 'حدث خطأ ما',
      message: message,
      imagePath: null,
      icon: Icons.error_outline_rounded,
      onRetry: onRetry,
      retryText: 'إعادة المحاولة',
      primaryColor: AppColors.error,
      logoutButton: logoutButton,
    );
  }
}
