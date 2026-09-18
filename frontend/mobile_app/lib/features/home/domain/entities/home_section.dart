import 'package:equatable/equatable.dart';
import 'package:full_stack_mobile_app/features/home/domain/entities/campaign.dart';
import 'package:full_stack_mobile_app/features/home/domain/entities/category.dart';
import 'package:full_stack_mobile_app/features/home/domain/entities/product_preview.dart';

enum HomeSectionType { hero, categories, flashDeals, products, recommendations }

class HomeSection extends Equatable {
  const HomeSection({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.products = const [],
    this.categories = const [],
    this.campaign,
  });

  final String id;
  final HomeSectionType type;
  final String title;
  final String? subtitle;

  final List<ProductPreview> products;
  final List<Category> categories;
  final Campaign? campaign;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    subtitle,
    products,
    categories,
    campaign,
  ];
}
