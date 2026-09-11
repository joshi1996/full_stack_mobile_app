import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.repository) : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeRefreshed>(_onHomeRefreshed);
  }

  final HomeRepository repository;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    await _loadHome(emit, showLoading: true);
  }

  Future<void> _onHomeRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    // If there is no existing content, perform a normal initial load.
    if (state.configuration == null) {
      await _loadHome(emit, showLoading: true);
      return;
    }

    emit(state.copyWith(isRefreshing: true, errorMessage: null));

    final result = await repository.getHomeConfiguration();

    result.fold(
      (failure) {
        emit(
          state.copyWith(isRefreshing: false, errorMessage: failure.message),
        );
      },
      (configuration) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            configuration: configuration,
            isRefreshing: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _loadHome(
    Emitter<HomeState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) {
      emit(
        state.copyWith(
          status: HomeStatus.loading,
          isRefreshing: false,
          errorMessage: null,
        ),
      );
    }

    final result = await repository.getHomeConfiguration();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            isRefreshing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (configuration) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            configuration: configuration,
            isRefreshing: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
