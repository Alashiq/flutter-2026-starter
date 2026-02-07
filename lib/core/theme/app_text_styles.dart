import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// نظام الطباعة في التطبيق
/// جميع أنماط النصوص المستخدمة في التطبيق معرفة هنا
class AppTextStyles {
  AppTextStyles._(); // منع إنشاء instance من الكلاس

  // النمط الأساسي مع خط Cairo
  static TextStyle get _baseStyle => GoogleFonts.cairo(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.normal,
  );

  // ========== Display Styles (عناوين كبيرة جداً) ==========

  /// عنوان كبير جداً - للصفحات الرئيسية
  static TextStyle get displayLarge => _baseStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// عنوان كبير - للعناوين المهمة
  static TextStyle get displayMedium => _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// عنوان متوسط
  static TextStyle get displaySmall => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  // ========== Headline Styles (عناوين) ==========

  /// عنوان كبير
  static TextStyle get headlineLarge => _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// عنوان متوسط
  static TextStyle get headlineMedium => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// عنوان صغير
  static TextStyle get headlineSmall => _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ========== Title Styles (عناوين فرعية) ==========

  /// عنوان فرعي كبير
  static TextStyle get titleLarge => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// عنوان فرعي متوسط
  static TextStyle get titleMedium => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// عنوان فرعي صغير
  static TextStyle get titleSmall => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ========== Body Styles (نصوص عادية) ==========

  /// نص عادي كبير
  static TextStyle get bodyLarge => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// نص عادي متوسط
  static TextStyle get bodyMedium => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// نص عادي صغير
  static TextStyle get bodySmall => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // ========== Label Styles (تسميات) ==========

  /// تسمية كبيرة
  static TextStyle get labelLarge => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// تسمية متوسطة
  static TextStyle get labelMedium => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// تسمية صغيرة
  static TextStyle get labelSmall => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ========== Button Styles (أزرار) ==========

  /// نص زر كبير
  static TextStyle get buttonLarge => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// نص زر متوسط
  static TextStyle get button => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// نص زر صغير
  static TextStyle get buttonSmall => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ========== Special Styles (أنماط خاصة) ==========

  /// نص توضيحي
  static TextStyle get caption => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// نص علوي صغير
  static TextStyle get overline => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // ========== Custom Styles (أنماط مخصصة) ==========

  /// نص مع خط سميك
  static TextStyle get bold => _baseStyle.copyWith(fontWeight: FontWeight.bold);

  /// نص مع خط نصف سميك
  static TextStyle get semiBold =>
      _baseStyle.copyWith(fontWeight: FontWeight.w600);

  /// نص مع خط متوسط
  static TextStyle get medium =>
      _baseStyle.copyWith(fontWeight: FontWeight.w500);

  /// نص مع خط خفيف
  static TextStyle get light =>
      _baseStyle.copyWith(fontWeight: FontWeight.w300);

  /// نص بلون ثانوي
  static TextStyle get secondary =>
      _baseStyle.copyWith(color: AppColors.textSecondary);

  /// نص معطل
  static TextStyle get disabled =>
      _baseStyle.copyWith(color: AppColors.textDisabled);

  /// نص على خلفية أساسية
  static TextStyle get onPrimary =>
      _baseStyle.copyWith(color: AppColors.textOnPrimary);

  /// نص بلون الخطأ
  static TextStyle get error => _baseStyle.copyWith(color: AppColors.error);

  /// نص بلون النجاح
  static TextStyle get success => _baseStyle.copyWith(color: AppColors.success);

  /// نص بلون التحذير
  static TextStyle get warning => _baseStyle.copyWith(color: AppColors.warning);
}
