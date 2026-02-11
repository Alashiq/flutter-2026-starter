import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_colors.dart';
import 'package:starter/core/utils/app_actions.dart';
import 'package:starter/core/widgets/dialog/confirm_message.dart';
import 'package:starter/features/auth/auth_controller.dart';
import 'package:starter/shared/layout/main_layout_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return MainLayoutWidget(
      title: "الملف الشخصي",
      activePageId: 5,
      child: Expanded(
        child: Obx(() {
          final user = authController.user.value;
          if (user == null) {
            return const Center(
              child: Text(
                'لا توجد بيانات مستخدم',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ========== Header with profile image ==========
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Animated curved header
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4158D0),
                            Color(0xFFC850C0),
                            Color(0xFFFFCC70),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                    // Optional decorative pattern (subtle wave)
                    Positioned.fill(
                      child: CustomPaint(painter: _CurvePainter()),
                    ),
                    // Profile image with edit overlay
                    Positioned(
                      bottom: -60,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 58,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user.photo != null
                                  ? NetworkImage(user.photo!)
                                  : null,
                              child: user.photo == null
                                  ? Icon(
                                      Icons.person,
                                      size: 58,
                                      color: Colors.grey[400],
                                    )
                                  : null,
                            ),
                            // Camera icon to change photo (placeholder)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 24),
                  child: Column(
                    children: [
                      // User name with verified badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${user.firstName ?? ''} ${user.lastName ?? ''}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Cairo',
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Phone number
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          user.phone ?? 'رقم غير متوفر',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ========== Statistics cards ==========
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      _buildStatCard(
                        label: 'الطلبات',
                        value: '٢٤',
                        icon: Icons.shopping_bag_rounded,
                        color: Colors.purple,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        label: 'المفضلة',
                        value: '١٢',
                        icon: Icons.favorite_rounded,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        label: 'النقاط',
                        value: '٣٬٤٥٠',
                        icon: Icons.star_rounded,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverPadding(
                padding: EdgeInsets.only(top: 32, bottom: 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: 'إعدادات الحساب'),
                ),
              ),

              // ========== Account settings ==========
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileOption(
                      icon: Icons.location_on_rounded,
                      title: "المدينة الحالية",
                      subtitle: user.city ?? "لم يتم تحديد المدينة",
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "تغيير",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      onTap: () => Get.toNamed('/change_city'),
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      icon: Icons.notifications_none_rounded,
                      title: "الإشعارات",
                      subtitle: "عرض الإعدادات",
                      onTap: () {
                        // Placeholder navigation as requested
                        Get.toNamed('/change_city');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      icon: Icons.lock_outline_rounded,
                      title: "الخصوصية والأمان",
                      subtitle: "تغيير كلمة المرور",
                      onTap: () {
                        // Placeholder
                      },
                    ),
                  ]),
                ),
              ),

              const SliverPadding(
                padding: EdgeInsets.only(top: 24, bottom: 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: 'التفضيلات'),
                ),
              ),

              // ========== Preferences ==========
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileOption(
                      icon: Icons.language_rounded,
                      title: "اللغة",
                      subtitle: "العربية",
                      onTap: () {
                        // Placeholder
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      icon: Icons.dark_mode_rounded,
                      title: "الوضع المظلم",
                      subtitle: "تلقائي",
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {}, // handled by switch
                    ),
                  ]),
                ),
              ),

              const SliverPadding(
                padding: EdgeInsets.only(top: 24, bottom: 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: 'الدعم'),
                ),
              ),

              // ========== Support ==========
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileOption(
                      icon: Icons.help_outline_rounded,
                      title: "مركز المساعدة",
                      subtitle: "الأسئلة الشائعة والتواصل",
                      onTap: () {
                        // Placeholder
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      icon: Icons.info_outline_rounded,
                      title: "حول التطبيق",
                      subtitle: "الإصدار ١٫٠٫٠",
                      onTap: () {
                        // Placeholder
                      },
                    ),
                  ]),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(top: 24)),

              // ========== Logout button ==========
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(child: _buildLogoutButton()),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
            ],
          );
        }),
      ),
    );
  }

  // ----- Statistics card widget -----
  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Profile option tile (reusable) -----
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    bool isDestructive = false,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, double scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onHighlightChanged: (isPressed) {
              // Could be used to drive animation
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container with gradient effect
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          iconColor.withOpacity(0.2),
                          iconColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isDestructive ? Colors.redAccent : iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDestructive
                                ? Colors.red
                                : AppColors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Trailing widget or default arrow
                  if (trailing != null)
                    trailing
                  else
                    Icon(
                      // RTL support: flip arrow direction
                      Get.locale?.languageCode == 'ar'
                          ? Icons.arrow_back_ios_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.textDisabled,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----- Logout button with confirmation dialog -----
  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade700],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showConfirmMessage(
              message: "هل أنت متأكد من تسجيل الخروج ؟",
              onConfirm: AppActions.logout,
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========== Custom painter for subtle decorative curve ==========
class _CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.9,
        size.width * 0.5,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.7,
        size.width,
        size.height * 0.85,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ========== Section header widget ==========
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: 'Cairo',
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
