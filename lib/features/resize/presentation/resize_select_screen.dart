import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/resize_controller.dart';

class ResizeSelectScreen extends ConsumerWidget {
  static const String routePath = '/resize/select';

  const ResizeSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resizeControllerProvider);
    final controller = ref.read(resizeControllerProvider.notifier);

    final widthController = TextEditingController(
      text: state.targetWidth?.toString() ?? '',
    );
    final heightController = TextEditingController(
      text: state.targetHeight?.toString() ?? '',
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Resize Image'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 180.h,
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
                          File(state.originalFile!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: Text('No image selected')),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Width',
                        hintText: 'e.g. 1080',
                      ),
                      onChanged: controller.updateWidth,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        hintText: 'e.g. 1920',
                      ),
                      onChanged: controller.updateHeight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              SwitchListTile(
                value: state.maintainAspect,
                title: const Text('Maintain aspect ratio'),
                onChanged: controller.updateMaintainAspect,
              ),
              SizedBox(height: 24.h),
              GradientButton(
                label: 'Process',
                onPressed:
                    state.hasImage ? () async => await controller.resize() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

