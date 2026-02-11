import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/storage/onboarding_storage.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/core/theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(
                Icons.waving_hand_rounded,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: 32),
              const Text(
                'مرحباً بك في التطبيق',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'اكتشف مميزات التطبيق الجديدة واستمتع بتجربة فريدة.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Save that onboarding has been seen
                    await OnboardingStorage().saveOnboardingSeen();

                    // Proceed to authentication check
                    // We can find the AuthController and call makeAuth
                    if (Get.isRegistered<AuthController>()) {
                      Get.find<AuthController>().makeAuth();
                    } else {
                      // Fallback if controller not found (unlikely in this flow)
                      Get.offAllNamed('/');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ابدأ الآن',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
