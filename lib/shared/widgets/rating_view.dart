import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class RatingView extends StatelessWidget {
  const RatingView({required this.rating, this.reviewCount, super.key});

  final double rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Text('($reviewCount)', style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}
