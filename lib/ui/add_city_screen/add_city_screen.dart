import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/shared/validation/app_validators.dart';
import 'package:starter/features/city/city_controller.dart';
import 'package:starter/features/city/models/add_city_request.dart';

import '../../shared/layout/back_layout_widget.dart';

class AddCityScreen extends StatelessWidget {
  const AddCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CityController>();

    return AutoLoad(
      onLoad: () async => controller.resetAddCity(),
      builder: (context) => BackLayoutWidget(
        title: 'أضف مدينة',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.addCityFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                TextFormField(
                  controller: controller.nameController,
                  validator: AppValidators.required,
                  decoration: InputDecoration(
                    labelText: 'اسم المدينة',
                    hintText: 'أدخل اسم المدينة',
                    prefixIcon: const Icon(Icons.location_city),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: controller.descController,
                  validator: (val) => AppValidators.minLength(val, 10),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'الوصف (اختياري)',
                    hintText: 'أدخل وصفاً مختصراً للمدينة',
                    prefixIcon: const Icon(Icons.description),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.addCityFormKey.currentState!.validate()) {
                        final request = AddCityRequest(
                          name: controller.nameController.text,
                          description: controller.descController.text,
                        );
                        await controller.addCity(request);

                        final state = controller.addCityState.value;
                        if (state is ApiSuccess) {
                          Get.back(); // Go back to list
                          controller.loadPaginatedCity(); // Refresh list
                          // No need to reset manually if we want to keep the data or if we reset on next entry.
                          // But usually good to reset after success.
                          controller.resetAddCity();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إضافة المدينة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
