import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';

class CustomerAppShell extends StatelessWidget {
  const CustomerAppShell({required this.child, super.key});

  final Widget child;

  static const _navigationItems = [
    _NavigationItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      routeName: RouteNames.home,
    ),
    _NavigationItem(
      label: 'Explore',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      routeName: RouteNames.explore,
    ),
    _NavigationItem(
      label: 'Cart',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      routeName: RouteNames.cart,
    ),
    _NavigationItem(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      routeName: RouteNames.orders,
    ),
    _NavigationItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      routeName: RouteNames.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1200;

        if (isDesktop) {
          return _buildDesktop(context);
        }

        return _buildMobileTablet(context);
      },
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _DesktopNavigation(items: _navigationItems),
          Expanded(
            child: Column(
              children: [
                const _DesktopHeader(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTablet(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _MobileHeader(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: _MobileBottomNavigation(items: _navigationItems),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.routeName,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String routeName;
}

class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({required this.items});

  final List<_NavigationItem> items;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: 240,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Commerce',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ListView(
                children: items.map((item) {
                  final isSelected = currentRoute == _routePath(item.routeName);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      selected: isSelected,
                      leading: Icon(isSelected ? item.activeIcon : item.icon),
                      title: Text(item.label),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () => context.goNamed(item.routeName),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _routePath(String routeName) {
    switch (routeName) {
      case RouteNames.home:
        return '/';
      case RouteNames.explore:
        return '/explore';
      case RouteNames.cart:
        return '/cart';
      case RouteNames.orders:
        return '/orders';
      case RouteNames.profile:
        return '/profile';
      default:
        return '/';
    }
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Deliver to',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Jaipur',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
                IconButton(
                  tooltip: 'Cart',
                  onPressed: () => context.goNamed(RouteNames.cart),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const _SearchBar(),
          ],
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: const _SearchBar(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            IconButton(
              tooltip: 'Notifications',
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
            IconButton(
              tooltip: 'Cart',
              onPressed: () => context.goNamed(RouteNames.cart),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
            IconButton(
              tooltip: 'Profile',
              onPressed: () => context.goNamed(RouteNames.profile),
              icon: const Icon(Icons.person_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.inputHeight,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products, brands and more',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _MobileBottomNavigation extends StatelessWidget {
  const _MobileBottomNavigation({required this.items});

  final List<_NavigationItem> items;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    var selectedIndex = 0;

    for (var index = 0; index < items.length; index++) {
      if (_routePath(items[index].routeName) == currentRoute) {
        selectedIndex = index;
        break;
      }
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        context.goNamed(items[index].routeName);
      },
      destinations: items
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }

  String _routePath(String routeName) {
    switch (routeName) {
      case RouteNames.home:
        return '/';
      case RouteNames.explore:
        return '/explore';
      case RouteNames.cart:
        return '/cart';
      case RouteNames.orders:
        return '/orders';
      case RouteNames.profile:
        return '/profile';
      default:
        return '/';
    }
  }
}
