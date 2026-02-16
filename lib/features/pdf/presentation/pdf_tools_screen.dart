import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_app_bar.dart';

class PdfToolsScreen extends StatelessWidget {
  static const String routePath = '/pdf/tools';

  const PdfToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _PdfToolItem(
        icon: Icons.merge_type_rounded,
        title: 'Merge PDF',
        subtitle: 'Combine multiple files',
      ),
      _PdfToolItem(
        icon: Icons.call_split_rounded,
        title: 'Split PDF',
        subtitle: 'Extract pages',
      ),
      _PdfToolItem(
        icon: Icons.image_rounded,
        title: 'PDF to Image',
        subtitle: 'Export pages as images',
      ),
      _PdfToolItem(
        icon: Icons.lock_rounded,
        title: 'Lock PDF',
        subtitle: 'Add password',
      ),
      _PdfToolItem(
        icon: Icons.lock_open_rounded,
        title: 'Unlock PDF',
        subtitle: 'Remove password',
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'PDF Tools', showBack: false),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(20.w),
          itemCount: tools.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final item = tools[index];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              tileColor: Theme.of(context).cardColor,
              leading: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Icon(
                  item.icon,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(item.title),
              subtitle: Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
              ),
              onTap: () {
                // TODO: open respective step-based tool screen
              },
            );
          },
        ),
      ),
    );
  }
}

class _PdfToolItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _PdfToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

