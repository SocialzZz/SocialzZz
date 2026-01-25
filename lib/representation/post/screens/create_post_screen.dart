import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';
import '../widgets/post_header.dart';
import '../widgets/post_input.dart';
import '../widgets/post_image_grid.dart';
import '../widgets/post_action_bar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const Color mainOrange = Color(0xFFF9622E);
  
  late final CreatePostController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CreatePostController(context: context);
    _controller.loadCurrentUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      body: Column(
        children: [
          // Header
          Container(
            color: mainOrange,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36, 
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        shape: BoxShape.circle, 
                        border: Border.all(color: const Color(0xFFE2E5E9))
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero, 
                        iconSize: 20,
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B20)),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    const Text(
                      'Create Post', 
                      style: TextStyle(
                        fontFamily: 'Roboto', 
                        fontWeight: FontWeight.w700, 
                        fontSize: 18, 
                        color: Colors.white
                      )
                    ),
                    ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        return TextButton(
                          onPressed: _controller.isUploading ? null : _controller.handlePostToFirebase,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: const Size(60, 36),
                          ),
                          child: _controller.isUploading 
                            ? const SizedBox(
                                width: 16, 
                                height: 16, 
                                child: CircularProgressIndicator(strokeWidth: 2, color: mainOrange)
                              )
                            : const Text(
                                'POST', 
                                style: TextStyle(
                                  fontFamily: 'Roboto', 
                                  fontWeight: FontWeight.w700, 
                                  fontSize: 14, 
                                  color: mainOrange
                                )
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), 
                  topRight: Radius.circular(30)
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40, 
                    height: 4, 
                    decoration: BoxDecoration(
                      color: Colors.grey[300], 
                      borderRadius: BorderRadius.circular(2)
                    )
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                      child: ListenableBuilder(
                        listenable: _controller,
                        builder: (context, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PostHeader(controller: _controller),
                              const SizedBox(height: 16),
                              PostInput(controller: _controller),
                              const SizedBox(height: 16),
                              if (_controller.taggedFriends.isNotEmpty) ...[
                                _buildTaggedFriendsList(),
                                const SizedBox(height: 16),
                              ],
                              _buildHashtagsSection(),
                              const SizedBox(height: 16),
                              if (_controller.selectedImages.isNotEmpty) 
                                PostImageGrid(controller: _controller),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  
                  PostActionBar(controller: _controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaggedFriendsList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E5E9)), 
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, size: 16, color: mainOrange),
              const SizedBox(width: 6),
              Text(
                "Cùng với ${_controller.taggedFriends.length} người khác:", 
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, 
            runSpacing: 8,
            children: _controller.taggedFriends.map((friend) {
              return Chip(
                label: Text(friend, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => _controller.removeTaggedFriend(friend),
                backgroundColor: Colors.grey[100],
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHashtagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Hashtags", 
          style: TextStyle(
            fontFamily: 'Roboto', 
            fontWeight: FontWeight.bold, 
            fontSize: 13, 
            color: Colors.grey
          )
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, 
          runSpacing: 8,
          children: ["#Flutter", "#Coding", "#MobileApp", "#LifeStyle"]
              .map((tag) => _buildHashtagChip(tag))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildHashtagChip(String text) {
    return InkWell(
      onTap: () => _controller.onHashtagTap(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF7E7D9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Text(
          text, 
          style: const TextStyle(
            color: mainOrange, 
            fontWeight: FontWeight.w500, 
            fontSize: 12
          )
        ),
      ),
    );
  }
}