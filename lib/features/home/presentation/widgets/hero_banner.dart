import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/shared/widgets/app_network_image.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/campaign.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({required this.campaign, super.key});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1200;

        final aspectRatio = isMobile
            ? 1.9
            : isTablet
            ? 2.4
            : 2.8;

        final horizontalPadding = isMobile ? AppSpacing.md : AppSpacing.xl;

        final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: isMobile ? 24 : null,
        );

        final subtitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: isMobile ? 14 : null,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: AppNetworkImage(
                    imageUrl: campaign.imageUrl,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                    semanticLabel: campaign.title,
                  ),
                ),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isMobile ? AppSpacing.md : AppSpacing.xl,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaign.title,
                            maxLines: isMobile ? 2 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),

                          SizedBox(
                            height: isMobile ? AppSpacing.xs : AppSpacing.sm,
                          ),

                          Text(
                            campaign.subtitle,
                            maxLines: isMobile ? 2 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: subtitleStyle,
                          ),

                          SizedBox(
                            height: isMobile ? AppSpacing.sm : AppSpacing.lg,
                          ),

                          SizedBox(
                            height: isMobile ? 40 : null,
                            child: FilledButton(
                              onPressed: () {},
                              child: Text(campaign.ctaLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
