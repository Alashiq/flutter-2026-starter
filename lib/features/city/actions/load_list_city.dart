import 'package:get/get.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/features/city/models/city_list_model.dart';

mixin LoadListCityMixin on GetxController {
  final cityListState = Rx<ApiState<List<CityListModel>>>(const ApiInit());

  Future<void> loadListCity({String? search}) async {
    final query = search != null ? '?name=$search' : '';
    await ApiHandler().handleListApiCall<CityListModel>(
      state: cityListState,
      apiCall: () => ApiClient().get('ccity$query'),
      fromJson: (json) => CityListModel.fromJson(json),
      dataKey: 'data',
    );
  }
}
