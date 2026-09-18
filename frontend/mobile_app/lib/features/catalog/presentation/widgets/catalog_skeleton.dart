import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_skeleton.dart';

class CatalogSkeleton extends StatelessWidget {
  const CatalogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width < 600
            ? 2
            : width < 900
            ? 3
            : width < 1200
            ? 4
            : 5;

        final horizontalPadding = width < 600
            ? AppSpacing.md
            : width < 1200
            ? AppSpacing.lg
            : AppSpacing.xl;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(horizontalPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.68,
          ),
          itemCount: crossAxisCount * 2,
          itemBuilder: (_, __) {
            return const _CatalogProductSkeleton();
          },
        );
      },
    );
  }
}

class _CatalogProductSkeleton extends StatelessWidget {
  const _CatalogProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: AppSkeleton(borderRadius: AppRadius.lg)),
        const SizedBox(height: AppSpacing.sm),
        const AppSkeleton(width: 140, height: 16),
        const SizedBox(height: AppSpacing.xs),
        const AppSkeleton(width: 90, height: 16),
        const SizedBox(height: AppSpacing.xs),
        const AppSkeleton(width: 120, height: 14),
      ],
    );
  }
}
