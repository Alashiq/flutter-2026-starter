import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:starter/core/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        backgroundColor: AppColors.primary.withOpacity(0.1),
      ),
    );
  }
}

void showLoading() {
  BotToast.showCustomLoading(
    toastBuilder: (close) {
      return const LoadingWidget();
    },
    backgroundColor: Colors.black12, // خلفية شفافة قليلاً للتركيز
  );
}

void stopLoading() {
  BotToast.closeAllLoading();
}
