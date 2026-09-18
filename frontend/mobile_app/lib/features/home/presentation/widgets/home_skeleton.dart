import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1200;

        final horizontalPadding = isMobile
            ? AppSpacing.md
            : isTablet
            ? AppSpacing.lg
            : AppSpacing.xl;

        return ListView(
          padding: EdgeInsets.all(horizontalPadding),
          children: [
            _HeroSkeleton(
              aspectRatio: isMobile
                  ? 1.9
                  : isTablet
                  ? 2.4
                  : 2.8,
            ),

            SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),

            const _CategorySkeleton(),

            SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),

            const _ProductSectionSkeleton(),

            SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),

            const _ProductSectionSkeleton(),
          ],
        );
      },
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton({required this.aspectRatio});

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: const AppSkeleton(),
      ),
    );
  }
}

class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeaderSkeleton(),

        const SizedBox(height: AppSpacing.md),

        SizedBox(
          height: 145,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, __) {
              return const SizedBox(
                width: 105,
                child: Column(
                  children: [
                    AppSkeleton(
                      width: 90,
                      height: 90,
                      borderRadius: AppRadius.lg,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AppSkeleton(width: 75, height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductSectionSkeleton extends StatelessWidget {
  const _ProductSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeaderSkeleton(),

        const SizedBox(height: AppSpacing.md),

        SizedBox(
          height: 405,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, __) {
              return const SizedBox(width: 245, child: _ProductCardSkeleton());
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton(width: 150, height: 22),
            SizedBox(height: AppSpacing.xs),
            AppSkeleton(width: 220, height: 16),
          ],
        ),
        AppSkeleton(width: 70, height: 18),
      ],
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSkeleton(
          width: double.infinity,
          height: 240,
          borderRadius: AppRadius.lg,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppSkeleton(width: 180, height: 18),
        const SizedBox(height: AppSpacing.sm),
        const AppSkeleton(width: 120, height: 20),
        const SizedBox(height: AppSpacing.sm),
        const AppSkeleton(width: 90, height: 16),
        const SizedBox(height: AppSpacing.md),
        AppSkeleton(
          width: double.infinity,
          height: 42,
          borderRadius: AppRadius.md,
        ),
      ],
    );
  }
}
