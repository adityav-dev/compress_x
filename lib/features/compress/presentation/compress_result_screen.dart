import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/compress_controller.dart';

class CompressResultScreen extends ConsumerWidget {
  static const String routePath = '/compress/result';

  const CompressResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(compressControllerProvider);
    final controller = ref.read(compressControllerProvider.notifier);

    final beforeKb =
        state.originalBytes != null ? (state.originalBytes! / 1024).round() : 0;
    final afterKb = state.compressedBytes != null
        ? (state.compressedBytes! / 1024).round()
        : 0;
    final reduction =
        state.reductionPercent != null ? state.reductionPercent!.round() : 0;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Result', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ResultImageTile(
                      label: 'Before',
                      sizeLabel:
                          state.originalBytes == null ? '-' : '$beforeKb KB',
                      imageFile: state.originalFile,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ResultImageTile(
                      label: 'After',
                      sizeLabel:
                          state.compressedBytes == null ? '-' : '$afterKb KB',
                      imageFile: state.compressedFile,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (state.reductionPercent != null)
                Text(
                  'Reduced by $reduction%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.compressedFile == null
                          ? null
                          : () => controller.shareCompressed(),
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
                      onPressed: state.compressedFile == null
                          ? null
                          : () async {
                              final ok = await controller.saveToDownloads();
                              if (!context.mounted) return;
                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved to CompressX folder'),
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
                        'Download',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GradientButton(
                label: 'Compress Another',
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
}

class _ResultImageTile extends StatelessWidget {
  final String label;
  final String sizeLabel;
  final File? imageFile;

  const _ResultImageTile({
    required this.label,
    required this.sizeLabel,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 140.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )
                : const Center(child: Text('No preview')),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          sizeLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

