import 'package:get/get.dart';

import 'actions/activate_mixin.dart';
import 'actions/login_mixin.dart';

class AuthController extends GetxController with LoginMixin, ActivateMixin {
  // TODO: Implement actual user model and token logic
  String? get token => null; // Placeholder
}
