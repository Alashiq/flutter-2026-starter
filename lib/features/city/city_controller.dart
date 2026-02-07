import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:starter/features/city/actions/load_one_city.dart';
import 'package:starter/features/city/actions/load_list_city.dart';

class CityController extends GetxController
    with LoadOneCityMixin, LoadListCityMixin {}
