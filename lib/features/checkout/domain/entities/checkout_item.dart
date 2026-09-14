import 'package:equatable/equatable.dart';

class CheckoutItem extends Equatable {
  const CheckoutItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  final String productId;
  final String productName;
  final String imageUrl;
  final double unitPrice;
  final int quantity;

  double get totalPrice => unitPrice * quantity;

  @override
  List<Object?> get props => [
    productId,
    productName,
    imageUrl,
    unitPrice,
    quantity,
  ];
}
