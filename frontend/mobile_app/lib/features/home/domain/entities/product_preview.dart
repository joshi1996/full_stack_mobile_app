import 'package:equatable/equatable.dart';

class ProductPreview extends Equatable {
  const ProductPreview({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final double? rating;
  final int? reviewCount;

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    price,
    originalPrice,
    discountPercentage,
    rating,
    reviewCount,
  ];
}
