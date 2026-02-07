import 'package:get/get.dart';

import '../../features/city/city_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CityController>(CityController());
  }
}
