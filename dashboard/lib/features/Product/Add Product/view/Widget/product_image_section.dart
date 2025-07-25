import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'card_wrapper.dart';

class ProductImageSection extends StatelessWidget {
  final List<PlatformFile> productFiles;
  final List<String> imageNames;
  final Function(List<PlatformFile>, List<String>) onImagesUpdated;
  final Function(int) onImageRemoved;

  const ProductImageSection({
    super.key,
    required this.productFiles,
    required this.imageNames,
    required this.onImagesUpdated,
    required this.onImageRemoved,
  });

  Future<void> _addImagesFromDesktop(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> newFiles = List.from(productFiles);
        List<String> newNames = List.from(imageNames);

        for (var file in result.files) {
          newFiles.add(file);
          newNames.add(file.name);
        }

        onImagesUpdated(newFiles, newNames);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result.files.length} image(s) added successfully!',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting images: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      title: 'Product Images',
      child: Column(
        children: [
          ImageUploadButton(onTap: () => _addImagesFromDesktop(context)),
          SizedBox(height: 16),

          if (productFiles.isNotEmpty)
            ImageGrid(
              productFiles: productFiles,
              imageNames: imageNames,
              onImageRemoved: onImageRemoved,
            ),
        ],
      ),
    );
  }
}

class ImageUploadButton extends StatelessWidget {
  final VoidCallback onTap;

  const ImageUploadButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: Themes.primary,
              ),
              SizedBox(height: 8),
              Text(
                'Click to select images from desktop',
                style: TextStyle(
                  color: Themes.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Support multiple image selection',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final List<PlatformFile> productFiles;
  final List<String> imageNames;
  final Function(int) onImageRemoved;

  const ImageGrid({
    super.key,
    required this.productFiles,
    required this.imageNames,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: productFiles.length,
      itemBuilder: (context, index) {
        return ImageGridItem(
          platformFile: productFiles[index],
          imageName: imageNames[index],
          onRemove: () => onImageRemoved(index),
        );
      },
    );
  }
}

class ImageGridItem extends StatelessWidget {
  final PlatformFile platformFile;
  final String imageName;
  final VoidCallback onRemove;

  const ImageGridItem({
    super.key,
    required this.platformFile,
    required this.imageName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                (platformFile.bytes != null)
                    ? Image.memory(
                      platformFile.bytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: Colors.grey[400]),
                          SizedBox(height: 4),
                          Text(
                            imageName,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
