import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:starter/features/city/actions/load_one_city.dart';
import 'package:starter/features/city/actions/load_list_city.dart';
import 'package:starter/features/city/actions/load_paginated_city.dart';

class CityController extends GetxController
    with LoadOneCityMixin, LoadListCityMixin, LoadPaginatedCityMixin {
  // TextEditingController للبحث في صفحة pagination
  final searchPaginatedController = TextEditingController();

  @override
  void onClose() {
    searchPaginatedController.dispose();
    super.onClose();
  }
}
