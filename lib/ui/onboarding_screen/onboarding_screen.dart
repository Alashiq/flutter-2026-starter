import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/features/auth/auth_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardKey = GlobalKey<IntroductionScreenState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        init: Get.find<AuthController>(),
        builder: (controller) => Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Expanded(
                child: IntroductionScreen(
                  globalBackgroundColor: Colors.white,
                  key: onboardKey,
                  // allowImplicitScrolling: true,
                  // autoScrollDuration: 4000,
                  // infiniteAutoScroll: true,
                  onChange: (value) {
                    controller.onboarding = value;
                    controller.update();
                  },
                  bodyPadding: const EdgeInsets.only(top: 100),
                  globalHeader: Align(
                    alignment: Alignment.topRight,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: controller.onboarding != 2
                            ? TextButton(
                                onPressed: () => controller.endBoarding(),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary
                                      .withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "تخطي",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  pages: [
                    _buildPageViewModel(
                      "ادارة حسابك",
                      "تحكم في حساب الانترنت الخاص بك عبر تطبيق اوزون وسهولة الوصول لكل ما يهمك",
                      'assets/svg/onboarding-1.svg',
                    ),
                    _buildPageViewModel(
                      "الخدمات المضافة",
                      "إستفد من ميزات حصرية مثل الدعم الفني المباشر، دليل الأبراج، والإشعارات الفورية",
                      'assets/svg/onboarding-2.svg',
                    ),
                    _buildPageViewModel(
                      "متجر اوزون",
                      "تسوق بسهولة واشتري كروت الشحن مباشرة عبر التطبيق بآمان تام",
                      'assets/svg/onboarding-3.svg',
                    ),
                  ],
                  showNextButton: false,
                  showDoneButton: false,
                  dotsDecorator: DotsDecorator(
                    size: const Size.square(10.0),
                    activeSize: const Size(30.0, 10.0),
                    activeColor: AppColors.primary,
                    color: AppColors.primary.withOpacity(0.3),
                    spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.onboarding != 2) {
                        onboardKey.currentState?.animateScroll(
                          controller.onboarding + 1,
                        );
                      } else {
                        controller.endBoarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      controller.onboarding != 2 ? "التالي" : "إبدأ الآن",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPageViewModel(
    String title,
    String description,
    String imagePath,
  ) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontFamily: 'Cairo',
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bodyWidget: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Cairo',
            height: 1.5,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      image: Center(
        child: SvgPicture.asset(imagePath, fit: BoxFit.contain, width: 280),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.transparent,
        imagePadding: EdgeInsets.zero,
        contentMargin: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
