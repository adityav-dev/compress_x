import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/image_to_pdf_controller.dart';
import 'image_to_pdf_settings_screen.dart';

class ImageToPdfSelectScreen extends ConsumerWidget {
  static const String routePath = '/image-to-pdf/select';

  const ImageToPdfSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageToPdfControllerProvider);
    final controller = ref.read(imageToPdfControllerProvider.notifier);
    final hasImages = state.hasImages;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Images to PDF'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Expanded(
                child: hasImages
                    ? GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: state.images.length,
                        itemBuilder: (context, index) {
                          final file = state.images[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  File(file.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4.h,
                                right: 4.w,
                                child: InkWell(
                                  onTap: () => controller.removeAt(index),
                                  child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                          BorderRadius.circular(10.r),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No images selected',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickImages(),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(
                        'Add Images',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              GradientButton(
                label: 'Next',
                onPressed: hasImages
                    ? () {
                        context.push(ImageToPdfSettingsScreen.routePath);
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

