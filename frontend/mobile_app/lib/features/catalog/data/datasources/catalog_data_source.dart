import '../../domain/entities/product.dart';

abstract interface class CatalogDataSource {
  Future<List<Product>> getProducts();

  Future<Product> getProductById(String productId);
}

class CatalogDataSourceImpl implements CatalogDataSource {
  @override
  Future<List<Product>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return _products;
  }

  @override
  Future<Product> getProductById(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return _products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Product not found'),
    );
  }
}

final List<Product> _products = [
  const Product(
    id: 'product-1',
    name: 'Apple iPhone 16',
    description:
        'Apple iPhone 16 with an advanced camera system, powerful performance, and a stunning display.',
    brand: 'Apple',
    categoryId: 'electronics',
    images: [
      'https://picsum.photos/seed/iphone/600/600',
      'https://picsum.photos/seed/iphone-detail-1/600/600',
      'https://picsum.photos/seed/iphone-detail-2/600/600',
    ],
    price: 69999,
    originalPrice: 79999,
    discountPercentage: 12,
    rating: 4.6,
    reviewCount: 1820,
  ),
  const Product(
    id: 'product-2',
    name: 'Samsung Galaxy S25',
    description:
        'Samsung Galaxy S25 with a high-resolution display, powerful processor, and advanced camera features.',
    brand: 'Samsung',
    categoryId: 'electronics',
    images: [
      'https://picsum.photos/seed/samsung/600/600',
      'https://picsum.photos/seed/samsung-detail-1/600/600',
      'https://picsum.photos/seed/samsung-detail-2/600/600',
    ],
    price: 74999,
    originalPrice: 84999,
    discountPercentage: 11,
    rating: 4.5,
    reviewCount: 940,
  ),
  const Product(
    id: 'product-3',
    name: 'Sony Wireless Headphones',
    description:
        'Sony wireless headphones with immersive sound, comfortable design, and long-lasting battery life.',
    brand: 'Sony',
    categoryId: 'electronics',
    images: [
      'https://picsum.photos/seed/headphones/600/600',
      'https://picsum.photos/seed/headphones-detail-1/600/600',
      'https://picsum.photos/seed/headphones-detail-2/600/600',
    ],
    price: 8999,
    originalPrice: 12999,
    discountPercentage: 31,
    rating: 4.4,
    reviewCount: 2300,
  ),
  const Product(
    id: 'product-4',
    name: 'Nike Running Shoes',
    description:
        'Nike running shoes designed for everyday performance with lightweight cushioning and a comfortable fit.',
    brand: 'Nike',
    categoryId: 'sports',
    images: [
      'https://picsum.photos/seed/shoes/600/600',
      'https://picsum.photos/seed/shoes-detail-1/600/600',
      'https://picsum.photos/seed/shoes-detail-2/600/600',
    ],
    price: 5499,
    originalPrice: 7999,
    discountPercentage: 31,
    rating: 4.3,
    reviewCount: 1250,
  ),
  const Product(
    id: 'product-5',
    name: 'Minimalist Backpack',
    description:
        'Durable everyday backpack with multiple storage compartments for work, travel, and daily use.',
    brand: 'TravelX',
    categoryId: 'bags',
    images: [
      'https://picsum.photos/seed/backpack/600/600',
      'https://picsum.photos/seed/backpack-detail-1/600/600',
    ],
    price: 1599,
    originalPrice: 2299,
    discountPercentage: 30,
    rating: 4.6,
    reviewCount: 318,
  ),
];
