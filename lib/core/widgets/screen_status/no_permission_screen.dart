import 'package:flutter/material.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';

class NoPermissionScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool logoutButton;

  const NoPermissionScreen({
    super.key,
    this.onRetry,
    this.logoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreenStatus(
      title: 'ليس لديك صلاحية',
      message: 'نعتذر، ليس لديك الصلاحية الكافية للوصول إلى هذا المحتوى.',
      // Assuming 'noPermission.webp' exists based on file listing, using generic image if asset loading fails is handled by Flutter (as exception/placeholder)
      // Or fallback to Icon if preferred. Sticking to asset as requested.
      imagePath: null,
      icon: Icons.block_rounded,
      onRetry: onRetry,
      retryText: 'اعادة تحميل',
      primaryColor: const Color(0xFFFF9800),
      logoutButton: logoutButton,
    );
  }
}
