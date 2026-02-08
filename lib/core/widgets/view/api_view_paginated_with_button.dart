import 'package:flutter/material.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/widgets/loading/loading_inside.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';
import 'package:starter/core/widgets/screen_status/empty_screen.dart';
import 'package:starter/core/widgets/screen_status/error_screen.dart';
import 'package:starter/core/widgets/screen_status/no_internet_screen.dart';
import 'package:starter/core/widgets/screen_status/no_permission_screen.dart';

/// نسخة من ApiViewPaginated لكن مع زر "تحميل المزيد" بدلاً من infinite scroll
class ApiViewPaginatedWithButton<T> extends StatelessWidget {
  final ApiStatePaginated<T> state;
  final Widget Function(List<T> items) builder;
  final VoidCallback onReload;
  final VoidCallback onLoadMore;
  final VoidCallback? onRetry;

  const ApiViewPaginatedWithButton({
    super.key,
    required this.state,
    required this.builder,
    required this.onReload,
    required this.onLoadMore,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ApiPaginatedInit() ||
      ApiPaginatedLoading() => const LoadingInsideWidget(),
      ApiPaginatedLoadingMore(currentData: final data, meta: final meta) =>
        _buildSuccessWithLoadingIndicator(data, meta),
      ApiPaginatedSuccess(data: final data, meta: final meta) =>
        data.isEmpty
            ? EmptyScreen(onRetry: onRetry)
            : _buildSuccess(data, meta),
      ApiPaginatedEmpty() => EmptyScreen(onRetry: onRetry),
      ApiPaginatedError(
        message: final msg,
        currentData: final data,
        meta: final meta,
      ) =>
        data != null && data.isNotEmpty
            ? _buildSuccessWithError(data, meta, msg)
            : ErrorScreen(message: msg, onRetry: onReload),
      ApiPaginatedNoInternet(currentData: final data, meta: final meta) =>
        data != null && data.isNotEmpty
            ? _buildSuccessWithError(data, meta, 'لا يوجد اتصال بالإنترنت')
            : NoInternetScreen(onRetry: onReload),
      ApiPaginatedUnauthorized() => BaseScreenStatus(
        title: 'غير مصرح',
        message: 'يجب تسجيل الدخول للوصول إلى هذا المحتوى',
        icon: Icons.lock_outline_rounded,
        onRetry: onReload,
        retryText: 'تسجيل الدخول',
        primaryColor: const Color(0xFFDC2626),
      ),
      ApiPaginatedNoPermission() => NoPermissionScreen(onRetry: onReload),
    };
  }

  Widget _buildSuccess(List<T> data, meta) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              onReload();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: builder(data),
          ),
        ),
        // زر تحميل المزيد
        if (!meta.isLastPage)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.arrow_downward),
              label: Text(
                'تحميل المزيد (${meta.currentPage}/${meta.lastPage})',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSuccessWithLoadingIndicator(List<T> data, meta) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              onReload();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: builder(data),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('جاري تحميل المزيد...'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessWithError(List<T> data, meta, String errorMessage) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              onReload();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: builder(data),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.red.shade50,
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: onLoadMore,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
