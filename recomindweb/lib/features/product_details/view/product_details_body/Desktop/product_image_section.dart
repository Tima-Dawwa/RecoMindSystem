import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class ProductImageSection extends StatefulWidget {
  final String selectedImage;
  final Function(String) onThumbnailClick;
  final List<String> imageList;

  const ProductImageSection({
    super.key,
    required this.selectedImage,
    required this.onThumbnailClick,
    required this.imageList,
  });

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final bool showThumbnails = widget.imageList.length > 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showThumbnails)
          Column(
            mainAxisSize: MainAxisSize.min,
            children:
                widget.imageList.map((image) {
                  final isSelected = image == widget.selectedImage;
                  return GestureDetector(
                    onTap: () => widget.onThumbnailClick(image),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected ? Themes.primary : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          image,
                          width: 90,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        const SizedBox(width: 32),
        // Use Stack to position the favorite button over the image
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.selectedImage,
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Themes.bg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Themes.text.withAlpha(150),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                        isFavorite
                            ? Themes.secondary
                            : Themes.text.withAlpha(150),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
