import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

// MODEL DỮ LIỆU
class PostItem {
  final String id;
  final String thumbnailUrl;
  final String type; // 'image' hoặc 'video'

  PostItem({required this.id, required this.thumbnailUrl, required this.type});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color mainOrange = Color(0xFFF9622E);
  static const Color greyText = Color(0xFF797979);
  static const Color borderColor = Color(0xFFE2E5E9);

  late TabController _tabController;

  // DỮ LIỆU GIẢ LẬP
  final List<PostItem> _feeds = List.generate(
    15,
    (index) => PostItem(
      id: 'feed_$index',
      thumbnailUrl: 'https://placehold.co/300x300/png?text=Feed+$index',
      type: 'image',
    ),
  );

  final List<PostItem> _shorts = List.generate(
    10,
    (index) => PostItem(
      id: 'short_$index',
      thumbnailUrl: 'https://placehold.co/300x500/png?text=Short+$index',
      type: 'video',
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header cố định
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildHeaderActions(),
            ),

            // 2. Nội dung cuộn
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Khối màu trắng
                          Container(
                            margin: const EdgeInsets.only(top: 44),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                _buildUserInfo(),
                                const SizedBox(height: 20),
                                _buildStatsSection(),
                                const SizedBox(height: 24),
                                _buildActionButtons(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),

                          // Avatar (Truyền context vào đây)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: _buildAvatar(context),
                          ),
                        ],
                      ),
                    ),

                    // TabBar ghim đỉnh
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverTabBarDelegate(
                          TabBar(
                            controller: _tabController,
                            labelColor: mainOrange,
                            unselectedLabelColor: greyText,
                            indicatorColor: mainOrange,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(icon: Icon(Icons.grid_view), text: "Feeds"),
                              Tab(
                                icon: Icon(Icons.video_library_outlined),
                                text: "Shorts",
                              ),
                              Tab(icon: Icon(Icons.sell_outlined), text: "Tag"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMediaGrid(_feeds),
                    _buildMediaGrid(_shorts),
                    const Center(child: Text("No tagged posts")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Điều hướng sang trang Edit Profile
          Navigator.pushNamed(context, RouteNames.editProfile);
        },
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: mainOrange,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            backgroundColor: mainOrange,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        const Text(
          "Nguyễn Văn A",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "UI/UX Designer",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -0.7,
              child: const Icon(Icons.link, size: 16, color: mainOrange),
            ),
            const SizedBox(width: 4),
            const Text(
              "www.example.vn",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: mainOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem("123", "Post"),
          _buildVerticalLine(),
          _buildStatItem("13.2K", "Followers"),
          _buildVerticalLine(),
          _buildStatItem("123K", "Following"),
          _buildVerticalLine(),
          _buildStatItem("123M", "Likes"),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: mainOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Follow",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: mainOrange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFFF7E7D9).withOpacity(0.5),
              ),
              child: const Text(
                "Message",
                style: TextStyle(
                  color: mainOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircleIconBtn(Icons.arrow_back),
        const Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.setting);
          },
          child: _buildCircleIconBtn(Icons.settings),
        ),
      ],
    );
  }

  Widget _buildCircleIconBtn(IconData icon) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF1D1B20)),
    );
  }

  Widget _buildMediaGrid(List<PostItem> data) {
    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          key: PageStorageKey<String>(
            data.isNotEmpty ? data.first.type : 'empty',
          ),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(2),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = data[index];
                  return Image.network(item.thumbnailUrl, fit: BoxFit.cover);
                }, childCount: data.length),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
            color: greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLine() {
    return Container(width: 1, height: 25, color: const Color(0xFFD9D9D9));
  }
}

// Delegate cho TabBar ghim đỉnh
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
