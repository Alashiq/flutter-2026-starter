import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/core/widgets/view/api_view_multi.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/features/city/models/city_model.dart';
import 'package:starter/shared/validation/app_validators.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return AutoLoad(
      onLoad: () async {
        controller.resetSignUp();
        await controller.fetchCities();
      },
      builder: (context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: controller.signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'إنشاء حساب جديد',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'يرجى إكمال البيانات للتسجيل برقم\n${controller.user.value?.phone}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // First Name
                  _buildTextField(
                    label: 'الاسم الأول',
                    hint: 'أدخل اسمك الأول',
                    icon: Icons.person_outline,
                    controller: controller.firstNameController,
                  ),
                  const SizedBox(height: 20),

                  // Last Name
                  _buildTextField(
                    label: 'اللقب',
                    hint: 'أدخل لقبك',
                    icon: Icons.person_outline,
                    controller: controller.lastNameController,
                  ),
                  const SizedBox(height: 20),

                  // City Dropdown
                  _buildCityDropdown(controller),
                  const SizedBox(height: 40),

                  // Sign Up Button
                  Obx(() {
                    final state = controller.signUpState.value;
                    return ElevatedButton(
                      onPressed: state is ApiLoading
                          ? null
                          : () async {
                              if (controller.signUpFormKey.currentState!
                                  .validate()) {
                                await controller.signUp();
                                final result = controller.signUpState.value;
                                if (result is ApiSuccess) {
                                  // التوجيه لصفحة الملف الشخصي
                                  Get.offAllNamed('/profile');
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: state is ApiLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'تسجيل',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المدينة',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Obx(
          () => ApiViewMulti<CityOneModel>(
            state: controller.citiesState.value,
            onReload: () => controller.fetchCities(),
            onRetry: () => controller.fetchCities(),
            builder: (cities) {
              return DropdownButtonFormField<CityOneModel>(
                value: controller.selectedCity.value,
                validator: (value) {
                  if (value == null) {
                    return 'يرجى اختيار المدينة';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'اختر المدينة',
                  prefixIcon: Icon(
                    Icons.location_city_outlined,
                    color: AppColors.primary.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                items: cities.map((city) {
                  return DropdownMenuItem<CityOneModel>(
                    value: city,
                    child: Text(city.name),
                  );
                }).toList(),
                onChanged: (CityOneModel? value) {
                  controller.selectedCity.value = value;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: AppValidators.required,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
