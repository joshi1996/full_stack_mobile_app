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
    name: 'Premium Wireless Headphones',
    description: 'Premium wireless headphones with active noise cancellation.',
    brand: 'SoundMax',
    categoryId: 'electronics',
    images: [
      'https://picsum.photos/seed/headphones1/600/600',
      'https://picsum.photos/seed/headphones2/600/600',
    ],
    price: 4999,
    originalPrice: 6999,
    discountPercentage: 29,
    rating: 4.5,
    reviewCount: 1284,
  ),
  const Product(
    id: 'product-2',
    name: 'Smart Watch Pro',
    description:
        'Smart watch with health tracking and a high-resolution display.',
    brand: 'TechFit',
    categoryId: 'electronics',
    images: [
      'https://picsum.photos/seed/watch1/600/600',
      'https://picsum.photos/seed/watch2/600/600',
    ],
    price: 3499,
    originalPrice: 4999,
    discountPercentage: 30,
    rating: 4.3,
    reviewCount: 856,
  ),
  const Product(
    id: 'product-3',
    name: 'Running Shoes',
    description: 'Lightweight running shoes designed for everyday performance.',
    brand: 'RunPro',
    categoryId: 'fashion',
    images: [
      'https://picsum.photos/seed/shoes1/600/600',
      'https://picsum.photos/seed/shoes2/600/600',
    ],
    price: 2499,
    originalPrice: 3999,
    discountPercentage: 38,
    rating: 4.4,
    reviewCount: 642,
  ),
  const Product(
    id: 'product-4',
    name: 'Classic Cotton T-Shirt',
    description: 'Comfortable premium cotton t-shirt for everyday wear.',
    brand: 'UrbanWear',
    categoryId: 'fashion',
    images: [
      'https://picsum.photos/seed/tshirt1/600/600',
      'https://picsum.photos/seed/tshirt2/600/600',
    ],
    price: 799,
    originalPrice: 1199,
    discountPercentage: 33,
    rating: 4.2,
    reviewCount: 421,
  ),
  const Product(
    id: 'product-5',
    name: 'Minimalist Backpack',
    description:
        'Durable everyday backpack with multiple storage compartments.',
    brand: 'TravelX',
    categoryId: 'bags',
    images: [
      'https://picsum.photos/seed/backpack1/600/600',
      'https://picsum.photos/seed/backpack2/600/600',
    ],
    price: 1599,
    originalPrice: 2299,
    discountPercentage: 30,
    rating: 4.6,
    reviewCount: 318,
  ),
];
