import 'package:flutter/material.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/widgets/loading/loading_inside.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';
import 'package:starter/core/widgets/screen_status/empty_screen.dart';
import 'package:starter/core/widgets/screen_status/error_screen.dart';
import 'package:starter/core/widgets/screen_status/no_internet_screen.dart';
import 'package:starter/core/widgets/screen_status/no_permission_screen.dart';

class ApiViewMulti<T> extends StatelessWidget {
  final ApiState<List<T>> state;
  final Widget Function(List<T>) builder;
  final VoidCallback onReload;
  final VoidCallback? onRetry;
  final bool logoutButton;

  const ApiViewMulti({
    super.key,
    required this.state,
    required this.builder,
    required this.onReload,
    this.onRetry,
    this.logoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ApiInit() || ApiLoading() => const LoadingInsideWidget(),
      ApiSuccess<List<T>>(data: final list) =>
        list.isEmpty
            ? EmptyScreen(onRetry: onRetry, logoutButton: logoutButton)
            : builder(list),
      ApiEmpty() => EmptyScreen(onRetry: onRetry, logoutButton: logoutButton),
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
        icon: Icons.lock_outline_rounded,
        onRetry: onReload,
        retryText: 'إعادة المحاولة',
        primaryColor: const Color(0xFFDC2626),
        logoutButton: logoutButton,
      ),
      ApiNoPermission() => NoPermissionScreen(
        onRetry: onReload,
        logoutButton: logoutButton,
      ),
    };
  }
}
