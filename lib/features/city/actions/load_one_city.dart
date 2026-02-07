import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/features/city/models/city_model.dart';

mixin LoadOneCityMixin on GetxController {
  final cityState = Rx<ApiState<CityOneModel>>(const ApiInit());

  Future<void> loadOneCity(int cityId) async {
    await ApiHandler().handleItemApiCall<CityOneModel>(
      state: cityState,
      apiCall: () => ApiClient().get('ccity/$cityId'),
      fromJson: (json) => CityOneModel.fromJson(json),
    );
  }
}
