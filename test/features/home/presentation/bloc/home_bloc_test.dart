import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/error/failure_mapper.dart';
import 'package:full_stack_mobile_app/features/home/domain/entities/home_configuration.dart';
import 'package:full_stack_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:full_stack_mobile_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:full_stack_mobile_app/features/home/presentation/bloc/home_event.dart';
import 'package:full_stack_mobile_app/features/home/presentation/bloc/home_state.dart';

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository(this.result);

  final Either<Failure, HomeConfiguration> result;

  @override
  Future<Either<Failure, HomeConfiguration>> getHomeConfiguration() async {
    return result;
  }
}

void main() {
  const configuration = HomeConfiguration(sections: []);

  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'emits loading then success when home loads successfully',
      build: () => HomeBloc(FakeHomeRepository(const Right(configuration))),
      act: (bloc) => bloc.add(const HomeStarted()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.success,
          configuration: configuration,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits loading then failure when home loading fails',
      build: () => HomeBloc(
        FakeHomeRepository(
          Left(FailureMapper.fromException(Exception('Network error'))),
        ),
      ),
      act: (bloc) => bloc.add(const HomeStarted()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.failure)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Exception: Network error',
            ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits refreshing then success when refresh succeeds',
      build: () => HomeBloc(FakeHomeRepository(const Right(configuration))),
      seed: () => const HomeState(
        status: HomeStatus.success,
        configuration: configuration,
      ),
      act: (bloc) => bloc.add(const HomeRefreshed()),
      expect: () => [
        const HomeState(
          status: HomeStatus.success,
          configuration: configuration,
          isRefreshing: true,
        ),
        const HomeState(
          status: HomeStatus.success,
          configuration: configuration,
          isRefreshing: false,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'preserves existing content when refresh fails',
      build: () => HomeBloc(
        FakeHomeRepository(
          Left(FailureMapper.fromException(Exception('Refresh failed'))),
        ),
      ),
      seed: () => const HomeState(
        status: HomeStatus.success,
        configuration: configuration,
      ),
      act: (bloc) => bloc.add(const HomeRefreshed()),
      expect: () => [
        const HomeState(
          status: HomeStatus.success,
          configuration: configuration,
          isRefreshing: true,
        ),
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.success)
            .having(
              (state) => state.configuration,
              'configuration',
              configuration,
            )
            .having((state) => state.isRefreshing, 'isRefreshing', false)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Exception: Refresh failed',
            ),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'loads home normally when refresh is triggered without configuration',
      build: () => HomeBloc(FakeHomeRepository(const Right(configuration))),
      act: (bloc) => bloc.add(const HomeRefreshed()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.success,
          configuration: configuration,
        ),
      ],
    );
  });
}
