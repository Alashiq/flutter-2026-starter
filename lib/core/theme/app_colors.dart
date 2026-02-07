import 'package:flutter/material.dart';

/// مركز إدارة الألوان في التطبيق
/// جميع الألوان المستخدمة في التطبيق يجب أن تكون معرفة هنا
class AppColors {
  AppColors._(); // منع إنشاء instance من الكلاس

  // ========== الألوان الأساسية ==========

  /// اللون الأساسي للتطبيق
  static const Color primary = Color(0xFF2563EB); // Blue 600

  /// اللون الثانوي
  static const Color secondary = Color(0xFF7C3AED); // Violet 600

  /// لون التمييز
  static const Color accent = Color(0xFF06B6D4); // Cyan 600

  // ========== ألوان الخلفية ==========

  /// خلفية التطبيق الرئيسية
  static const Color background = Color(0xFFF9FAFB); // Gray 50

  /// لون السطح (للكروت والشيتات)
  static const Color surface = Color(0xFFFFFFFF); // White

  /// خلفية ثانوية
  static const Color backgroundSecondary = Color(0xFFF3F4F6); // Gray 100

  // ========== ألوان النصوص ==========

  /// لون النص الأساسي
  static const Color textPrimary = Color(0xFF111827); // Gray 900

  /// لون النص الثانوي
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500

  /// لون النص المعطل
  static const Color textDisabled = Color(0xFF9CA3AF); // Gray 400

  /// لون النص على الخلفية الأساسية
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  /// لون النص على الخلفية الداكنة
  static const Color textOnDark = Color(0xFFFFFFFF); // White

  // ========== الألوان الدلالية ==========

  /// لون النجاح
  static const Color success = Color(0xff90b06e); // Green 500

  /// لون الخطأ
  static const Color error = Color(0xFFEF4444); // Red 500

  /// لون التحذير
  static const Color warning = Color(0xFFF59E0B); // Amber 500

  /// لون المعلومات
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // ========== ألوان الحدود والفواصل ==========

  /// لون الحدود
  static const Color border = Color(0xFFE5E7EB); // Gray 200

  /// لون الفواصل
  static const Color divider = Color(0xFFF3F4F6); // Gray 100

  /// لون الحدود الداكنة
  static const Color borderDark = Color(0xFFD1D5DB); // Gray 300

  // ========== ألوان الظلال ==========

  /// ظل خفيف
  static Color shadowLight = Colors.black.withOpacity(0.05);

  /// ظل متوسط
  static Color shadowMedium = Colors.black.withOpacity(0.1);

  /// ظل داكن
  static Color shadowDark = Colors.black.withOpacity(0.2);

  // ========== ألوان الحالة ==========

  /// حالة نشط
  static const Color active = Color(0xFF10B981); // Green

  /// حالة غير نشط
  static const Color inactive = Color(0xFF6B7280); // Gray

  /// حالة معلق
  static const Color pending = Color(0xFFF59E0B); // Amber

  /// حالة مؤرشف
  static const Color archived = Color(0xFF9CA3AF); // Light Gray

  // ========== ألوان إضافية ==========

  /// طبقة تغطية
  static Color overlay = Colors.black.withOpacity(0.5);

  /// طبقة تغطية خفيفة
  static Color overlayLight = Colors.black.withOpacity(0.3);

  /// لون شفاف
  static const Color transparent = Colors.transparent;

  // ========== تدرجات لونية ==========

  /// تدرج اللون الأساسي
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج لوني ثانوي
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
