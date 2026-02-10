import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/auth/models/auth_model.dart';

mixin SignUpMixin on GetxController {
  final signUpState = Rx<ApiState<AuthModel>>(const ApiInit());

  final signUpFormKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final cityIdController = TextEditingController();

  Future<void> signUp(String phone) async {
    await ApiHandler().handleOperationApiCall<AuthModel>(
      state: signUpState,
      apiCall: () => ApiClient().post(
        'signup',
        body: {
          'phone': phone,
          'firstname': firstNameController.text,
          'lastname': lastNameController.text,
          'city_id': cityIdController.text,
        },
      ),
      fromJson: (json) => AuthModel.fromJson(json),
      dataKey: 'user',
      successMessage: 'تم إنشاء الحساب بنجاح',
    );
  }

  void resetSignUp() {
    signUpState.value = const ApiInit();
    firstNameController.clear();
    lastNameController.clear();
    cityIdController.clear();
  }

  void disposeSignUpControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    cityIdController.dispose();
  }
}
