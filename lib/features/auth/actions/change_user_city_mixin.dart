import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/features/auth/models/city_user_model.dart';
import 'package:starter/core/widgets/dialog/alert_message.dart';

mixin ChangeUserCityMixin on GetxController {
  // State for the change city operation
  final changeCityState = Rx<ApiState<bool>>(const ApiInit());

  // State for loading cities
  final citiesState = Rx<ApiState<List<CityUserModel>>>(const ApiInit());

  // Selected city
  final Rx<CityUserModel?> selectedCity = Rx<CityUserModel?>(null);

  // Fetch list of cities
  Future<void> fetchCities() async {
    // Reset state on start
    selectedCity.value = null;

    await ApiHandler().handleListApiCall<CityUserModel>(
      state: citiesState,
      apiCall: () => ApiClient().getAuth('city/list'),
      fromJson: (json) => CityUserModel.fromJson(json),
      dataKey: 'data',
    );
  }

  // Update user city
  Future<void> changeUserCity() async {
    if (selectedCity.value == null) {
      showAlertMessage('يرجى اختيار المدينة', type: AlertType.warning);
      return;
    }

    await ApiHandler().handleOperationApiCall<bool>(
      state: changeCityState,
      apiCall: () => ApiClient().postAuth(
        'user/city',
        body: {'city_id': selectedCity.value!.id.toString()},
      ),
      successMessage: 'تم تحديث المدينة بنجاح',
    );

    if (changeCityState.value is ApiSuccess) {
      final authController = Get.find<AuthController>();
      if (authController.user.value != null) {
        authController.user.value = authController.user.value!.copyWith(
          city: selectedCity.value!.name,
        );
        authController.user.refresh();
      }
      Get.back();
    }
  }

  void resetChangeCity() {
    changeCityState.value = const ApiInit();
    selectedCity.value = null;
    citiesState.value = const ApiInit();
  }
}
