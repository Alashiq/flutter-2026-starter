import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starter/bootstrap.dart';
import 'package:starter/core/env/env_prod.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(Bootstrap(env: EnvProd()));
}
