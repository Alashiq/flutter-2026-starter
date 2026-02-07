import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';

/// عرض رسالة تنبيه مع تصميم حديث
///
/// [message] النص المراد عرضه
/// [title] العنوان (اختياري، افتراضياً "تنبيه")
/// [type] نوع التنبيه (info, warning, error, success)
void showAlertMessage(
  String message, {
  String? title,
  AlertType type = AlertType.info,
}) {
  BotToast.showCustomText(
    align: Alignment.center,
    toastBuilder: (close) {
      return _AlertMessageWidget(
        message: message,
        title: title,
        type: type,
        onClose: close,
      );
    },
    duration: null,
    onlyOne: true,
  );
}

/// أنواع التنبيهات
enum AlertType {
  info,
  warning,
  error,
  success,
  noInternet, // لا يوجد اتصال بالإنترنت
  noPermission, // لا توجد صلاحية
  unauthorized, // غير مصرح - فشل المصادقة
}

/// Widget التنبيه المخصص
class _AlertMessageWidget extends StatefulWidget {
  final String message;
  final String? title;
  final AlertType type;
  final VoidCallback onClose;

  const _AlertMessageWidget({
    required this.message,
    required this.type,
    required this.onClose,
    this.title,
  });

  @override
  State<_AlertMessageWidget> createState() => _AlertMessageWidgetState();
}

class _AlertMessageWidgetState extends State<_AlertMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // الحصول على لون حسب نوع التنبيه
  Color get _typeColor {
    switch (widget.type) {
      case AlertType.info:
        return AppColors.info;
      case AlertType.warning:
        return AppColors.warning;
      case AlertType.error:
        return AppColors.error;
      case AlertType.success:
        return AppColors.success;
      case AlertType.noInternet:
        return const Color(0xFFFF6B6B); // أحمر فاتح
      case AlertType.noPermission:
        return const Color(0xFFFF9800); // برتقالي داكن
      case AlertType.unauthorized:
        return const Color(0xFFDC2626); // أحمر داكن
    }
  }

  // الحصول على أيقونة حسب نوع التنبيه
  IconData get _typeIcon {
    switch (widget.type) {
      case AlertType.info:
        return Icons.info_outline_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.error:
        return Icons.error_outline_rounded;
      case AlertType.success:
        return Icons.check_circle_outline_rounded;
      case AlertType.noInternet:
        return Icons.wifi_off_rounded;
      case AlertType.noPermission:
        return Icons.block_rounded;
      case AlertType.unauthorized:
        return Icons.lock_outline_rounded;
    }
  }

  // الحصول على العنوان الافتراضي
  String get _defaultTitle {
    switch (widget.type) {
      case AlertType.info:
        return 'معلومات';
      case AlertType.warning:
        return 'تحذير';
      case AlertType.error:
        return 'خطأ';
      case AlertType.success:
        return 'نجاح';
      case AlertType.noInternet:
        return 'لا يوجد اتصال';
      case AlertType.noPermission:
        return 'غير مسموح';
      case AlertType.unauthorized:
        return 'غير مصرح';
    }
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: AppColors.overlay,
        child: GestureDetector(
          onTap: _handleClose,
          behavior: HitTestBehavior.opaque,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {}, // منع إغلاق النافذة عند النقر عليها
                  child: Container(
                    width: 320,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // منطقة العنوان وأزرار التحكم
                        Stack(
                          children: [
                            // خلفية ومحتوى العنوان
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _typeColor.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // الأيقونة
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: _typeColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _typeColor.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _typeIcon,
                                      color: AppColors.textOnPrimary,
                                      size: 36,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // العنوان
                                  Text(
                                    widget.title ?? _defaultTitle,
                                    style: AppTextStyles.headlineMedium
                                        .copyWith(
                                          color: _typeColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            // زر الإغلاق "X"
                            Positioned(
                              top: 8,
                              left: 8,
                              child: IconButton(
                                onPressed: _handleClose,
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: _typeColor.withOpacity(0.8),
                                  size: 24,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.5,
                                  ),
                                  hoverColor: _typeColor.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // الرسالة
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          child: Text(
                            widget.message,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // زر الإغلاق
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _handleClose,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _typeColor,
                                foregroundColor: AppColors.textOnPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'حسناً',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
