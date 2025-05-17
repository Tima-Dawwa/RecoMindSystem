import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class ProductImageSectionMobile extends StatelessWidget {
  final String selectedImage;
  final Function(String) onThumbnailClick;
  final List<String> imageList;

  const ProductImageSectionMobile({
    super.key,
    required this.selectedImage,
    required this.onThumbnailClick,
    required this.imageList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                selectedImage,
                height: 260,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (imageList.length > 1)
            SizedBox(
              height: 100,
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    final image = imageList[index];
                    final isSelected = image == selectedImage;

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => onThumbnailClick(image),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.blueAccent
                                      : Colors.transparent,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              image,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
