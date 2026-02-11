import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ozon_app/themes/app_colors.dart';

import '../../features/auth/auth_controller.dart';
import 'widgets/onboard_slide.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardKey = GlobalKey<IntroductionScreenState>();

    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (controller) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: IntroductionScreen(
              // globalBackgroundColor: Color(0xffeff1f7),
              globalBackgroundColor: Color(0xffeff1f7),
              key: onboardKey,
              onChange: (value) {
                controller.onboarding = value;
                controller.update();
                print(value);
              },
              bodyPadding: EdgeInsets.fromLTRB(0, 140, 0, 0),
              globalHeader: Container(
                height: 50,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.fromLTRB(10, 60, 10, 10),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(width: 80),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(100),
                            child: Image.asset(
                              "assets/img/Ozon.jpg",
                              height: 42,
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
                                child: Text(
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
              ),
              globalFooter: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 46),
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.onboarding != 2)
                      onboardKey.currentState?.animateScroll(
                        controller.onboarding + 1,
                      );
                    else
                      controller.endBoarding();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // <-- Radius
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
                onBoardSlide(
                  "ادارة حسابك",
                  "تحكم في حساب الانترنت الخاص بك عبر تطبيق اوزون",
                  'assets/img/onboarding-1.svg',
                  true,
                ),
                onBoardSlide(
                  "الخدمات المضافة",
                  "إستفد من الخدمات المضافة التي تقدمها اوزون لمشتركيها من الدعم الفني ودليل ابراج الشركة والإشعارات",
                  'assets/img/onboarding-2.svg',
                  true,
                ),
                onBoardSlide(
                  "متجر اوزون",
                  "إشتري كروت اوزون مباشره من تطبيق اوزون عبر بطاقتك المصرفية",
                  'assets/img/onboarding-3.svg',
                  true,
                ),
              ],
              showNextButton: false,
              showDoneButton: false,
              dotsDecorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(20.0, 9.0),
                activeColor: AppColors().mainColor,
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
}
