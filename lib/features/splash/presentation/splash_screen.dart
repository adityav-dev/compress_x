import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routePath = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    // TODO: Replace with real auth state check
    const bool isLoggedIn = false;

    if (!mounted) return;
    context.go(isLoggedIn ? HomeScreen.routePath : LoginScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMid,
              AppColors.gradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.compress_rounded,
                  size: 72.sp,
                  color: Colors.white,
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .scale(),
                SizedBox(height: 16.h),
                Text(
                  'CompressX',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                      ),
                ).animate().fadeIn(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 300),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

