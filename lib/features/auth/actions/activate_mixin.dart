import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/widgets/dialog/alert_message.dart';
import 'package:starter/features/auth/models/auth_model.dart';

mixin ActivateMixin on GetxController {
  final activateState = Rx<ApiState<AuthModel>>(const ApiInit());

  final activateFormKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  Future<void> activate(String phone, String otp) async {
    await ApiHandler().handleOperationApiCall<AuthModel>(
      state: activateState,
      apiCall: () =>
          ApiClient().post('activate', body: {'phone': phone, 'otp': otp}),
      successMessage: 'تم تفعيل الحساب بنجاح',
      fromJson: (json) => AuthModel.fromJson(json),
      dataKey: 'user',
    );
    if (activateState.value is ApiSuccess) {
      // show first name
      showAlertMessage(activateState.value.data!.firstName);
      Get.toNamed('/home');
    }
  }

  void resetActivate() {
    activateState.value = const ApiInit();
    otpController.clear();
  }

  void disposeActivateControllers() {
    otpController.dispose();
  }
}
