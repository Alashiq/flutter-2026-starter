import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/features/auth/models/auth_model.dart';
import 'package:starter/features/city/models/city_model.dart';

mixin AuthMixin on GetxController {
  final cityState = Rx<ApiState<AuthModel>>(const ApiInit());

  Future<void> makeAuth() async {
    await ApiHandler().handleItemApiCall<AuthModel>(
      state: cityState,
      apiCall: () => ApiClient().getAuth('user/profile'),
      fromJson: (json) => AuthModel.fromJson(json),
      dataKey: 'user',
    );
  }
}
