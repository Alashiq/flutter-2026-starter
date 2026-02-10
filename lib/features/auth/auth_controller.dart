import 'package:get/get.dart';

import 'actions/activate_mixin.dart';
import 'actions/login_mixin.dart';
import 'actions/signup_mixin.dart';
import 'models/auth_model.dart';

class AuthController extends GetxController
    with LoginMixin, ActivateMixin, SignUpMixin {
  final Rx<AuthModel?> user = Rx<AuthModel?>(null);

  final RxString _token = ''.obs;

  String? get token => _token.value.isEmpty ? null : _token.value;

  void setAuthData(AuthModel userData) {
    user.value = userData;
    if (userData.token != null) {
      _token.value = userData.token!;
    }
  }

  // Logout
  void logout() {
    user.value = null;
    _token.value = '';
  }
}
