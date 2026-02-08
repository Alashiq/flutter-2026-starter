import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';
import 'package:starter/core/widgets/view/api_view_multi.dart';
import 'package:starter/features/city/city_controller.dart';
import 'package:starter/features/city/models/city_list_model.dart';

class CityListScreen extends StatelessWidget {
  const CityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityController());

    return AutoLoad(
      onLoad: () => controller.loadListCity(),
      builder: (context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('قائمة المدن'), centerTitle: true),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => controller.loadListCity(search: value),
                decoration: InputDecoration(
                  hintText: 'ابحث عن مدينة...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // List View
            Expanded(
              child: Obx(
                () => ApiViewMulti<CityListModel>(
                  state: controller.cityListState.value,
                  onReload: () => controller.loadListCity(),
                  onRetry: () => controller.loadListCity(),
                  builder: (cities) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: cities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return _CityCard(city: city);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final CityListModel city;
  const _CityCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_city, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city.name, style: AppTextStyles.titleLarge),
                if (city.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    city.description!,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textDisabled,
          ),
        ],
      ),
    );
  }
}
