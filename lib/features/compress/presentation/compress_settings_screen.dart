import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/compress_controller.dart';
import 'compress_processing_screen.dart';

class CompressSettingsScreen extends ConsumerStatefulWidget {
  static const String routePath = '/compress/settings';

  const CompressSettingsScreen({super.key});

  @override
  ConsumerState<CompressSettingsScreen> createState() =>
      _CompressSettingsScreenState();
}

class _CompressSettingsScreenState
    extends ConsumerState<CompressSettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compressControllerProvider);
    final controller = ref.read(compressControllerProvider.notifier);
    final originalKb =
        state.originalBytes != null ? (state.originalBytes! / 1024).round() : 0;
    final estimatedKb = state.originalBytes != null
        ? (state.originalBytes! * state.quality / 1024).round()
        : 0;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Compression Settings'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                ),
                child: state.originalFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.file(
                          state.originalFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: Text('No image selected')),
              ),
              SizedBox(height: 24.h),
              Text(
                'Compression level',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              Slider(
                value: state.quality,
                onChanged: (v) => controller.updateQuality(v),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'High quality',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 12.sp),
                  ),
                  Text(
                    'Medium',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 12.sp),
                  ),
                  Text(
                    'Smaller file',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _SizeInfoTile(
                      label: 'Original',
                      sizeLabel:
                          state.originalBytes == null ? '-' : '$originalKb KB',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SizeInfoTile(
                      label: 'Estimated',
                      sizeLabel:
                          state.originalBytes == null ? '-' : '$estimatedKb KB',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GradientButton(
                label: 'Continue',
                onPressed: state.hasImage
                    ? () {
                        context.push(CompressProcessingScreen.routePath);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SizeInfoTile extends StatelessWidget {
  final String label;
  final String sizeLabel;

  const _SizeInfoTile({
    required this.label,
    required this.sizeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            sizeLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

