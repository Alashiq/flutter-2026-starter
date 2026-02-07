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
    try {
      final response = await apiCall();

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          state.value = ApiSuccess(fromJson(body['data']));
        } else {
          state.value = const ApiEmpty();
        }
      } else if (response.statusCode == 204) {
        state.value = const ApiEmpty();
      } else if (response.statusCode == 401) {
        state.value = const ApiUnauthorized();
      } else if (response.statusCode == 403) {
        state.value = const ApiNoPermission();
      } else if (response.statusCode == 403) {
        state.value = const ApiNoPermission();
      } else if (response.statusCode == 404) {
        state.value = const ApiError(
          404,
          'الرابط غير موجود أو البيانات غير متوفرة',
        );
      } else {
        // Handle 404, 500, and other errors
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
    } on SocketException {
      state.value = const ApiNoInternet();
    } catch (e) {
      state.value = const ApiError(0, 'حدث خطأ غير متوقع');
    }
  }
}
