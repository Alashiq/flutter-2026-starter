import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/network/api_handler.dart';
import 'package:starter/core/network/api_client.dart';
import 'package:starter/core/network/api_state_paginated.dart';
import 'package:starter/features/city/models/city_paginated_model.dart';

mixin LoadPaginatedCityMixin on GetxController {
  final searchCityController = TextEditingController();

  final cityPaginatedState = Rx<ApiStatePaginated<CityPaginatedModel>>(
    const ApiPaginatedInit(),
  );
  int currentPage = 1;

  Future<void> loadPaginatedCity({bool isLoadMore = false}) async {
    final previousPage = currentPage;

    if (isLoadMore) {
      currentPage++;
    } else {
      currentPage = 1;
    }

    final searchQuery = searchCityController.text.isNotEmpty
        ? '&name=${searchCityController.text}'
        : '';
    final query = 'city?page=$currentPage$searchQuery';
    print(query);
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
    searchCityController.clear();
    cityPaginatedState.value = const ApiPaginatedInit();
  }
}
