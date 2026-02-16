import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../application/image_to_pdf_controller.dart';
import 'image_to_pdf_processing_screen.dart';

class ImageToPdfSettingsScreen extends ConsumerStatefulWidget {
  static const String routePath = '/image-to-pdf/settings';

  const ImageToPdfSettingsScreen({super.key});

  @override
  ConsumerState<ImageToPdfSettingsScreen> createState() =>
      _ImageToPdfSettingsScreenState();
}

class _ImageToPdfSettingsScreenState
    extends ConsumerState<ImageToPdfSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imageToPdfControllerProvider);
    final controller = ref.read(imageToPdfControllerProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(title: 'PDF Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: state.paperSize,
                decoration: const InputDecoration(labelText: 'Paper size'),
                items: const [
                  DropdownMenuItem(value: 'A4', child: Text('A4')),
                  DropdownMenuItem(value: 'A5', child: Text('A5')),
                  DropdownMenuItem(value: 'Letter', child: Text('Letter')),
                ],
                onChanged: (v) {
                  if (v != null) controller.updatePaperSize(v);
                },
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                value: state.orientation,
                decoration: const InputDecoration(labelText: 'Orientation'),
                items: const [
                  DropdownMenuItem(value: 'Portrait', child: Text('Portrait')),
                  DropdownMenuItem(value: 'Landscape', child: Text('Landscape')),
                ],
                onChanged: (v) {
                  if (v != null) controller.updateOrientation(v);
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'Margins',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: state.margin,
                min: 0,
                max: 32,
                onChanged: (v) => controller.updateMargin(v),
              ),
              SizedBox(height: 24.h),
              GradientButton(
                label: 'Generate PDF',
                onPressed: state.hasImages
                    ? () {
                        context.push(ImageToPdfProcessingScreen.routePath);
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

