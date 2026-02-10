import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';
import 'package:starter/core/widgets/auto_load/auto_load.dart';

import 'package:starter/features/city/city_controller.dart';

import 'package:starter/features/city/models/city_paginated_model.dart';
import 'package:starter/shared/layout/back_layout_widget.dart';

import '../../core/widgets/view/api_view_paginated.dart';

class CityPaginatedScreen extends StatelessWidget {
  const CityPaginatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityController());

    return AutoLoad(
      onLoad: () async {
        controller.resetPagination();
        await controller.loadPaginatedCity();
      },
      builder: (context) => BackLayoutWidget(
        title: 'قائمة المدن',
        child: Column(
          children: [
            // Search Field
            _SerchBardWidget(),
            Container(
              width: 160,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/add_city'),
                icon: const Icon(Icons.add),
                label: const Text('أضف مدينة جديدة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // List View
            Expanded(
              child: Obx(
                () => ApiViewPaginated<CityPaginatedModel>(
                  state: controller.cityPaginatedState.value,
                  onReload: () => controller.loadPaginatedCity(),
                  onRetry: () => controller.loadPaginatedCity(),
                  onLoadMore: () =>
                      controller.loadPaginatedCity(isLoadMore: true),
                  builder: (cities, meta) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children: [
                        ...cities.map(
                          (city) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CityCard(city: city),
                          ),
                        ),
                        if (meta != null && !meta.isLastPage)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton.icon(
                              onPressed: () => controller.loadPaginatedCity(
                                isLoadMore: true,
                              ),
                              icon: const Icon(Icons.arrow_downward),
                              label: Text(
                                'تحميل المزيد (${meta.currentPage}/${meta.lastPage})',
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),
                      ],
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
  final CityPaginatedModel city;
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

class _SerchBardWidget extends StatelessWidget {
  const _SerchBardWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityController());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) => controller.loadPaginatedCity(),
        controller: controller.searchCityController,
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
    );
  }
}
