import 'package:flutter/material.dart';
import 'package:starter/core/theme/app_colors.dart';

class LoadingInsideWidget extends StatelessWidget {
  const LoadingInsideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              backgroundColor: AppColors.primary.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'جارِ التحميل...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
