import 'package:flutter/material.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool logoutButton;

  const NoInternetScreen({super.key, this.onRetry, this.logoutButton = false});

  @override
  Widget build(BuildContext context) {
    return BaseScreenStatus(
      title: 'انقطع الاتصال',
      message:
          'نعتذر لا يتوفر أي اتصال بالإنترنت، قم بالتأكد من اتصالك وحاول مجدداً.',
      imagePath: null,
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      retryText: 'إعادة المحاولة',
      primaryColor: const Color(0xFFFF6B6B),
      logoutButton: logoutButton,
    );
  }
}
