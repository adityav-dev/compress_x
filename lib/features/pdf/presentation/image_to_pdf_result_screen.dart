import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/image_to_pdf_controller.dart';

class ImageToPdfResultScreen extends ConsumerWidget {
  static const String routePath = '/image-to-pdf/result';

  const ImageToPdfResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageToPdfControllerProvider);
    final controller = ref.read(imageToPdfControllerProvider.notifier);

    final fileName =
        state.pdfFile != null ? File(state.pdfFile!.path).uri.pathSegments.last : 'document.pdf';
    final sizeLabel =
        state.pdfFile != null ? _formatBytes(state.pdfFile!.lengthSync()) : '-';

    return Scaffold(
      appBar: const CustomAppBar(title: 'PDF Created', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                ),
                child: const Center(child: Placeholder()),
              ),
              SizedBox(height: 16.h),
              Text(
                fileName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 4.h),
              Text(
                sizeLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          state.pdfFile == null ? null : () => controller.sharePdf(),
                      icon: const Icon(Icons.share_rounded),
                      label: Text(
                        'Share',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.pdfFile == null
                          ? null
                          : () async {
                              final ok = await controller.saveToDownloads();
                              if (!context.mounted) return;
                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('PDF saved to CompressX folder'),
                                  ),
                                );
                              } else if (state.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.errorMessage!),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(Icons.download_rounded),
                      label: Text(
                        'Save',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GradientButton(
                label: 'Create Another',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes, [int decimals = 1]) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

