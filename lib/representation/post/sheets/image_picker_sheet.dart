import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';

class ImagePickerSheet {
  static const Color mainOrange = Color(0xFFF9622E);
  
  static void show(BuildContext context, CreatePostController controller, {bool isGif = false}) {
    final List<String> mockImages = List.generate(
      30, 
      (index) => 'https://placehold.co/300x${isGif ? 200 : 300}/png?text=${isGif ? "GIF" : "IMG"}+$index'
    );

    List<String> tempSelectedImages = List.from(controller.selectedImages);
    List<String> filteredImages = List.from(mockImages);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: StatefulBuilder(
                builder: (context, setStateModal) {
                  return Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isGif ? "Chọn GIF" : "Thư viện ảnh", 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                            ),
                            TextButton(
                              onPressed: () {
                                controller.setImages(tempSelectedImages);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Xong", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16, 
                                  color: mainOrange
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      // Search bar for GIF
                      if (isGif)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Tìm kiếm GIF...",
                                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                suffixIcon: searchController.text.isNotEmpty 
                                  ? IconButton(
                                      icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                      onPressed: () {
                                        searchController.clear();
                                        setStateModal(() => filteredImages = mockImages);
                                      },
                                    ) 
                                  : null,
                              ),
                              onChanged: (val) {
                                setStateModal(() {
                                  if (val.isEmpty) {
                                    filteredImages = mockImages;
                                  } else {
                                    filteredImages = mockImages.take(10).toList();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      
                      const Divider(height: 1),
                      
                      // Grid
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(4),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, 
                            crossAxisSpacing: 4, 
                            mainAxisSpacing: 4,
                          ),
                          itemCount: filteredImages.length,
                          itemBuilder: (ctx, index) {
                            final imgUrl = filteredImages[index];
                            final isSelected = tempSelectedImages.contains(imgUrl);
                            final selectionIndex = tempSelectedImages.indexOf(imgUrl) + 1;

                            return GestureDetector(
                              onTap: () {
                                setStateModal(() {
                                  if (isSelected) {
                                    tempSelectedImages.remove(imgUrl);
                                  } else {
                                    tempSelectedImages.add(imgUrl);
                                  }
                                });
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  AnimatedScale(
                                    scale: isSelected ? 0.9 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(imgUrl, fit: BoxFit.cover),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 4, 
                                      right: 4,
                                      child: Container(
                                        width: 24, 
                                        height: 24,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: mainOrange,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 1.5),
                                        ),
                                        child: Text(
                                          "$selectionIndex",
                                          style: const TextStyle(
                                            color: Colors.white, 
                                            fontSize: 12, 
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}