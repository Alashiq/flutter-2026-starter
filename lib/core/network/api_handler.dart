import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:starter/core/network/api_state.dart';

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
