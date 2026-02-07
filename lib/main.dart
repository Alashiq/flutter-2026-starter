import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starter/bootstrap.dart';
import 'package:starter/core/env/env_dev.dart';
import 'package:starter/core/env/env_prod.dart';

import 'core/env/env.dart';
import 'core/config/app_binding.dart';
import 'core/config/routes.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(Bootstrap(env: EnvProd()));
}
