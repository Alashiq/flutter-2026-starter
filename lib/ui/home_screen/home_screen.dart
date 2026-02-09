import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/env/env.dart';
import 'package:starter/core/widgets/dialog/alert_message.dart';
import 'package:starter/core/widgets/dialog/confirm_message.dart';
import 'package:starter/core/widgets/loading/loading.dart';
import 'package:starter/ui/city_screen/city_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final env = Get.find<Env>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: env.flavor == Flavor.dev ? Colors.blue : Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Name
                Text(
                  env.appName,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),

                // Environment Info Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معلومات البيئة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Flavor
                        _buildInfoRow(
                          'البيئة:',
                          env.flavor == Flavor.dev
                              ? 'تطوير (Dev)'
                              : 'إنتاج (Prod)',
                          env.flavor == Flavor.dev ? Colors.blue : Colors.green,
                        ),
                        SizedBox(height: 12),

                        // Base URL
                        _buildInfoRow(
                          'رابط API:',
                          env.baseUrl,
                          Colors.grey[700]!,
                        ),
                        SizedBox(height: 12),

                        // App Name
                        _buildInfoRow(
                          'اسم التطبيق:',
                          env.appName,
                          Colors.grey[700]!,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // أمثلة على التنبيهات
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "تم الحفظ بنجاح",
                          type: AlertType.success,
                        );
                      },
                      child: Text('نجاح'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "حدث خطأ أثناء العملية",
                          type: AlertType.error,
                        );
                      },
                      child: Text('خطأ'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "يرجى التحقق من البيانات",
                          type: AlertType.warning,
                        );
                      },
                      child: Text('تحذير'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "هذه رسالة معلومات عامة",
                          type: AlertType.info,
                        );
                      },
                      child: Text('معلومات'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "تحقق من اتصالك بالإنترنت وحاول مرة أخرى",
                          type: AlertType.noInternet,
                        );
                      },
                      child: Text('لا يوجد إنترنت'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "ليس لديك صلاحية للوصول إلى هذه الميزة",
                          type: AlertType.noPermission,
                        );
                      },
                      child: Text('لا توجد صلاحية'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertMessage(
                          "انتهت الجلسة، يرجى تسجيل الدخول",
                          type: AlertType.unauthorized,
                        );
                      },
                      child: Text('غير مصرح'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showConfirmMessage(
                          title: 'تأكيد الحذف',
                          message: 'هل أنت متأكد من رغبتك في حذف هذا العنصر؟',
                          isDangerous: true,
                          confirmButtonText: 'حذف',
                          onConfirm: () {
                            showAlertMessage(
                              "تم الحذف بنجاح",
                              type: AlertType.success,
                            );
                          },
                        );
                      },
                      child: Text('تجربة التأكيد'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    showLoading();
                  },
                  child: Text('تجربة التحميل'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/city');
                  },
                  child: const Text('City Screen (AutoLoad)'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/city_list');
                  },
                  child: const Text('City List Screen (AutoLoad)'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/city_paginated');
                  },
                  child: const Text('City Paginated Screen'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Login Screen UI'),
                ),
                // Instructions
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[300]!),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber[800]),
                      SizedBox(height: 8),
                      Text(
                        'لتغيير البيئة، قم بتشغيل التطبيق من ملف main مختلف',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
