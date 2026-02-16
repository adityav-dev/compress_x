import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/compress_controller.dart';
import 'compress_settings_screen.dart';

class CompressSelectImageScreen extends ConsumerWidget {
  static const String routePath = '/compress/select';

  const CompressSelectImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(compressControllerProvider);
    final controller = ref.read(compressControllerProvider.notifier);
    final hasImageSelected = state.hasImage;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Compress Image'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.4),
                      ),
                    ),
                    child: hasImageSelected && state.originalFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.file(
                              state.originalFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              'No image selected',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickFromGallery(),
                      icon: const Icon(Icons.photo_library_rounded),
                      label: Text(
                        'Choose from Gallery',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickFromCamera(),
                      icon: const Icon(Icons.photo_camera_rounded),
                      label: Text(
                        'Use Camera',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              GradientButton(
                label: 'Next',
                onPressed: hasImageSelected
                    ? () {
                        context.push(CompressSettingsScreen.routePath);
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

