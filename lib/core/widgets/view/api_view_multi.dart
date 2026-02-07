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

  const ApiViewMulti({
    super.key,
    required this.state,
    required this.builder,
    required this.onReload,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ApiInit() || ApiLoading() => const LoadingInsideWidget(),
      ApiSuccess<List<T>>(data: final list) =>
        list.isEmpty ? EmptyScreen(onRetry: onRetry) : builder(list),
      ApiEmpty() => EmptyScreen(onRetry: onRetry),
      ApiError(message: final msg) => ErrorScreen(
        message: msg,
        onRetry: onReload,
      ),
      ApiNoInternet() => NoInternetScreen(onRetry: onReload),
      ApiUnauthorized() => BaseScreenStatus(
        title: 'غير مصرح',
        message: 'يجب تسجيل الدخول للوصول إلى هذا المحتوى',
        icon: Icons.lock_outline_rounded,
        onRetry: onReload,
        retryText: 'تسجيل الدخول',
        primaryColor: const Color(0xFFDC2626),
      ),
      ApiNoPermission() => NoPermissionScreen(onRetry: onReload),
    };
  }
}
