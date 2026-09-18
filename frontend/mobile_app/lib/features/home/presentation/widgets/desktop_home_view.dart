import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/home_content_view.dart';

class DesktopHomeView extends StatelessWidget {
  const DesktopHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DesktopHomeContent();
  }
}

class _DesktopHomeContent extends StatelessWidget {
  const _DesktopHomeContent();

  @override
  Widget build(BuildContext context) {
    return const HomeContentView(
      padding: EdgeInsets.all(AppSpacing.xl),
      sectionGap: AppSpacing.xxl,
    );
  }
}
