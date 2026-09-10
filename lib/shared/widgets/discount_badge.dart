import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class DiscountBadge extends StatelessWidget {
  const DiscountBadge({required this.percentage, super.key});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$percentage% OFF',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onError,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
