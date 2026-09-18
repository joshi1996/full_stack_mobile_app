import 'package:equatable/equatable.dart';

class Campaign extends Equatable {
  const Campaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.ctaLabel = 'Shop Now',
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String ctaLabel;

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, ctaLabel];
}
