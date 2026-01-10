import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/status_data.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';
import '../../data/models/live_card_data.dart';

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

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/images/SocialzZz-Logo.jpg',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          const Text(
            'SocialzZz',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const Spacer(),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteNames.search),
            child: const Icon(Icons.search_sharp, size: 28),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, RouteNames.notification),
            },
            child: Icon(Icons.notifications_none, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCard(LiveCardData data) {
    const double cardWidth = 140;
    const double cardHeight = 220;

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(data.backgroundImageURL),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(100),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            if (data.isYou)
              const Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.add, size: 30, color: Colors.black54),
                ),
              ),

            Positioned(
              bottom: 10,
              left: 8,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(data.avatarURL),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    data.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(StatusData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // 1. Header: Avatar, Name, Verified, More icon
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 6,
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(data.userAvatar),
            ),
            title: Row(
              children: [
                Text(
                  data.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (data.isVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified, color: Colors.orange, size: 16),
                  ),
              ],
            ),
            subtitle: Text(
              "@${data.userName.toLowerCase().replaceAll(' ', '_')}",
            ),
            trailing: const Icon(Icons.more_vert),
          ),

          // 2. Nội dung: Hình ảnh bài đăng
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  data.postImage,
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          // 3. Footer: Like, Comment, Share, Save
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                _buildInteractionItem(Icons.favorite_border, data.likes),
                const SizedBox(width: 15),
                _buildInteractionItem(Icons.chat_outlined, data.comments),
                const SizedBox(width: 15),
                _buildInteractionItem(Icons.reply_rounded, data.shares),
                const Spacer(),
                const Icon(Icons.bookmark_border, size: 28),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              thickness: 1,
              color: Color.fromARGB(255, 207, 205, 205),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.black87),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        itemCount: _statusItems.length + 2, // +2 cho Header Logo và Live Cards
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTopHeader();
          } else if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _liveItems.length,
                  itemBuilder: (context, i) => _buildLiveCard(_liveItems[i]),
                ),
              ),
            );
          } else {
            // Trả về các bài đăng (Index bắt đầu từ 2 nên phải trừ đi 2)
            return _buildStatusCard(_statusItems[index - 2]);
          }
        },
      ),
    );
  }
}
