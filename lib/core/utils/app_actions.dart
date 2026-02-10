import 'package:get/get.dart';
import 'package:starter/features/auth/auth_controller.dart';

class AppActions {
  static Future<void> logout() async {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().logout();
    }

    Get.offAllNamed('/');
  }
}
