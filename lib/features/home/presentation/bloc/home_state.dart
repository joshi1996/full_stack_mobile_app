import 'package:equatable/equatable.dart';

import '../../domain/entities/home_configuration.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.configuration,
    this.errorMessage,
  });

  final HomeStatus status;
  final HomeConfiguration? configuration;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    HomeConfiguration? configuration,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      configuration: configuration ?? this.configuration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, configuration, errorMessage];
}
