import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/widgets/catalog_content_view.dart';
import 'package:go_router/go_router.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryId = GoRouterState.of(
      context,
    ).uri.queryParameters['category'];

    return BlocProvider(
      create: (_) =>
          getIt<CatalogBloc>()..add(CatalogStarted(categoryId: categoryId)),
      child: const CatalogContentView(),
    );
  }
}
