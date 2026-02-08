import 'package:get/get.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/city/models/add_city_request.dart';
import 'package:starter/features/city/models/city_model.dart'; // Assuming response returns the created city

mixin AddCityMixin on GetxController {
  final addCityState = Rx<ApiState<CityOneModel>>(const ApiInit());

  Future<void> addCity(AddCityRequest request) async {
    await ApiHandler().handleItemApiCall<CityOneModel>(
      state: addCityState,
      apiCall: () => ApiClient().post('citypg', body: request.toJson()),
      fromJson: (json) => CityOneModel.fromJson(json),
    );
  }

  void resetAddCity() {
    addCityState.value = const ApiInit();
  }
}
