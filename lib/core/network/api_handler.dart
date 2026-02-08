import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/core/network/models/pagination_meta.dart';

class ApiHandler {
  Future<void> handleItemApiCall<T>({
    required Rx<ApiState<T>> state,
    required Future<http.Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    state.value = const ApiLoading();
    await Future.delayed(const Duration(seconds: 2));

    try {
      final response = await apiCall();
      _processResponse<T>(
        response: response,
        state: state,
        onSuccess: (body) {
          if (body['data'] != null) {
            state.value = ApiSuccess(fromJson(body['data']));
          } else {
            state.value = const ApiEmpty();
          }
        },
      );
    } on SocketException {
      state.value = const ApiNoInternet();
    } catch (e) {
      state.value = ApiError(0, 'حدث خطأ غير متوقع: $e');
    }
  }

  Future<void> handleListApiCall<T>({
    required Rx<ApiState<List<T>>> state,
    required Future<http.Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    state.value = const ApiLoading();
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await apiCall();
      _processResponse<List<T>>(
        response: response,
        state: state,
        onSuccess: (body) {
          if (body['data'] != null && body['data'] is List) {
            final List<dynamic> data = body['data'];
            state.value = ApiSuccess(
              data
                  .map((item) => fromJson(item as Map<String, dynamic>))
                  .toList(),
            );
          } else {
            state.value = const ApiEmpty();
          }
        },
      );
    } on SocketException {
      state.value = const ApiNoInternet();
    } catch (e) {
      state.value = ApiError(0, 'حدث خطأ غير متوقع: $e');
    }
  }

  Future<void> handlePaginatedApiCall<T>({
    required Rx<ApiStatePaginated<T>> state,
    required Future<http.Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
    required bool isLoadMore,
  }) async {
    print('🟢 handlePaginatedApiCall - isLoadMore: $isLoadMore');

    // حفظ البيانات الحالية في حالة LoadMore
    List<T>? currentData;
    PaginationMeta? currentMeta;

    if (isLoadMore && state.value is ApiPaginatedSuccess<T>) {
      final successState = state.value as ApiPaginatedSuccess<T>;
      currentData = successState.data;
      currentMeta = successState.meta;
      print(
        '🟢 Setting ApiPaginatedLoadingMore - current items: ${currentData.length}',
      );
      state.value = ApiPaginatedLoadingMore(currentData, currentMeta);
    } else {
      print('🟢 Setting ApiPaginatedLoading');
      state.value = const ApiPaginatedLoading();
    }

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final response = await apiCall();
      print('🟢 API Response status: ${response.statusCode}');
      _processPaginatedResponse<T>(
        response: response,
        state: state,
        currentData: currentData,
        fromJson: fromJson,
      );
    } on SocketException {
      print('🔴 SocketException - No Internet');
      state.value = ApiPaginatedNoInternet(
        currentData: currentData,
        meta: currentMeta,
      );
    } catch (e) {
      print('🔴 Error: $e');
      state.value = ApiPaginatedError(
        0,
        'حدث خطأ غير متوقع: $e',
        currentData: currentData,
        meta: currentMeta,
      );
    }
  }

  void _processPaginatedResponse<T>({
    required http.Response response,
    required Rx<ApiStatePaginated<T>> state,
    required List<T>? currentData,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] != null) {
        final paginationData = body['data'];
        final meta = PaginationMeta.fromJson(paginationData);

        print('🟡 Pagination Meta:');
        print('   - Current Page: ${meta.currentPage}');
        print('   - Last Page: ${meta.lastPage}');
        print('   - Per Page: ${meta.perPage}');
        print('   - Total: ${meta.total}');
        print('   - Has Next Page: ${meta.hasNextPage}');
        print('   - Is Last Page: ${meta.isLastPage}');

        if (paginationData['data'] != null && paginationData['data'] is List) {
          final List<dynamic> newItems = paginationData['data'];
          final List<T> parsedItems = newItems
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();

          print('🟡 New items count: ${parsedItems.length}');
          print('🟡 Current data count: ${currentData?.length ?? 0}');

          // دمج البيانات الجديدة مع القديمة في حالة LoadMore
          final List<T> finalData = currentData != null
              ? [...currentData, ...parsedItems]
              : parsedItems;

          print('🟡 Final data count: ${finalData.length}');

          if (finalData.isEmpty) {
            print('🟡 Setting ApiPaginatedEmpty');
            state.value = const ApiPaginatedEmpty();
          } else {
            print('🟡 Setting ApiPaginatedSuccess');
            state.value = ApiPaginatedSuccess(finalData, meta);
          }
        } else {
          print('🔴 No data array in response');
          state.value = const ApiPaginatedEmpty();
        }
      } else {
        print('🔴 Response success=false or no data');
        state.value = ApiPaginatedError(
          200,
          body['message'] ?? 'فشلت العملية',
          currentData: currentData,
        );
      }
    } else if (response.statusCode == 204) {
      state.value = const ApiPaginatedEmpty();
    } else if (response.statusCode == 401) {
      state.value = const ApiPaginatedUnauthorized();
    } else if (response.statusCode == 403) {
      state.value = const ApiPaginatedNoPermission();
    } else if (response.statusCode == 404) {
      state.value = ApiPaginatedError(
        404,
        'الرابط غير موجود أو البيانات غير متوفرة',
        currentData: currentData,
      );
    } else {
      try {
        final body = jsonDecode(response.body);
        state.value = ApiPaginatedError(
          response.statusCode,
          body['message'] ?? 'خطأ غير معروف',
          currentData: currentData,
        );
      } catch (_) {
        state.value = ApiPaginatedError(
          response.statusCode,
          'خطأ غير معروف',
          currentData: currentData,
        );
      }
    }
  }

  void _processResponse<T>({
    required http.Response response,
    required Rx<ApiState<T>> state,
    required Function(Map<String, dynamic>) onSuccess,
  }) {
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        onSuccess(body);
      } else {
        state.value = ApiError(200, body['message'] ?? 'فشلت العملية');
      }
    } else if (response.statusCode == 204) {
      state.value = const ApiEmpty();
    } else if (response.statusCode == 401) {
      state.value = const ApiUnauthorized();
    } else if (response.statusCode == 403) {
      state.value = const ApiNoPermission();
    } else if (response.statusCode == 404) {
      state.value = const ApiError(
        404,
        'الرابط غير موجود أو البيانات غير متوفرة',
      );
    } else {
      try {
        final body = jsonDecode(response.body);
        state.value = ApiError(
          response.statusCode,
          body['message'] ?? 'خطأ غير معروف',
        );
      } catch (_) {
        state.value = ApiError(response.statusCode, 'خطأ غير معروف');
      }
    }
  }
}
