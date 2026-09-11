import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/shared/widgets/app_network_image.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/category.dart';

class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({required this.categories, super.key});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            width: 105,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: () {},
              child: Column(
                children: [
                  AppNetworkImage(
                    imageUrl: category.imageUrl,
                    width: 90,
                    height: 90,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    semanticLabel: category.name,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
