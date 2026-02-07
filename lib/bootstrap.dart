import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:starter/core/env/env.dart';
import 'package:starter/core/config/app_binding.dart';
import 'package:starter/core/config/routes.dart';
import 'package:starter/core/theme/app_theme.dart';

class Bootstrap extends StatelessWidget {
  final Env env;
  const Bootstrap({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    Get.put<Env>(env, permanent: true);

    return GetMaterialApp(
      title: env.appName,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      textDirection: TextDirection.rtl,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      initialBinding: AppBinding(),
      getPages: routes,
    );
  }
}
