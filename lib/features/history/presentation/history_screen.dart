import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';

class HistoryScreen extends StatelessWidget {
  static const String routePath = '/history';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: wire to history controller
    final items = <String>[];

    return Scaffold(
      appBar: const CustomAppBar(title: 'History', showBack: false),
      body: SafeArea(
        child: items.isEmpty
            ? const EmptyStateWidget(
                title: 'No files yet',
                message: 'No files yet — start compressing.',
              )
            : ListView.separated(
                padding: EdgeInsets.all(20.w),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(index),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.w),
                      color: Colors.redAccent,
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    onDismissed: (_) {
                      // TODO: delete from history
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      tileColor: Theme.of(context).cardColor,
                      leading: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Icon(
                          Icons.insert_drive_file_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        'compressed_image.jpg',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        'Today • 512 KB',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        // TODO: open file or details
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemCount: items.length,
              ),
      ),
    );
  }
}

