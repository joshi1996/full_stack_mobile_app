import 'package:equatable/equatable.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class CatalogStarted extends CatalogEvent {
  const CatalogStarted({this.categoryId});

  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class CatalogRefreshed extends CatalogEvent {
  const CatalogRefreshed();
}
