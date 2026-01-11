import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. LỚP VIDEO (Background)
        GestureDetector(
          onTap: _togglePlay,
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
          ),
        ),

        // 2. Lớp phủ Gradient
        _buildGradientOverlay(),

        // 3. Các nội dung UI
        SafeArea(
          child: Stack(
            children: [
              _buildHeader(),
              // Logic hiển thị nút Play ở giữa: Chỉ hiện khi Pause
              if (!_isPlaying && !_isLoading) _buildCenterPlayButton(),
              _buildRightSidebar(),
              _buildBottomInfo(),
            ],
          ),
        ),
      ],
    );
  }

  // --- CÁC WIDGET UI CŨ CỦA BẠN ---

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
            stops: const [0.0, 0.2, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 10,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return Center(
      child: GestureDetector(
        onTap: _togglePlay,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 45),
        ),
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Positioned(
      right: 15,
      bottom: 30,
      child: Column(
        children: [
          _buildSidebarItem(Icons.favorite, '33.2K', color: Colors.redAccent),
          _buildSidebarItem(Icons.chat_bubble_outline, '2.2K'),
          _buildSidebarItem(Icons.send_outlined, '20.2K'),
          _buildSidebarItem(Icons.bookmark_border, '10.2K'),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      left: 20,
      bottom: 25,
      right: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=32',
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Brooklyn Simmons',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.orange, size: 14),
              const SizedBox(width: 10),
              _buildFollowButton(),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'what i',
            style: TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.music_note, color: Colors.white, size: 16),
              SizedBox(width: 5),
              Text(
                'Âm thanh gốc - Aria Nova',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF9622E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Follow',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String label, {
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
