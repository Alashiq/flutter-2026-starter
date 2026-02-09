import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/shared/validation/app_validators.dart';
import 'package:starter/features/city/city_controller.dart';
import 'package:starter/features/city/models/add_city_request.dart';

class AddCityScreenStateful extends StatefulWidget {
  const AddCityScreenStateful({super.key});

  @override
  State<AddCityScreenStateful> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreenStateful> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final controller = Get.find<CityController>();

  @override
  void initState() {
    super.initState();
    controller.resetAddCity(); // Reset state on entry
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = AddCityRequest(
        name: _nameController.text,
        description: _descController.text,
      );
      await controller.addCity(request);

      final state = controller.addCityState.value;
      if (state is ApiSuccess) {
        Get.back(); // Go back to list
        controller.loadPaginatedCity(); // Refresh list
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('إضافة مدينة جديدة'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
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
                controller: _descController,
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
              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إضافة المدينة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
