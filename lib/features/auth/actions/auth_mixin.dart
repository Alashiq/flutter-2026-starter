import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/storage/auth_storage.dart';
import 'package:starter/core/utils/app_actions.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/features/auth/models/auth_model.dart';

mixin AuthMixin on GetxController {
  final authState = Rx<ApiState<AuthModel>>(const ApiInit());
  final _authMixinStorage = AuthStorage();

  Future<void> makeAuth() async {
    final token = _authMixinStorage.readToken();

    if (token == null) {
      Get.offAllNamed('/login');
      return;
    }

    await ApiHandler().handleItemApiCall<AuthModel>(
      state: authState,
      apiCall: () => ApiClient().getAuth('user/profile'),
      fromJson: (json) => AuthModel.fromJson(json),
      dataKey: 'user',
    );

    final result = authState.value;
    if (result is ApiSuccess<AuthModel>) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().setAuthData(result.data);
      }
      if (result.data.status == 1) {
        Get.offAllNamed('/signup');
      } else {
        Get.offAllNamed('/home');
      }
    } else if (result is ApiUnauthorized) {
      AppActions.logout();
    }
  }
}
