import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';
import '../../../data/services/media_asset_service.dart';
import '../../../data/models/media_asset_model.dart';

class GifPickerSheet {
  static const Color mainOrange = Color(0xFFF9622E);

  static void show(
    BuildContext context,
    CreatePostController controller, {
    bool isGif = false,
  }) {
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
              child: _ImagePickerContent(
                scrollController: scrollController,
                controller: controller,
                isGif: isGif,
              ),
            );
          },
        );
      },
    );
  }
}

class _ImagePickerContent extends StatefulWidget {
  final ScrollController scrollController;
  final CreatePostController controller;
  final bool isGif;

  const _ImagePickerContent({
    required this.scrollController,
    required this.controller,
    required this.isGif,
  });

  @override
  State<_ImagePickerContent> createState() => _ImagePickerContentState();
}

class _ImagePickerContentState extends State<_ImagePickerContent> {
  static const Color mainOrange = Color(0xFFF9622E);
  final MediaAssetService _mediaService = MediaAssetService();

  late Future<List<MediaAssetModel>> _mediaFuture;
  List<String> _tempSelectedImages = [];
  TextEditingController searchController = TextEditingController();
  List<MediaAssetModel>? _allMedia;
  List<MediaAssetModel>? _filteredMedia;

  @override
  void initState() {
    super.initState();
    _tempSelectedImages = List.from(widget.controller.selectedImages);

    // Load ảnh từ API
    _mediaFuture = _loadMediaAssets();
  }

  Future<List<MediaAssetModel>> _loadMediaAssets() async {
    try {
      final media = await _mediaService.getMediaAssets(
        type: 'GIF',
        category: 'POST',
      );
      _allMedia = media;
      _filteredMedia = media;
      return media;
    } catch (e) {
      print('❌ Error loading media: $e');
      rethrow;
    }
  }

  void _filterMedia(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMedia = _allMedia;
      } else {
        _filteredMedia = _allMedia?.where((media) {
          return media.name.toLowerCase().contains(query.toLowerCase()) ||
              media.tags.any(
                (tag) => tag.toLowerCase().contains(query.toLowerCase()),
              );
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isGif ? "Chọn GIF" : "Thư viện ảnh",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.controller.setImages(_tempSelectedImages);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Xong",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: mainOrange,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search bar
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
                hintText: "Tìm kiếm ảnh...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          searchController.clear();
                          _filterMedia('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterMedia,
            ),
          ),
        ),

        const Divider(height: 1),

        // Grid
        Expanded(
          child: FutureBuilder<List<MediaAssetModel>>(
            future: _mediaFuture,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: mainOrange),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text('Lỗi: ${snapshot.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mediaFuture = _loadMediaAssets();
                          });
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              final mediaList = _filteredMedia ?? [];
              if (mediaList.isEmpty) {
                return const Center(child: Text('Không có ảnh nào'));
              }

              return GridView.builder(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: mediaList.length,
                itemBuilder: (ctx, index) {
                  final media = mediaList[index];
                  final isSelected = _tempSelectedImages.contains(media.url);
                  final selectionIndex =
                      _tempSelectedImages.indexOf(media.url) + 1;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _tempSelectedImages.remove(media.url);
                        } else {
                          _tempSelectedImages.add(media.url);
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
                            child: Image.network(
                              media.url,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
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
                              decoration: const BoxDecoration(
                                color: mainOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$selectionIndex',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
