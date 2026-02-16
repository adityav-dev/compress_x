import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/feature_card.dart';
import '../../compress/presentation/compress_select_image_screen.dart';
import '../../pdf/presentation/image_to_pdf_select_screen.dart';
import '../../resize/presentation/resize_select_screen.dart';
import '../../pdf/presentation/pdf_tools_screen.dart';
import '../../history/presentation/history_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routePath = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeDashboard(onNavigate: _handleFeatureTap),
      const PdfToolsScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: AppColors.accentCyan.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build_rounded),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _handleFeatureTap(HomeFeature feature) {
    switch (feature) {
      case HomeFeature.compressImage:
        context.push(CompressSelectImageScreen.routePath);
        break;
      case HomeFeature.imageToPdf:
        context.push(ImageToPdfSelectScreen.routePath);
        break;
      case HomeFeature.resizeImage:
        context.push(ResizeSelectScreen.routePath);
        break;
      case HomeFeature.pdfTools:
        setState(() => _index = 1);
        break;
    }
  }
}

enum HomeFeature { compressImage, imageToPdf, resizeImage, pdfTools }

class _HomeDashboard extends StatelessWidget {
  final void Function(HomeFeature) onNavigate;

  const _HomeDashboard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          expandedHeight: 180.h,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 16.h,
                bottom: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hi, Aditya 👋',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 18.r,
                        backgroundColor:
                            AppColors.accentCyan.withOpacity(0.15),
                        child: Icon(
                          Icons.person_rounded,
                          size: 18.sp,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientMid,
                          AppColors.gradientEnd,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Compress up to 80%',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'without visible quality loss.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.speed_rounded,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate.fixed([
              FeatureCard(
                icon: Icons.compress_rounded,
                title: 'Compress Image',
                subtitle: 'Shrink photos smartly',
                onTap: () => onNavigate(HomeFeature.compressImage),
              ),
              FeatureCard(
                icon: Icons.picture_as_pdf_rounded,
                title: 'Image → PDF',
                subtitle: 'Create docs quickly',
                onTap: () => onNavigate(HomeFeature.imageToPdf),
              ),
              FeatureCard(
                icon: Icons.photo_size_select_large_rounded,
                title: 'Resize Image',
                subtitle: 'Exact dimensions',
                onTap: () => onNavigate(HomeFeature.resizeImage),
              ),
              FeatureCard(
                icon: Icons.description_rounded,
                title: 'PDF Tools',
                subtitle: 'Merge, split & more',
                onTap: () => onNavigate(HomeFeature.pdfTools),
              ),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.95,
            ),
          ),
        ),
      ],
    );
  }
}

