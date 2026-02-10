import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:starter/core/widgets/view/api_view_one.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/features/auth/models/auth_model.dart';
import 'package:starter/features/city/city_controller.dart';

import 'package:starter/features/city/models/city_model.dart';

import '../../shared/layout/back_layout_widget.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return AutoLoad(
      onLoad: () => controller.makeAuth(),
      builder: (context) => Scaffold(
        body: Center(
          child: Obx(
            () => ApiViewOne(
              state: controller.cityState.value,
              onReload: () => controller.makeAuth(),
              builder: (user) => CityItemWidget(
                city: user,
                onReload: () => controller.makeAuth(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CityItemWidget extends StatelessWidget {
  final AuthModel city;
  final VoidCallback onReload;

  const CityItemWidget({super.key, required this.city, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_city, size: 64, color: Colors.blue),
        const SizedBox(height: 16),
        Text(
          city.firstName!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        if (city.lastName != null && city.lastName!.isNotEmpty)
          Text(city.lastName!),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onReload,
          child: const Text('تحديث البيانات'),
        ),
      ],
    );
  }
}
