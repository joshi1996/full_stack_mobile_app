import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/home/domain/entities/home_section.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'category_carousel.dart';
import 'flash_deal_section.dart';
import 'hero_banner.dart';
import 'section_header.dart';

class TabletHomeView extends StatelessWidget {
  const TabletHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
      child: const _TabletHomeContent(),
    );
  }
}

class _TabletHomeContent extends StatelessWidget {
  const _TabletHomeContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeStatus.failure) {
          return Center(
            child: FilledButton(
              onPressed: () {
                context.read<HomeBloc>().add(const HomeStarted());
              },
              child: const Text('Retry'),
            ),
          );
        }

        final configuration = state.configuration;

        if (configuration == null) {
          return const Center(child: Text('Nothing to show right now'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const HomeRefreshed());
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: configuration.sections.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xl),
            itemBuilder: (context, index) {
              final section = configuration.sections[index];

              return switch (section.type) {
                HomeSectionType.hero => HeroBanner(campaign: section.campaign!),
                HomeSectionType.categories => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: section.title,
                      subtitle: section.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CategoryCarousel(categories: section.categories),
                  ],
                ),
                HomeSectionType.flashDeals => FlashDealSection(
                  title: section.title,
                  subtitle: section.subtitle,
                  products: section.products,
                ),
                HomeSectionType.products => FlashDealSection(
                  title: section.title,
                  subtitle: section.subtitle,
                  products: section.products,
                ),
                HomeSectionType.recommendations => FlashDealSection(
                  title: section.title,
                  subtitle: section.subtitle,
                  products: section.products,
                ),
              };
            },
          ),
        );
      },
    );
  }
}
