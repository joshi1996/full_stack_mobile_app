import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/product_preview.dart';
import 'product_horizontal_list.dart';
import 'section_header.dart';

class FlashDealSection extends StatelessWidget {
  const FlashDealSection({
    required this.title,
    this.subtitle,
    required this.products,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<ProductPreview> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, subtitle: subtitle, onViewAll: () {}),
        const SizedBox(height: AppSpacing.md),
        ProductHorizontalList(products: products),
      ],
    );
  }
}
