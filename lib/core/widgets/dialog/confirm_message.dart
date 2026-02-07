import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';

/// عرض رسالة تأكيد مع خيارين (موافق / إلغاء)
///
/// [message] نص الرسالة
/// [onConfirm] دالة التنفيذ عند الموافقة
/// [title] عنوان الرسالة (اختياري)
/// [confirmButtonText] نص زر الموافقة (اختياري، افتراضياً "موافق")
/// [cancelButtonText] نص زر الإلغاء (اختياري، افتراضياً "إلغاء")
/// [isDangerous] هل الإجراء خطير (حذف مثلاً)؟ يغير لون زر الموافقة للأحمر
void showConfirmMessage({
  required String message,
  required VoidCallback onConfirm,
  String? title,
  String confirmButtonText = 'موافق',
  String cancelButtonText = 'إلغاء',
  bool isDangerous = false,
}) {
  BotToast.showCustomText(
    align: Alignment.center,
    toastBuilder: (close) {
      return _ConfirmMessageWidget(
        message: message,
        title: title,
        onConfirm: () {
          close();
          onConfirm();
        },
        onCancel: close,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        isDangerous: isDangerous,
      );
    },
    duration: null,
    onlyOne: true,
  );
}

class _ConfirmMessageWidget extends StatefulWidget {
  final String message;
  final String? title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmButtonText;
  final String cancelButtonText;
  final bool isDangerous;

  const _ConfirmMessageWidget({
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.isDangerous,
    this.title,
  });

  @override
  State<_ConfirmMessageWidget> createState() => _ConfirmMessageWidgetState();
}

class _ConfirmMessageWidgetState extends State<_ConfirmMessageWidget>
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

  void _handleCancel() async {
    await _controller.reverse();
    widget.onCancel();
  }

  void _handleConfirm() async {
    await _controller.reverse();
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: AppColors.overlay,
        child: GestureDetector(
          onTap: _handleCancel,
          behavior: HitTestBehavior.opaque,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {}, // منع الإغلاق عند النقر على النافذة
                  child: Container(
                    width: 320,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32),
                        // الأيقونة العائمة
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: widget.isDangerous
                                ? const Color(0xFFFEE2E2) // أحمر فاتح جداً
                                : const Color(0xFFDBEAFE), // أزرق فاتح جداً
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isDangerous
                                ? Icons.warning_rounded
                                : Icons.help_outline_rounded,
                            color: widget.isDangerous
                                ? AppColors.error
                                : AppColors.primary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // العنوان
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            widget.title ?? 'تأكيد',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // الرسالة
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            widget.message,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // الأزرار
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary.withOpacity(
                              0.5,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          child: Row(
                            children: [
                              // زر الإلغاء
                              Expanded(
                                child: TextButton(
                                  onPressed: _handleCancel,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    widget.cancelButtonText,
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // زر الموافقة
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleConfirm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.isDangerous
                                        ? AppColors.error
                                        : AppColors.primary,
                                    foregroundColor: AppColors.textOnPrimary,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    widget.confirmButtonText,
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }
}
