import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  static const String routePath = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile', showBack: false),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  child: Icon(Icons.person_rounded, size: 24.sp),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aditya',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'aditya@example.com',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SwitchListTile(
              title: const Text('Dark mode'),
              value: themeMode == ThemeMode.dark,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).state =
                    v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            ListTile(
              title: const Text('Language'),
              subtitle: const Text('English'),
              onTap: () {
                // TODO: language selector
              },
            ),
            ListTile(
              title: const Text('Privacy policy'),
              onTap: () {
                // TODO: open webview/url
              },
            ),
            ListTile(
              title: const Text('Rate app'),
              onTap: () {
                // TODO: launch store page
              },
            ),
            ListTile(
              title: const Text('Share app'),
              onTap: () {
                // TODO: share_plus
              },
            ),
          ],
        ),
      ),
    );
  }
}

