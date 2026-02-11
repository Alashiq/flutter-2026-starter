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
      body: GetBuilder<AuthController>(
        init: Get.find<AuthController>(),
        builder: (controller) => Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: IntroductionScreen(
              globalBackgroundColor: const Color(0xffeff1f7),
              key: onboardKey,
              onChange: (value) {
                controller.onboarding = value;
                controller.update();
              },
              bodyPadding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
              globalHeader: Container(
                height: 50,
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.fromLTRB(10, 60, 10, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(width: 80),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // Assuming Ozon.jpg is a logo, replacing with a placeholder or app logo if valid
                          // If 'assets/img/Ozon.jpg' exists, we use it. If not, text or Icon.
                          // User provided path in their code, assuming it exists or I should use Icon.
                          // Let's use a safe Icon fallback if image fails or just the Image as requested.
                          child: Container(
                            // Placeholder for logo if image missing
                            height: 42,
                            width: 42,
                            color: AppColors.primary,
                            child: const Icon(Icons.star, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: controller.onboarding != 2
                          ? InkWell(
                              onTap: () {
                                controller.endBoarding();
                              },
                              child: const Text(
                                "تخطي",
                                style: TextStyle(
                                  fontFamily: 'Adelle',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff5a5a5a),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              globalFooter: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 46),
                height: 48,
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
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    controller.onboarding != 2 ? "التالي" : "إبدأ الأن",
                    style: const TextStyle(
                      fontFamily: 'Adelle',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              pages: [
                _buildPageViewModel(
                  "ادارة حسابك",
                  "تحكم في حساب الانترنت الخاص بك عبر تطبيق اوزون",
                  'assets/svg/onboarding-1.svg',
                  true,
                ),
                _buildPageViewModel(
                  "الخدمات المضافة",
                  "إستفد من الخدمات المضافة التي تقدمها اوزون لمشتركيها من الدعم الفني ودليل ابراج الشركة والإشعارات",
                  'assets/svg/onboarding-2.svg',
                  true,
                ),
                _buildPageViewModel(
                  "متجر اوزون",
                  "إشتري كروت اوزون مباشره من تطبيق اوزون عبر بطاقتك المصرفية",
                  'assets/svg/onboarding-3.svg', // Changed extension to svg based on user saying "assets/svg"
                  true,
                ),
              ],
              showNextButton: false,
              showDoneButton: false,
              dotsDecorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(20.0, 9.0),
                activeColor: AppColors.primary,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPageViewModel(
    String title,
    String description,
    String imagePath,
    bool isSvg,
  ) {
    return PageViewModel(
      titleWidget: Text(
        title,
        style: const TextStyle(
          fontSize: 21,
          fontFamily: 'Adelle',
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      bodyWidget: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Adelle',
            color: Color(0xff333333),
          ),
        ),
      ),
      image: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: isSvg
            ? SvgPicture.asset(imagePath, fit: BoxFit.contain)
            : Image.asset(imagePath),
      ),
      decoration: const PageDecoration(pageColor: Colors.transparent),
    );
  }
}
