import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/core/widgets/screen_status/error_screen.dart';
import 'package:starter/core/widgets/screen_status/no_internet_screen.dart';
import 'package:starter/features/auth/auth_controller.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return AutoLoad(
      onLoad: () => controller.makeAuth(),
      builder: (context) => Scaffold(
        body: Center(
          child: Obx(() {
            final state = controller.authState.value;

            if (state is ApiLoading) {
              return const CircularProgressIndicator();
            }

            if (state is ApiNoInternet) {
              return NoInternetScreen(onRetry: () => controller.makeAuth());
            }

            if (state is ApiError) {
              return ErrorScreen(
                message: (state as ApiError).message,
                onRetry: () => controller.makeAuth(),
              );
            }

            // Fallback for initial state or other states
            return const CircularProgressIndicator();
          }),
        ),
      ),
    );
  }
}
