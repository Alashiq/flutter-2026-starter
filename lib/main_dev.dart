import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starter/bootstrap.dart';
import 'package:starter/core/env/env_dev.dart';

/// Development flavor entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(Bootstrap(env: EnvDev()));
}
