import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _footerController;
  late Animation<double> _footerAnimation;

  @override
  void initState() {
    super.initState();

    // Logo Animation (Bounce & Fade)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // Footer Animation (Fade In after logo)
    _footerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _footerAnimation = CurvedAnimation(
      parent: _footerController,
      curve: Curves.easeIn,
    );

    // Sequence the animations
    _logoController.forward().then((_) {
      _footerController.forward();
    });

    // Navigate with a beautiful transition
    Timer(const Duration(milliseconds: 2400), () {
      Get.offNamed('/start', preventDuplicates: true);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Centered Logo
          Center(
            child: ScaleTransition(
              scale: _logoAnimation,
              child: FadeTransition(
                opacity: _logoController,
                child: Image.asset('assets/img/logo.png', width: 140),
              ),
            ),
          ),

          // Footer Text
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _footerAnimation,
              child: Column(
                children: [
                  const Text(
                    "The App",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
