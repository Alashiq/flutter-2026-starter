import 'package:get/get.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/features/city/models/city_paginated_model.dart';

mixin LoadPaginatedCityMixin on GetxController {
  final cityPaginatedState = Rx<ApiStatePaginated<CityPaginatedModel>>(
    const ApiPaginatedInit(),
  );
  int currentPage = 1;

  Future<void> loadPaginatedCity({
    bool isLoadMore = false,
    String? search,
  }) async {
    final previousPage = currentPage;

    if (isLoadMore) {
      currentPage++;
    } else {
      currentPage = 1;
    }

    final searchQuery = search != null && search.isNotEmpty
        ? '&name=$search'
        : '';
    final query = 'city?page=$currentPage$searchQuery';

    await ApiHandler().handlePaginatedApiCall<CityPaginatedModel>(
      state: cityPaginatedState,
      apiCall: () => ApiClient().getAuth(query),
      fromJson: (json) => CityPaginatedModel.fromJson(json),
      isLoadMore: isLoadMore,
      onLoadMoreFailed: () {
        currentPage = previousPage;
      },
      dataKey: 'data',
    );
  }

  void resetPagination() {
    currentPage = 1;
    cityPaginatedState.value = const ApiPaginatedInit();
  }
}
