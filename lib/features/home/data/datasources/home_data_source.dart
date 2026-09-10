import '../../domain/entities/campaign.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/home_configuration.dart';
import '../../domain/entities/home_section.dart';
import '../../domain/entities/product_preview.dart';

abstract interface class HomeDataSource {
  Future<HomeConfiguration> getHomeConfiguration();
}

class HomeDataSourceImpl implements HomeDataSource {
  const HomeDataSourceImpl();

  @override
  Future<HomeConfiguration> getHomeConfiguration() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final products = [
      const ProductPreview(
        id: 'p1',
        name: 'Apple iPhone 16',
        imageUrl: 'https://picsum.photos/seed/iphone/600/600',
        price: 69999,
        originalPrice: 79999,
        discountPercentage: 12,
        rating: 4.6,
        reviewCount: 1820,
      ),
      const ProductPreview(
        id: 'p2',
        name: 'Samsung Galaxy S25',
        imageUrl: 'https://picsum.photos/seed/samsung/600/600',
        price: 74999,
        originalPrice: 84999,
        discountPercentage: 11,
        rating: 4.5,
        reviewCount: 940,
      ),
      const ProductPreview(
        id: 'p3',
        name: 'Sony Wireless Headphones',
        imageUrl: 'https://picsum.photos/seed/headphones/600/600',
        price: 8999,
        originalPrice: 12999,
        discountPercentage: 31,
        rating: 4.4,
        reviewCount: 2300,
      ),
      const ProductPreview(
        id: 'p4',
        name: 'Nike Running Shoes',
        imageUrl: 'https://picsum.photos/seed/shoes/600/600',
        price: 5499,
        originalPrice: 7999,
        discountPercentage: 31,
        rating: 4.3,
        reviewCount: 1250,
      ),
    ];

    final categories = [
      const Category(
        id: 'electronics',
        name: 'Electronics',
        imageUrl: 'https://picsum.photos/seed/electronics/300/300',
      ),
      const Category(
        id: 'fashion',
        name: 'Fashion',
        imageUrl: 'https://picsum.photos/seed/fashion/300/300',
      ),
      const Category(
        id: 'home',
        name: 'Home',
        imageUrl: 'https://picsum.photos/seed/home/300/300',
      ),
      const Category(
        id: 'beauty',
        name: 'Beauty',
        imageUrl: 'https://picsum.photos/seed/beauty/300/300',
      ),
      const Category(
        id: 'sports',
        name: 'Sports',
        imageUrl: 'https://picsum.photos/seed/sports/300/300',
      ),
      const Category(
        id: 'grocery',
        name: 'Grocery',
        imageUrl: 'https://picsum.photos/seed/grocery/300/300',
      ),
    ];

    const campaign = Campaign(
      id: 'campaign-1',
      title: 'Mega Shopping Festival',
      subtitle: 'Up to 70% OFF across thousands of products',
      imageUrl: 'https://picsum.photos/seed/festival/1400/500',
      ctaLabel: 'Shop Now',
    );

    return HomeConfiguration(
      sections: [
        HomeSection(
          id: 'hero-1',
          type: HomeSectionType.hero,
          title: 'Mega Shopping Festival',
          campaign: campaign,
        ),
        HomeSection(
          id: 'categories-1',
          type: HomeSectionType.categories,
          title: 'Shop by Category',
          subtitle: 'Explore popular categories',
          categories: categories,
        ),
        HomeSection(
          id: 'deals-1',
          type: HomeSectionType.flashDeals,
          title: 'Deals of the Day',
          subtitle: 'Grab them before they are gone',
          products: products,
        ),
        HomeSection(
          id: 'recommended-1',
          type: HomeSectionType.recommendations,
          title: 'Recommended for You',
          subtitle: 'Based on your shopping interests',
          products: products.reversed.toList(),
        ),
      ],
    );
  }
}
