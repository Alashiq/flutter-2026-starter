import 'package:get/get.dart';
import 'package:starter/ui/add_city_screen/add_city_screen.dart';
import 'package:starter/ui/city_list_screen/city_list_screen.dart';
import 'package:starter/ui/city_screen/city_screen.dart';
import 'package:starter/ui/home_screen/home_screen.dart';
import 'package:starter/ui/city_paginated_screen/city_paginated_screen.dart';

final List<GetPage> routes = [
  GetPage(name: '/', page: () => HomeScreen()),
  GetPage(name: '/city_list', page: () => CityListScreen()),
  GetPage(name: '/city_list_paginated', page: () => CityPaginatedScreen()),
  GetPage(name: '/city', page: () => CityScreen()),
  GetPage(name: '/city_paginated', page: () => const CityPaginatedScreen()),
  GetPage(name: '/add_city', page: () => const AddCityScreen()),
];
