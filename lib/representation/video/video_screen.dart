import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/widgets/video_player_item.dart';

final List<String> videoUrls = [
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
];

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      // Dùng PageView.builder để xử lý việc cuộn dọc
      body: PageViewBuilder(),
    );
  }
}

class PageViewBuilder extends StatelessWidget {
  const PageViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      itemBuilder: (context, index) {
        return VideoPlayerItem(videoUrl: videoUrls[index]);
      },
    );
  }
}
