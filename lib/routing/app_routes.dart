import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/splash/presentation/splash_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/compress/presentation/compress_select_image_screen.dart';
import '../features/compress/presentation/compress_settings_screen.dart';
import '../features/compress/presentation/compress_processing_screen.dart';
import '../features/compress/presentation/compress_result_screen.dart';
import '../features/pdf/presentation/image_to_pdf_select_screen.dart';
import '../features/pdf/presentation/image_to_pdf_settings_screen.dart';
import '../features/pdf/presentation/image_to_pdf_processing_screen.dart';
import '../features/pdf/presentation/image_to_pdf_result_screen.dart';
import '../features/pdf/presentation/pdf_tools_screen.dart';
import '../features/resize/presentation/resize_select_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/network/presentation/no_internet_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: OnboardingScreen.routePath,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.routePath,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: HomeScreen.routePath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: CompressSelectImageScreen.routePath,
        builder: (context, state) => const CompressSelectImageScreen(),
      ),
      GoRoute(
        path: CompressSettingsScreen.routePath,
        builder: (context, state) => const CompressSettingsScreen(),
      ),
      GoRoute(
        path: CompressProcessingScreen.routePath,
        builder: (context, state) => const CompressProcessingScreen(),
      ),
      GoRoute(
        path: CompressResultScreen.routePath,
        builder: (context, state) => const CompressResultScreen(),
      ),
      GoRoute(
        path: ImageToPdfSelectScreen.routePath,
        builder: (context, state) => const ImageToPdfSelectScreen(),
      ),
      GoRoute(
        path: ImageToPdfSettingsScreen.routePath,
        builder: (context, state) => const ImageToPdfSettingsScreen(),
      ),
      GoRoute(
        path: ImageToPdfProcessingScreen.routePath,
        builder: (context, state) => const ImageToPdfProcessingScreen(),
      ),
      GoRoute(
        path: ImageToPdfResultScreen.routePath,
        builder: (context, state) => const ImageToPdfResultScreen(),
      ),
      GoRoute(
        path: PdfToolsScreen.routePath,
        builder: (context, state) => const PdfToolsScreen(),
      ),
      GoRoute(
        path: ResizeSelectScreen.routePath,
        builder: (context, state) => const ResizeSelectScreen(),
      ),
      GoRoute(
        path: HistoryScreen.routePath,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: ProfileScreen.routePath,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: NoInternetScreen.routePath,
        builder: (context, state) => const NoInternetScreen(),
      ),
    ],
  );
});

