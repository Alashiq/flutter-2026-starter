import 'package:get/get.dart';
import 'package:starter/core/storage/onboarding_storage.dart';

mixin OnboardingMixin on GetxController {
  int onboarding = 0;

  void endBoarding() async {
    await OnboardingStorage().saveOnboardingSeen();
    Get.toNamed('/login');
  }
}
