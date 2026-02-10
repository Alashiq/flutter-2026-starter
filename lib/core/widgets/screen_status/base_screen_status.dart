import 'package:flutter/material.dart';
import 'package:starter/core/utils/app_actions.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/theme/app_text_styles.dart';

class BaseScreenStatus extends StatelessWidget {
  final String title;
  final String message;
  final String? imagePath;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String retryText;
  final Color primaryColor;
  final bool logoutButton;

  const BaseScreenStatus({
    super.key,
    required this.title,
    required this.message,
    this.imagePath,
    this.icon,
    this.onRetry,
    this.retryText = 'إعادة المحاولة',
    this.primaryColor = AppColors.primary,
    this.logoutButton = false,
  }) : assert(
         imagePath != null || icon != null,
         'Must provide imagePath or icon',
       );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 40),
                )
              else if (imagePath != null)
                Image.asset(imagePath!, height: 160, width: 160),
              const SizedBox(height: 32),
              Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      retryText,
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
              if (logoutButton) ...[
                const SizedBox(height: 25),
                Column(
                  children: [
                    Text(
                      "أو",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 44,
                      width: 168,
                      child: TextButton.icon(
                        onPressed: () => AppActions.logout(),
                        icon: const Icon(
                          Icons.logout,
                          color: AppColors.inactive,
                        ),
                        label: Text(
                          "تسجيل الخروج",
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.inactive,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.inactive,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: AppColors.inactive,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
