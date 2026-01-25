import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/representation/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media_app/data/services/user_service.dart';
import 'package:flutter_social_media_app/widgets/show_snackbar.dart';

class EditprofileScreen extends StatefulWidget {
  const EditprofileScreen({super.key});

  @override
  State<EditprofileScreen> createState() => _EditprofileScreenState();
}

class _EditprofileScreenState extends State<EditprofileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  File? _selectedImage;
  String? _currentAvatarUrl;
  String? _userId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() => _isLoading = true);

      _userId = await _authService.getUserId();

      if (_userId == null) {
        throw Exception('User ID not found');
      }

      final user = await _userService.fetchUserProfile(_userId!);

      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _currentAvatarUrl = user.avatarUrl;

      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ Error loading profile: $e');
      if (mounted) {
        ShowSnackbar.showError(context, 'Failed to load profile: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ShowSnackbar.showError(context, 'Name cannot be empty');
      return;
    }

    setState(() => _isSaving = true);

    try {
      String? newAvatarUrl = _currentAvatarUrl;

      if (_selectedImage != null) {
        // TODO: Upload image to server
        ShowSnackbar.showError(context, 'Image upload not implemented yet');
      }

      final updatedUser = await _userService.updateUserProfile(
        userId: _userId!,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        avatarUrl: newAvatarUrl,
      );

      if (mounted) {
        ShowSnackbar.showSuccess(context, 'Profile updated successfully!');

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context, updatedUser);
          }
        });
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      if (mounted) {
        ShowSnackbar.showError(context, 'Failed to update profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Profile Picture
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              shape: BoxShape.circle,
                            ),
                            child: _selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _selectedImage!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : _currentAvatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _currentAvatarUrl!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Color(0xFFB39DDB),
                                            );
                                          },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color(0xFFB39DDB),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Name Field
                    _buildTextField(label: 'Name', controller: _nameController),
                    const SizedBox(height: 24),
                    // Email Field
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 48),
                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          disabledBackgroundColor: const Color(0xFFFFB39D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 16, color: Color(0xFF212121)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF6B35)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ShowSnackbar.showError(context, 'Lỗi khi chọn ảnh: $e');
      }
    }
  }
}
