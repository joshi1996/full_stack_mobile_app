import 'package:equatable/equatable.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class ProductDetailsStarted extends ProductDetailsEvent {
  const ProductDetailsStarted(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}
