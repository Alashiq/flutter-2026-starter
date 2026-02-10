import 'package:flutter/material.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/widgets/loading/loading_inside.dart';
import 'package:starter/core/widgets/screen_status/empty_screen.dart';
import 'package:starter/core/widgets/screen_status/error_screen.dart';
import 'package:starter/core/widgets/screen_status/no_internet_screen.dart';
import 'package:starter/core/widgets/screen_status/no_permission_screen.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart'; // For generic unauthorized handling if needed or specific widget

class ApiViewOne<T> extends StatelessWidget {
  final ApiState<T> state;
  final Widget Function(T item) builder;
  final VoidCallback? onReload;
  final bool logoutButton;

  const ApiViewOne({
    super.key,
    required this.state,
    required this.builder,
    this.onReload,
    this.logoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ApiInit() || ApiLoading() => const LoadingInsideWidget(),
      ApiSuccess<T>(data: final item) => builder(item),
      ApiEmpty() => EmptyScreen(onRetry: onReload, logoutButton: logoutButton),
      ApiError(message: final msg) => ErrorScreen(
        message: msg,
        onRetry: onReload,
        logoutButton: logoutButton,
      ),
      ApiNoInternet() => NoInternetScreen(
        onRetry: onReload,
        logoutButton: logoutButton,
      ),
      ApiUnauthorized() => BaseScreenStatus(
        title: 'غير مصرح',
        message: 'يجب تسجيل الدخول للوصول إلى هذا المحتوى',
        imagePath: 'assets/img/noPermission.webp',
        onRetry: onReload,
        retryText: 'إعادة المحاولة',
        logoutButton: logoutButton,
      ),
      ApiNoPermission() => NoPermissionScreen(
        onRetry: onReload,
        logoutButton: logoutButton,
      ),
    };
  }
}
