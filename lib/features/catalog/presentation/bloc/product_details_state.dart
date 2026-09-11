import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.errorMessage,
  });

  final ProductDetailsStatus status;
  final Product? product;
  final String? errorMessage;

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Product? product,
    String? errorMessage,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage];
}
