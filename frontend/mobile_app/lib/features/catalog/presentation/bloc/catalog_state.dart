import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

enum CatalogStatus { initial, loading, success, failure }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.products = const [],
    this.categoryId,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final CatalogStatus status;
  final List<Product> products;
  final String? categoryId;
  final String? errorMessage;
  final bool isRefreshing;

  CatalogState copyWith({
    CatalogStatus? status,
    List<Product>? products,
    String? categoryId,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return CatalogState(
      status: status ?? this.status,
      products: products ?? this.products,
      categoryId: categoryId ?? this.categoryId,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    categoryId,
    errorMessage,
    isRefreshing,
  ];
}
