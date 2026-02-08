import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';
import 'package:starter/core/widgets/view/api_view_paginated_with_button.dart';
import 'package:starter/features/city/city_controller.dart';
import 'package:starter/features/city/models/city_paginated_model.dart';

class CityPaginatedButtonScreen extends GetView<CityController> {
  const CityPaginatedButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPaginatedCity();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('المدن مع زر تحميل المزيد'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                controller.resetPagination();
                controller.loadPaginatedCity(search: value);
              },
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

          // Pagination Info
          Obx(() {
            final state = controller.cityPaginatedState.value;
            if (state is ApiPaginatedSuccess<CityPaginatedModel>) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الصفحة ${state.meta.currentPage} من ${state.meta.lastPage}',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      'إجمالي: ${state.meta.total} مدينة',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              );
            } else if (state is ApiPaginatedLoadingMore<CityPaginatedModel>) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الصفحة ${state.meta.currentPage} من ${state.meta.lastPage}',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      'إجمالي: ${state.meta.total} مدينة',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // List View with Button Pagination
          Expanded(
            child: Obx(
              () => ApiViewPaginatedWithButton<CityPaginatedModel>(
                state: controller.cityPaginatedState.value,
                onReload: () {
                  controller.resetPagination();
                  controller.loadPaginatedCity();
                },
                onLoadMore: () =>
                    controller.loadPaginatedCity(isLoadMore: true),
                onRetry: () {
                  controller.resetPagination();
                  controller.loadPaginatedCity();
                },
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
                      return _CityCard(city: city, index: index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final CityPaginatedModel city;
  final int index;

  const _CityCard({required this.city, required this.index});

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
          // Index Badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // City Icon
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

          // City Info
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
                if (city.latitude != null && city.longitude != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'الموقع: ${city.latitude?.toStringAsFixed(2)}, ${city.longitude?.toStringAsFixed(2)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textDisabled,
                    ),
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
