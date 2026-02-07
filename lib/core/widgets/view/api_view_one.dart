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

  const ApiViewOne({
    super.key,
    required this.state,
    required this.builder,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ApiInit() || ApiLoading() => const LoadingInsideWidget(),
      ApiSuccess<T>(data: final item) => builder(item),
      ApiEmpty() => EmptyScreen(onRetry: onReload),
      ApiError(message: final msg) => ErrorScreen(
        message: msg,
        onRetry: onReload,
      ),
      ApiNoInternet() => NoInternetScreen(onRetry: onReload),
      ApiUnauthorized() => BaseScreenStatus(
        title: 'غير مصرح',
        message: 'يجب تسجيل الدخول للوصول إلى هذا المحتوى',
        imagePath:
            'assets/img/noPermission.webp', // Using same or different image
        onRetry: onReload, // Or navigate to login
        retryText: 'تسجيل الدخول',
      ),
      ApiNoPermission() => NoPermissionScreen(onRetry: onReload),
    };
  }
}
