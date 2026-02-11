import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/core/widgets/dialog/alert_message.dart';
import 'package:starter/core/network/models/pagination_meta.dart';
import 'package:starter/core/utils/app_actions.dart';
import 'package:starter/core/widgets/loading/loading.dart';

class ApiHandler {
  Future<void> handleItemApiCall<T>({
    required Rx<ApiState<T>> state,
    required Future<http.Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
    String dataKey = 'data',
  }) async {
    state.value = const ApiLoading();
    await Future.delayed(const Duration(seconds: 1));

    try {
      final response = await apiCall();
      _processResponse<T>(
        response: response,
        state: state,
        onSuccess: (body) {
          if (body[dataKey] != null) {
            print(body[dataKey]);
            state.value = ApiSuccess(fromJson(body[dataKey]));
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
    String dataKey = 'data',
  }) async {
    state.value = const ApiLoading();
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await apiCall();
      _processResponse<List<T>>(
        response: response,
        state: state,
        onSuccess: (body) {
          if (body[dataKey] != null && body[dataKey] is List) {
            final List<dynamic> data = body[dataKey];
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
    VoidCallback? onLoadMoreFailed,
    String dataKey = 'data',
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

      final success = _processPaginatedResponse<T>(
        response: response,
        state: state,
        currentData: currentData,
        fromJson: fromJson,
        isLoadMore: isLoadMore,
        dataKey: dataKey,
      );

      // إذا فشل تحميل المزيد
      if (!success &&
          isLoadMore &&
          currentData != null &&
          currentMeta != null) {
        print('🔴 Load more failed, reverting to previous state');
        state.value = ApiPaginatedSuccess(currentData, currentMeta);

        if (onLoadMoreFailed != null) {
          onLoadMoreFailed();
        }

        showAlertMessage(
          _getErrorMessage(response.statusCode),
          type: AlertType.error,
        );
      }
    } on SocketException {
      print('🔴 SocketException - No Internet');

      if (isLoadMore && currentData != null && currentMeta != null) {
        state.value = ApiPaginatedSuccess(currentData, currentMeta);

        if (onLoadMoreFailed != null) {
          onLoadMoreFailed();
        }

        showAlertMessage('لا يوجد اتصال بالإنترنت', type: AlertType.noInternet);
      } else {
        state.value = ApiPaginatedNoInternet(
          currentData: currentData,
          meta: currentMeta,
        );
      }
    } catch (e) {
      print('🔴 Error: $e');

      if (isLoadMore && currentData != null && currentMeta != null) {
        state.value = ApiPaginatedSuccess(currentData, currentMeta);

        if (onLoadMoreFailed != null) {
          onLoadMoreFailed();
        }

        showAlertMessage('حدث خطأ غير متوقع', type: AlertType.error);
      } else {
        state.value = ApiPaginatedError(
          0,
          'حدث خطأ غير متوقع: $e',
          currentData: currentData,
          meta: currentMeta,
        );
      }
    }
  }

  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 204:
        return 'البيانات غير متوفرة';
      case 500:
        return 'حدث خطأ في الخادم';
      case 401:
        return 'انتهت الجلسة، يرجى تسجيل الدخول';
      case 403:
        return 'لا تمتلك الصلاحية لهذه العملية';
      default:
        return 'فشل تحميل المزيد من البيانات';
    }
  }

  bool _processPaginatedResponse<T>({
    required http.Response response,
    required Rx<ApiStatePaginated<T>> state,
    required List<T>? currentData,
    required T Function(Map<String, dynamic>) fromJson,
    required bool isLoadMore,
    required String dataKey,
  }) {
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body[dataKey] != null) {
        final paginationData = body[dataKey];
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
            return false;
          } else {
            print('🟡 Setting ApiPaginatedSuccess');
            state.value = ApiPaginatedSuccess(finalData, meta);
            return true;
          }
        } else {
          print('🔴 No data array in response');
          state.value = const ApiPaginatedEmpty();
          return false;
        }
      } else {
        print('🔴 Response success=false or no data');
        // عند تحميل المزيد، لا نغير الحالة هنا
        if (!isLoadMore) {
          state.value = ApiPaginatedError(
            200,
            body['message'] ?? 'فشلت العملية',
            currentData: currentData,
          );
        }
        return false;
      }
    } else if (response.statusCode == 204) {
      if (!isLoadMore) {
        state.value = const ApiPaginatedEmpty();
      }
      return false;
    } else if (response.statusCode == 401) {
      if (!isLoadMore) {
        state.value = const ApiPaginatedUnauthorized();
        AppActions.logout();
      }
      return false;
    } else if (response.statusCode == 403) {
      if (!isLoadMore) {
        state.value = const ApiPaginatedNoPermission();
      }
      return false;
    } else if (response.statusCode == 404) {
      if (!isLoadMore) {
        state.value = ApiPaginatedError(
          404,
          'الرابط غير موجود أو البيانات غير متوفرة',
          currentData: currentData,
        );
      }
      return false;
    } else {
      if (!isLoadMore) {
        try {
          final body = jsonDecode(response.body);
          state.value = ApiPaginatedError(
            response.statusCode,
            body['message'] ?? 'خطأ غير معروف',
            currentData: currentData,
          );
        } catch (e) {
          state.value = ApiPaginatedError(
            response.statusCode,
            'خطأ غير معروف',
            currentData: currentData,
          );
        }
      }
      return false;
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
      AppActions.logout();
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

  // Make response not required

  Future<void> handleOperationApiCall<T>({
    required Rx<ApiState<T>> state,
    required Future<http.Response> Function() apiCall,
    T Function(dynamic)? fromJson, // Made optional and dynamic input
    String? successMessage,
    String dataKey = 'data',
    bool showSuccessMessage = true,
  }) async {
    showLoading(); // Show global loading
    state.value = const ApiLoading();
    await Future.delayed(const Duration(seconds: 1)); // Add 2 seconds delay

    try {
      final response = await apiCall();
      final body = jsonDecode(response.body);

      stopLoading(); // Stop loading before showing alerts

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['success'] == true) {
          T data;
          if (fromJson != null) {
            data = fromJson(body[dataKey] ?? {});
          } else {
            // Default handling if fromJson is missing
            if (T == bool) {
              // Unsafe cast, but standard for success check
              data = true as T;
            } else if (body[dataKey] != null && body[dataKey] is T) {
              data = body[dataKey] as T;
            } else {
              // Fallback: try to cast or assume dynamic
              data = (body[dataKey] ?? {}) as T;
            }
          }
          state.value = ApiSuccess(data);

          if (showSuccessMessage &&
              (successMessage != null || body['message'] != null)) {
            showAlertMessage(
              successMessage ?? body['message'],
              type: AlertType.success,
            );
          }
        } else {
          final msg = body['message'] ?? 'فشلت العميله';
          state.value = ApiError(200, msg);
          showAlertMessage(msg, type: AlertType.error);
        }
      } else if (response.statusCode == 401) {
        state.value = const ApiUnauthorized();
        AppActions.logout();
        showAlertMessage(
          'انتهت الجلسة، يرجى تسجيل الدخول',
          type: AlertType.unauthorized,
        );
      } else if (response.statusCode == 403) {
        state.value = const ApiNoPermission();
        showAlertMessage(
          'لا تمتلك الصلاحية لهذه العملية',
          type: AlertType.noPermission,
        );
      } else if (response.statusCode == 404) {
        const msg = 'الرابط غير موجود';
        state.value = const ApiError(404, msg);
        showAlertMessage(msg, type: AlertType.noInternet);
      } else {
        final msg = body['message'] ?? 'خطأ غير معروف';
        state.value = ApiError(response.statusCode, msg);
        showAlertMessage(msg, type: AlertType.error);
      }
    } on SocketException {
      stopLoading();
      state.value = const ApiNoInternet();
      showAlertMessage('لا يوجد اتصال بالإنترنت', type: AlertType.noInternet);
    } catch (e) {
      stopLoading();
      final msg = 'حدث خطأ غير متوقع: $e';
      state.value = ApiError(0, msg);
      showAlertMessage('حدث خطأ غير متوقع', type: AlertType.error);
    }
  }
}
