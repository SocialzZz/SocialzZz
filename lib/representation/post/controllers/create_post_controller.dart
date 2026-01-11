import 'package:flutter/material.dart';

class CreatePostController extends ChangeNotifier {
  final BuildContext context;
  
  CreatePostController({required this.context});

  final TextEditingController contentController = TextEditingController();
  
  String _selectedPrivacy = 'Public';
  bool _isUploading = false;
  List<String> _selectedImages = [];
  List<String> _taggedFriends = [];
  String? _selectedFeeling;
  String? _selectedLocation;

  // Getters
  String get selectedPrivacy => _selectedPrivacy;
  bool get isUploading => _isUploading;
  List<String> get selectedImages => _selectedImages;
  List<String> get taggedFriends => _taggedFriends;
  String? get selectedFeeling => _selectedFeeling;
  String? get selectedLocation => _selectedLocation;

  // Setters
  void setPrivacy(String privacy) {
    _selectedPrivacy = privacy;
    notifyListeners();
  }

  void setFeeling(String? feeling) {
    _selectedFeeling = feeling;
    notifyListeners();
  }

  void setLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setImages(List<String> images) {
    _selectedImages = images;
    notifyListeners();
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  void setTaggedFriends(List<String> friends) {
    _taggedFriends = friends;
    notifyListeners();
  }

  void removeTaggedFriend(String friend) {
    _taggedFriends.remove(friend);
    notifyListeners();
  }

  // Post handling
  Future<void> handlePostToFirebase() async {
    if (contentController.text.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung hoặc chọn ảnh!')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    _isUploading = true;
    notifyListeners();
    
    // Simulate posting
    await Future.delayed(const Duration(milliseconds: 1500));
    
    _isUploading = false;
    notifyListeners();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đăng bài thành công!')),
      );
    }
  }

  void onHashtagTap(String tag) {
    String currentText = contentController.text;
    if (currentText.isNotEmpty && !currentText.endsWith(' ')) {
      contentController.text = "$currentText $tag ";
    } else {
      contentController.text = "$currentText$tag ";
    }
    contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: contentController.text.length),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }
}