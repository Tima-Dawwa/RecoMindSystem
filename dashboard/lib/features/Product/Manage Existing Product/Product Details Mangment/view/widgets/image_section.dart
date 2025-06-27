import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final VoidCallback onPickImages;
  final Function(int) onRemoveImage;
  final String? baseUrl;
  final List<Uint8List>? webImageBytes; // Add this for web compatibility

  const ImageGallery({
    super.key,
    required this.imageUrls,
    required this.onPickImages,
    required this.onRemoveImage,
    this.baseUrl,
    this.webImageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${imageUrls.length} Images',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onPickImages,
              icon: const Icon(Icons.collections, size: 18),
              label: const Text('Add Images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (imageUrls.isEmpty)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.collections_outlined,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No images added yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click "Add Images" to select multiple photos',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImage(imageUrls[index], index),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => onRemoveImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildImage(String imagePath, int index) {
    // Check if running on web
    if (kIsWeb) {
      // For web, check if we have byte data for this image
      if (webImageBytes != null && index < webImageBytes!.length) {
        return Image.memory(
          webImageBytes![index],
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Memory image error: $error');
            return _buildErrorContainer('Failed to load image');
          },
        );
      } else if (!imagePath.startsWith('/') && !imagePath.contains(':\\')) {
        // Network image
        final String imageUrl = _buildImageUrl(imagePath);
        return Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  strokeWidth: 2,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Network image error: $error');
            return _buildErrorContainer('Failed to load image');
          },
        );
      } else {
        // Local file path on web - not supported
        return _buildErrorContainer('Local files not supported on web');
      }
    } else {
      // For mobile/desktop platforms
      if (imagePath.startsWith('/') || imagePath.contains(':\\')) {
        // Local file path
        return Image.file(
          File(imagePath),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('File image error: $error');
            return _buildErrorContainer('Failed to load local image');
          },
        );
      } else {
        // Network image from backend
        final String imageUrl = _buildImageUrl(imagePath);
        return Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  strokeWidth: 2,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Network image error: $error');
            return _buildErrorContainer('Failed to load image');
          },
        );
      }
    }
  }

  String _buildImageUrl(String imagePath) {
    // Use provided baseUrl or default - make sure this matches your backend URL
    final String base =
        baseUrl ?? 'https://8a35-185-165-243-137.ngrok-free.app';

    // Ensure imagePath starts with '/' for proper URL construction
    if (!imagePath.startsWith('/')) {
      imagePath = '/$imagePath';
    }

    return '$base$imagePath';
  }

  Widget _buildErrorContainer(String message) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 32),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              message,
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
