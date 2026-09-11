import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/home_section_renderer.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'home_empty_view.dart';
import 'home_error_view.dart';
import 'home_skeleton.dart';

class HomeContentView extends StatelessWidget {
  const HomeContentView({
    required this.padding,
    required this.sectionGap,
    super.key,
  });

  final EdgeInsets padding;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const HomeSkeleton();
        }

        if (state.status == HomeStatus.failure) {
          return HomeErrorView(
            onRetry: () {
              context.read<HomeBloc>().add(const HomeStarted());
            },
          );
        }

        final configuration = state.configuration;

        if (configuration == null || configuration.sections.isEmpty) {
          return const HomeEmptyView();
        }

        return RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<HomeBloc>();

            bloc.add(const HomeRefreshed());

            await bloc.stream.firstWhere((state) => state.isRefreshing);

            await bloc.stream.firstWhere((state) => !state.isRefreshing);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            itemCount: configuration.sections.length,
            separatorBuilder: (_, __) {
              return SizedBox(height: sectionGap);
            },
            itemBuilder: (context, index) {
              return HomeSectionRenderer(
                section: configuration.sections[index],
              );
            },
          ),
        );
      },
    );
  }
}
