import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.categoryId,
    required this.images,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating = 0,
    this.reviewCount = 0,
  });

  final String id;
  final String name;
  final String description;
  final String brand;
  final String categoryId;

  final List<String> images;

  final double price;
  final double? originalPrice;
  final int? discountPercentage;

  final double rating;
  final int reviewCount;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    brand,
    categoryId,
    images,
    price,
    originalPrice,
    discountPercentage,
    rating,
    reviewCount,
  ];
}
