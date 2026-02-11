import 'package:get/get.dart';
import 'package:starter/core/storage/auth_storage.dart';
import 'package:starter/features/auth/actions/auth_mixin.dart';

import 'actions/activate_mixin.dart';
import 'actions/login_mixin.dart';
import 'actions/signup_mixin.dart';
import 'actions/start_the_app_mixin.dart';
import 'models/auth_model.dart';

class AuthController extends GetxController
    with LoginMixin, ActivateMixin, SignUpMixin, AuthMixin, StartTheAppMixin {
  final AuthStorage _authStorage = AuthStorage();

  final Rx<AuthModel?> user = Rx<AuthModel?>(null);
  final RxString _token = ''.obs;

  String? get token => _token.value.isEmpty ? null : _token.value;

  @override
  void onInit() {
    super.onInit();
    loadAuthData();
  }

  void loadAuthData() {
    final savedToken = _authStorage.readToken();

    if (savedToken != null) {
      _token.value = savedToken;
    }
  }

  /// Set authentication data and persist to storage
  void setAuthData(AuthModel userData) {
    user.value = userData;

    if (userData.token != null) {
      _token.value = userData.token!;
    }
  }

  /// Clear auth data from state and storage
  /// For full logout with navigation, use [AppActions.logout]
  void logout() {
    user.value = null;
    _token.value = '';
    _authStorage.clearAll();
  }
}
