import 'package:flutter/material.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/core/widgets/loading/loading_inside.dart';
import 'package:starter/core/widgets/screen_status/base_screen_status.dart';
import 'package:starter/core/widgets/screen_status/empty_screen.dart';
import 'package:starter/core/widgets/screen_status/error_screen.dart';
import 'package:starter/core/widgets/screen_status/no_internet_screen.dart';
import 'package:starter/core/widgets/screen_status/no_permission_screen.dart';

class ApiViewPaginated<T> extends StatefulWidget {
  final ApiStatePaginated<T> state;
  final Widget Function(List<T> items, ScrollController scrollController)
  builder;
  final VoidCallback onReload;
  final VoidCallback onLoadMore;
  final VoidCallback? onRetry;

  const ApiViewPaginated({
    super.key,
    required this.state,
    required this.builder,
    required this.onReload,
    required this.onLoadMore,
    this.onRetry,
  });

  @override
  State<ApiViewPaginated<T>> createState() => _ApiViewPaginatedState<T>();
}

class _ApiViewPaginatedState<T> extends State<ApiViewPaginated<T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = 200.0; // تحميل المزيد قبل الوصول للنهاية بـ 200 بكسل

    if (currentScroll >= (maxScroll - delta)) {
      final state = widget.state;
      print('🟣 Scroll reached threshold - State type: ${state.runtimeType}');

      if (state is ApiPaginatedSuccess<T>) {
        print('🟣 Is ApiPaginatedSuccess');
        print('🟣 Has next page: ${state.meta.hasNextPage}');
        print('🟣 Is last page: ${state.meta.isLastPage}');
        print('🟣 Current page: ${state.meta.currentPage}');
        print('🟣 Last page: ${state.meta.lastPage}');

        if (!state.meta.isLastPage) {
          print('🟣 Calling onLoadMore()');
          _isLoadingMore = true;
          widget.onLoadMore();
          Future.delayed(const Duration(milliseconds: 500), () {
            _isLoadingMore = false;
          });
        } else {
          print('🟣 Already on last page, not loading more');
        }
      } else {
        print('🟣 State is not ApiPaginatedSuccess');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.state) {
      ApiPaginatedInit() ||
      ApiPaginatedLoading() => const LoadingInsideWidget(),
      ApiPaginatedLoadingMore(currentData: final data, meta: final meta) =>
        _buildSuccessWithLoadingIndicator(data, meta),
      ApiPaginatedSuccess(data: final data, meta: final meta) =>
        data.isEmpty
            ? EmptyScreen(onRetry: widget.onRetry)
            : _buildSuccess(data, meta),
      ApiPaginatedEmpty() => EmptyScreen(onRetry: widget.onRetry),
      ApiPaginatedError(
        message: final msg,
        currentData: final data,
        meta: final meta,
      ) =>
        data != null && data.isNotEmpty
            ? _buildSuccessWithError(data, meta, msg)
            : ErrorScreen(message: msg, onRetry: widget.onReload),
      ApiPaginatedNoInternet(currentData: final data, meta: final meta) =>
        data != null && data.isNotEmpty
            ? _buildSuccessWithError(data, meta, 'لا يوجد اتصال بالإنترنت')
            : NoInternetScreen(onRetry: widget.onReload),
      ApiPaginatedUnauthorized() => BaseScreenStatus(
        title: 'غير مصرح',
        message: 'يجب تسجيل الدخول للوصول إلى هذا المحتوى',
        icon: Icons.lock_outline_rounded,
        onRetry: widget.onReload,
        retryText: 'تسجيل الدخول',
        primaryColor: const Color(0xFFDC2626),
      ),
      ApiPaginatedNoPermission() => NoPermissionScreen(
        onRetry: widget.onReload,
      ),
    };
  }

  Widget _buildSuccess(List<T> data, meta) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onReload();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: widget.builder(data, _scrollController),
    );
  }

  Widget _buildSuccessWithLoadingIndicator(List<T> data, meta) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              widget.onReload();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: widget.builder(data, _scrollController),
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
              widget.onReload();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: widget.builder(data, _scrollController),
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
                onPressed: widget.onLoadMore,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
