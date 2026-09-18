import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_network_image.dart';

class ProductGallery extends StatefulWidget {
  const ProductGallery({
    required this.images,
    required this.productName,
    super.key,
  });

  final List<String> images;
  final String productName;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const _EmptyGallery();
    }

    final selectedIndex = _selectedIndex.clamp(0, widget.images.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: AppNetworkImage(
            imageUrl: widget.images[selectedIndex],
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            semanticLabel: widget.productName,
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: AppNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      semanticLabel: '${widget.productName} image ${index + 1}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined, size: 56),
      ),
    );
  }
}
