import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/city/models/add_city_request.dart';

mixin LoginMixin on GetxController {
  final loginState = Rx<ApiState<bool>>(const ApiInit());

  final loginFormKey = GlobalKey<FormState>();
  final loginPhoneInController = TextEditingController();

  Future<void> login(String phoneNumber) async {
    await ApiHandler().handleOperationApiCall<bool>(
      state: loginState,
      apiCall: () => ApiClient().post('login', body: {'phone': phoneNumber}),
      successMessage: 'تم تسجيل الدخول بنجاح',
    );
  }

  void resetLogin() {
    loginState.value = const ApiInit();
    loginPhoneInController.clear();
  }

  void disposeLoginControllers() {
    loginPhoneInController.dispose();
  }
}
