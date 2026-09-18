import 'package:equatable/equatable.dart';

import '../../domain/entities/home_configuration.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.configuration,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final HomeStatus status;
  final HomeConfiguration? configuration;
  final String? errorMessage;
  final bool isRefreshing;

  HomeState copyWith({
    HomeStatus? status,
    HomeConfiguration? configuration,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return HomeState(
      status: status ?? this.status,
      configuration: configuration ?? this.configuration,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    configuration,
    errorMessage,
    isRefreshing,
  ];
}
