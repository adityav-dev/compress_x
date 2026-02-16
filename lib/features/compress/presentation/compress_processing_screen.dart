import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../application/compress_controller.dart';
import 'compress_result_screen.dart';

class CompressProcessingScreen extends ConsumerStatefulWidget {
  static const String routePath = '/compress/processing';

  const CompressProcessingScreen({super.key});

  @override
  ConsumerState<CompressProcessingScreen> createState() =>
      _CompressProcessingScreenState();
}

class _CompressProcessingScreenState
    extends ConsumerState<CompressProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // Delay to avoid modifying provider during build
    Future.microtask(_startCompression);
  }

  Future<void> _startCompression() async {
    final controller = ref.read(compressControllerProvider.notifier);
    await controller.compress();
    if (!mounted) return;
    context.go(CompressResultScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 72.w,
                    height: 72.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.r,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.gradientMid,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Compressing your image...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

