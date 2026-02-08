import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/city/models/add_city_request.dart';

mixin AddCityMixin on GetxController {
  final addCityState = Rx<ApiState<bool>>(const ApiInit());

  final addCityFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  Future<void> addCity(AddCityRequest request) async {
    await ApiHandler().handleOperationApiCall<bool>(
      state: addCityState,
      apiCall: () => ApiClient().post('citypg', body: request.toJson()),
      successMessage: 'تم إضافة المدينة بنجاح',
    );
  }

  void resetAddCity() {
    addCityState.value = const ApiInit();
    nameController.clear();
    descController.clear();
  }

  void disposeAddCityControllers() {
    nameController.dispose();
    descController.dispose();
  }
}
