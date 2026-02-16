import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../home/presentation/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routePath = '/login';

  const LoginScreen({super.key});

  void _onGoogleLogin(BuildContext context) async {
    // TODO: Implement Google Sign-In
    context.go(HomeScreen.routePath);
  }

  void _onGuestLogin(BuildContext context) {
    context.go(HomeScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lightBackground,
              AppColors.accentCyan.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Icon(
                  Icons.compress_rounded,
                  size: 64.sp,
                  color: AppColors.gradientMid,
                ),
                SizedBox(height: 12.h),
                Text(
                  'CompressX',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 40.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20.r,
                        offset: Offset(0, 12.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GradientButton(
                        label: 'Continue with Google',
                        onPressed: () => _onGoogleLogin(context),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () => _onGuestLogin(context),
                        child: Text(
                          'Continue as Guest',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'By continuing you agree to our Terms & Privacy Policy.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: Theme.of(context).hintColor.withOpacity(0.8),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

