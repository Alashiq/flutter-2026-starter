import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/auth/models/auth_model.dart';
import 'package:starter/features/auth/models/city_user_model.dart';

mixin ChangeUserCityMixin on GetxController {
  void setAuthData(AuthModel userData);

  final signUpState = Rx<ApiState<AuthModel>>(const ApiInit());
  final citiesState = Rx<ApiState<List<CityUserModel>>>(const ApiInit());

  final signUpFormKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final Rx<CityUserModel?> selectedCity = Rx<CityUserModel?>(null);

  Future<void> fetchCities() async {
    await ApiHandler().handleListApiCall<CityUserModel>(
      state: citiesState,
      apiCall: () => ApiClient().getAuth('city/list'),
      fromJson: (json) => CityUserModel.fromJson(json),
      dataKey: 'data',
    );
  }

  Future<void> signUp() async {
    await ApiHandler().handleOperationApiCall<AuthModel>(
      state: signUpState,
      apiCall: () => ApiClient().postAuth(
        'user/signup',
        body: {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'city_id': selectedCity.value?.id.toString() ?? '',
        },
      ),
      fromJson: (json) => AuthModel.fromJson(json),
      dataKey: 'user',
      successMessage: 'تم إنشاء الحساب بنجاح',
    );

    final result = signUpState.value;
    if (result is ApiSuccess<AuthModel>) {
      setAuthData(result.data);
      Get.offAllNamed('/home');
    }
  }

  void resetSignUp() {
    signUpState.value = const ApiInit();
    firstNameController.clear();
    lastNameController.clear();
    selectedCity.value = null;
  }

  void disposeSignUpControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
  }
}
