import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/home_content_view.dart';

class TabletHomeView extends StatelessWidget {
  const TabletHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TabletHomeContent();
  }
}

class _TabletHomeContent extends StatelessWidget {
  const _TabletHomeContent();

  @override
  Widget build(BuildContext context) {
    return const HomeContentView(
      padding: EdgeInsets.all(AppSpacing.lg),
      sectionGap: AppSpacing.xl,
    );
  }
}
