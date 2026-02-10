import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/widgets/dialog/alert_message.dart';
import 'package:starter/features/auth/models/auth_model.dart';

mixin ActivateMixin on GetxController {
  Rx<AuthModel?> get user;
  void setAuthData(AuthModel userData);

  final activateState = Rx<ApiState<AuthModel>>(const ApiInit());

  final activateFormKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  Future<void> activate(String phone, String otp) async {
    await ApiHandler().handleOperationApiCall<AuthModel>(
      state: activateState,
      apiCall: () =>
          ApiClient().post('activate', body: {'phone': phone, 'otp': otp}),
      fromJson: (json) => AuthModel.fromJson(json),
      dataKey: 'user',
      showSuccessMessage: false,
    );

    final userState = activateState.value;
    if (userState is ApiSuccess<AuthModel>) {
      setAuthData(userState.data);

      if (userState.data.status == 1) {
        showAlertMessage('مرحباً، يرجى إكمال بيانات حسابك');
        Get.offAllNamed('/signup');
      } else if (userState.data.status == 2) {
        showAlertMessage('مرحباً ${userState.data.firstName ?? ''}');
        Get.offAllNamed('/');
      }
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
