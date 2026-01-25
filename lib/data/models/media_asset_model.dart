class MediaAssetModel {
  final String id;
  final String type;        // IMAGE | GIF | VIDEO
  final String category;    // POST | AVATAR | COVER ...
  final String url;
  final String? thumbnailUrl;
  final String name;
  final String? description;
  final List<String> tags;
  final int? width;
  final int? height;
  final int? fileSize;
  final bool isActive;
  final bool isFeatured;
  final int downloadCount;
  final DateTime createdAt;

  MediaAssetModel({
    required this.id,
    required this.type,
    required this.category,
    required this.url,
    this.thumbnailUrl,
    required this.name,
    this.description,
    required this.tags,
    this.width,
    this.height,
    this.fileSize,
    required this.isActive,
    required this.isFeatured,
    required this.downloadCount,
    required this.createdAt,
  });

  factory MediaAssetModel.fromJson(Map<String, dynamic> json) {
    return MediaAssetModel(
      id: json['id'],
      type: json['type'],
      category: json['category'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      name: json['name'],
      description: json['description'],
      tags: List<String>.from(json['tags'] ?? []),
      width: json['width'],
      height: json['height'],
      fileSize: json['fileSize'],
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      downloadCount: json['downloadCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
