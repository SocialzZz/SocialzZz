import 'package:flutter/material.dart';
import '../../../data/services/post_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/route_names.dart';

class CreatePostController extends ChangeNotifier {
  final BuildContext context;
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  
  CreatePostController({required this.context});

  final TextEditingController contentController = TextEditingController();
  
  String _selectedPrivacy = 'PUBLIC';
  bool _isUploading = false;
  List<String> _selectedImages = [];
  List<String> _taggedFriends = [];
  String? _selectedFeeling;
  String? _selectedLocation;
  UserModel? _currentUser;
  bool _isLoadingUser = false;

  // Getters
  String get selectedPrivacy => _selectedPrivacy;
  bool get isUploading => _isUploading;
  List<String> get selectedImages => _selectedImages;
  List<String> get taggedFriends => _taggedFriends;
  String? get selectedFeeling => _selectedFeeling;
  String? get selectedLocation => _selectedLocation;
  UserModel? get currentUser => _currentUser;
  bool get isLoadingUser => _isLoadingUser;

  // Load user data khi initialize
  Future<void> loadCurrentUser() async {
    _isLoadingUser = true;
    notifyListeners();
    
    try {
      _currentUser = await _userService.fetchUserProfile('');
      _isLoadingUser = false;
      notifyListeners();
      print('✅ User loaded successfully');
    } catch (e) {
      _isLoadingUser = false;
      notifyListeners();
      print('❌ Error loading user: $e');
    }
  }

  // Setters
  void setPrivacy(String privacy) {
    _selectedPrivacy = privacy.toUpperCase();
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

  List<String> _extractHashtags(String text) {
    final RegExp hashtagRegExp = RegExp(r'#\w+');
    final matches = hashtagRegExp.allMatches(text);
    return matches.map((m) => m.group(0) ?? '').toList();
  }

  Future<void> handlePostToFirebase() async {
    if (contentController.text.isEmpty && _selectedImages.isEmpty) {
      _showError('Vui lòng nhập nội dung hoặc chọn ảnh!');
      return;
    }

    FocusScope.of(context).unfocus();
    
    if (_isUploading) {
      print('⚠️ Already uploading, ignoring request');
      return;
    }

    _isUploading = true;
    notifyListeners();
    print('📝 Starting post creation...');

    try {
      print('📤 Sending request to backend...');
      
      await _postService.createPost(
        content: contentController.text,
        privacy: _selectedPrivacy,
        mediaUrls: _selectedImages.isNotEmpty ? _selectedImages : null,
        feeling: _selectedFeeling,
        location: _selectedLocation,
        hashtags: _extractHashtags(contentController.text),
      );

      _isUploading = false;
      notifyListeners();
      
      print('✅ Post created successfully');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã đăng bài thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Delay rồi navigate về home
        await Future.delayed(const Duration(milliseconds: 800));
        if (context.mounted) {
          // Option 1: Dùng pushReplacementNamed để replace screen
          Navigator.of(context).pushReplacementNamed(RouteNames.home);
          
          // Option 2: Nếu không có named route, dùng cách này
          // Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      print('❌ Error creating post: $e');
      _showError('Lỗi: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  void _showError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
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