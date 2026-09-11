import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/home_content_view.dart';

class MobileHomeView extends StatelessWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const HomeContentView(
      padding: EdgeInsets.all(AppSpacing.md),
      sectionGap: AppSpacing.xl,
    );
  }
}
