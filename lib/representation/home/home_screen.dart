import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/status_data.dart';
import '../../data/models/live_card_data.dart';
import 'home_header.dart';
import 'live_card_widget.dart';
import 'status_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<LiveCardData> _liveItems = [
    LiveCardData(
      backgroundImageURL: 'assets/images/i.jpg',
      avatarURL: 'assets/images/avt.png',
      userName: 'You',
      isYou: true,
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/i.jpg',
      avatarURL: 'assets/images/avt.png',
      userName: 'Theresa',
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/i.jpg',
      avatarURL: 'assets/images/avt.png',
      userName: 'James Scob',
    ),
  ];

  final List<StatusData> _statusItems = [
    StatusData(
      userName: 'Brooklyn Simmons',
      userAvatar: 'assets/images/avt.png',
      postImage: 'assets/images/i.jpg',
      isVerified: true,
      likes: '22.8k',
      comments: '2.1k',
      shares: '25.3k',
    ),
    StatusData(
      userName: 'Stateless',
      userAvatar: 'assets/images/avt.png',
      postImage: 'assets/images/i.jpg',
      isVerified: true,
      likes: '22.8k',
      comments: '2.1k',
      shares: '25.3k',
    ),
    StatusData(
      userName: 'Nice',
      userAvatar: 'assets/images/avt.png',
      postImage: 'assets/images/i.jpg',
      isVerified: true,
      likes: '22.8k',
      comments: '2.1k',
      shares: '25.3k',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        itemCount: _statusItems.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const HomeHeader();
          } else if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _liveItems.length,
                  itemBuilder: (context, i) =>
                      LiveCardWidget(data: _liveItems[i]),
                ),
              ),
            );
          } else {
            return StatusCardWidget(data: _statusItems[index - 2]);
          }
        },
      ),
    );
  }
}
