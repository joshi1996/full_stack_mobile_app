import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:full_stack_mobile_app/features/home/domain/entities/category.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/home_section.dart';
import 'category_carousel.dart';
import 'flash_deal_section.dart';
import 'hero_banner.dart';
import 'section_header.dart';

class HomeSectionRenderer extends StatelessWidget {
  const HomeSectionRenderer({required this.section, super.key});

  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    return switch (section.type) {
      HomeSectionType.hero => _buildHero(),
      HomeSectionType.categories => _buildCategories(context),
      HomeSectionType.flashDeals => _buildProducts(),
      HomeSectionType.products => _buildProducts(),
      HomeSectionType.recommendations => _buildProducts(),
    };
  }

  Widget _buildHero() {
    final campaign = section.campaign;

    if (campaign == null) {
      return const SizedBox.shrink();
    }

    return HeroBanner(campaign: campaign);
  }

  Widget _buildCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: section.title, subtitle: section.subtitle),
        const SizedBox(height: 16),
        CategoryCarousel(
          categories: section.categories,
          onCategoryTap: (Category category) {
            context.goNamed(
              RouteNames.explore,
              queryParameters: {'category': category.id},
            );
          },
        ),
      ],
    );
  }

  Widget _buildProducts() {
    return FlashDealSection(
      title: section.title,
      subtitle: section.subtitle,
      products: section.products,
    );
  }
}
