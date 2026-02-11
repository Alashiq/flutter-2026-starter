import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_state.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/core/widgets/view/api_view_multi.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/features/auth/models/city_user_model.dart';
import 'package:starter/shared/layout/back_layout_widget.dart';

class ChangeUserCityScreen extends StatelessWidget {
  const ChangeUserCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return AutoLoad(
      onLoad: () async {
        controller.resetChangeCity();
        await controller.fetchCities();
        // Optional: Pre-select current city if available in the fetched list
        if (controller.user.value?.city != null) {
          final currentCityName = controller.user.value!.city;
          final state = controller.citiesState.value;
          if (state is ApiSuccess<List<CityUserModel>>) {
            final existingCity = state.data.firstWhereOrNull(
              (city) => city.name == currentCityName,
            );
            if (existingCity != null) {
              controller.selectedCity.value = existingCity;
            }
          }
        }
      },
      builder: (context) => BackLayoutWidget(
        title: "تغيير المدينة",
        child: Column(
          children: [
            // ✅ مدينةك الحالية - تصميم مصغر وأنيق
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "مدينتك الحالية",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Obx(
                          () => Text(
                            controller.user.value?.city ?? "غير محدد",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // شارة توضح أنها المدينة الحالية (اختياري)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "حالية",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ عنوان القسم - مبسط وأقل حجماً
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "اختر مدينتك الجديدة",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),

            // ✅ قائمة المدن
            Expanded(
              child: Obx(
                () => ApiViewMulti<CityUserModel>(
                  state: controller.citiesState.value,
                  onReload: () => controller.fetchCities(),
                  builder: (cities) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      itemCount: cities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return Obx(() {
                          final isSelected =
                              controller.selectedCity.value?.id == city.id;
                          return _buildCityItem(city, isSelected, () {
                            controller.selectedCity.value = city;
                          });
                        });
                      },
                    );
                  },
                ),
              ),
            ),

            // ✅ زر الحفظ - بحجم أصغر وتصميم أنيق
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),

              child: Container(
                child: Obx(() {
                  final state = controller.changeCityState.value;
                  final bool isLoading = state is ApiLoading;
                  final bool isButtonEnabled =
                      !isLoading && controller.selectedCity.value != null;

                  return ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () => controller.changeUserCity()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ), // Ensure full width
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            "حفظ التغييرات",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityItem(
    CityUserModel city,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // أيقونة الموقع
            Icon(
              Icons.location_pin,
              size: 22,
              color: isSelected ? AppColors.primary : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                city.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(width: 8),
            // دائرة الاختيار
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
