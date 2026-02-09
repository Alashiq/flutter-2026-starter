import 'package:get/get.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/city/city_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<CityController>(CityController());
  }
}
