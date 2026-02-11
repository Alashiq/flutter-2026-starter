import 'package:get/get.dart';
import 'package:starter/core/storage/onboarding_storage.dart';
import 'package:starter/features/auth/auth_controller.dart';

mixin StartTheAppMixin on GetxController {
  final _onboardingStorage = OnboardingStorage();

  Future<void> startTheApp() async {
    final authController = Get.find<AuthController>();
    if (!_onboardingStorage.isOnboardingSeen()) {
      Get.offAllNamed('/onboarding');
    } else {
      await authController.makeAuth();
    }
  }
}
