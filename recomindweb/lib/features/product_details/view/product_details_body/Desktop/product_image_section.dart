import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class ProductImageSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool showThumbnails = imageList.length > 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showThumbnails)
          Column(
            mainAxisSize: MainAxisSize.min,
            children:
                imageList.map((image) {
                  final isSelected = image == selectedImage;
                  return GestureDetector(
                    onTap: () => onThumbnailClick(image),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(selectedImage, height: 400, fit: BoxFit.contain),
        ),
      ],
    );
  }
}
