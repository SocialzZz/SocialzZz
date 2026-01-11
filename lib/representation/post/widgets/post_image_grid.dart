import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';

class PostImageGrid extends StatelessWidget {
  final CreatePostController controller;
  
  const PostImageGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    int count = controller.selectedImages.length;
    
    // 1 image
    if (count == 1) {
      return _buildImageItem(0, height: 250, width: double.infinity);
    }
    
    // 2 images
    if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildImageItem(0, height: 200)),
          const SizedBox(width: 4),
          Expanded(child: _buildImageItem(1, height: 200)),
        ],
      );
    }
    
    // 3 images
    if (count == 3) {
      return Column(
        children: [
          _buildImageItem(0, height: 200, width: double.infinity),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _buildImageItem(1, height: 150)),
              const SizedBox(width: 4),
              Expanded(child: _buildImageItem(2, height: 150)),
            ],
          ),
        ],
      );
    }
    
    // 4+ images
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildImageItem(0, height: 180)),
            const SizedBox(width: 4),
            Expanded(child: _buildImageItem(1, height: 180)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildImageItem(2, height: 180)),
            const SizedBox(width: 4),
            Expanded(
              child: SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _buildImageItem(3, height: null, width: null, showRemove: false, isOverlay: true)
                    ),
                    if (count > 4)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: Text(
                            "+${count - 4}",
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 24, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 5, 
                      right: 5,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(3),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54, 
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageItem(int index, {double? height, double? width, bool showRemove = true, bool isOverlay = false}) {
    if (index >= controller.selectedImages.length) return const SizedBox();

    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        controller.selectedImages[index],
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => Container(
          color: Colors.grey[300], 
          child: const Icon(Icons.error)
        ),
      ),
    );

    if (isOverlay) return imageWidget;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          if (showRemove)
            Positioned(
              top: 5, 
              right: 5,
              child: GestureDetector(
                onTap: () => controller.removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54, 
                    shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            )
        ],
      ),
    );
  }
}