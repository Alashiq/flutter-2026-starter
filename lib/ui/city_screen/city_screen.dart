import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:starter/core/widgets/view/api_view_one.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/features/city/city_controller.dart';

import 'package:starter/features/city/models/city_model.dart';

import '../../shared/layout/back_layout_widget.dart';

class CityScreen extends StatelessWidget {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityController());

    return AutoLoad(
      onLoad: () => controller.loadOneCity(1),
      builder: (context) => BackLayoutWidget(
        title: 'المدينة',
        child: Center(
          child: Obx(
            () => ApiViewOne(
              state: controller.cityState.value,
              onReload: () => controller.loadOneCity(1),
              builder: (city) => CityItemWidget(
                city: city,
                onReload: () => controller.loadOneCity(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CityItemWidget extends StatelessWidget {
  final CityOneModel city;
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
          city.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        if (city.description != null && city.description!.isNotEmpty)
          Text(city.description!),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onReload,
          child: const Text('تحديث البيانات'),
        ),
      ],
    );
  }
}
