import 'package:get/get.dart';

import 'actions/activate_mixin.dart';
import 'actions/login_mixin.dart';
import 'actions/signup_mixin.dart';
import 'models/auth_model.dart';

class AuthController extends GetxController
    with LoginMixin, ActivateMixin, SignUpMixin {
  // User data
  final Rx<AuthModel?> user = Rx<AuthModel?>(null);

  // TODO: Implement actual token logic
  String? get token => null; // Placeholder

  // Logout method
  void logout() {
    user.value = null;
    // TODO: Clear token from storage
  }
}
