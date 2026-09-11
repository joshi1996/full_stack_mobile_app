import 'package:equatable/equatable.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

final class CatalogStarted extends CatalogEvent {
  const CatalogStarted();
}

final class CatalogRefreshed extends CatalogEvent {
  const CatalogRefreshed();
}
