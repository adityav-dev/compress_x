import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../application/image_to_pdf_controller.dart';
import 'image_to_pdf_result_screen.dart';

class ImageToPdfProcessingScreen extends ConsumerStatefulWidget {
  static const String routePath = '/image-to-pdf/processing';

  const ImageToPdfProcessingScreen({super.key});

  @override
  ConsumerState<ImageToPdfProcessingScreen> createState() =>
      _ImageToPdfProcessingScreenState();
}

class _ImageToPdfProcessingScreenState
    extends ConsumerState<ImageToPdfProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_generate);
  }

  Future<void> _generate() async {
    final controller = ref.read(imageToPdfControllerProvider.notifier);
    await controller.generatePdf();
    if (!mounted) return;
    context.go(ImageToPdfResultScreen.routePath);
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
                    'Generating your PDF...',
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

