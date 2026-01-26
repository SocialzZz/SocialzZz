import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/services/token_manager.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';
import 'package:flutter_social_media_app/widgets/circle_icon_btn.dart';
import 'package:flutter_social_media_app/data/services/user_service.dart';
import 'package:flutter_social_media_app/data/models/user_model.dart';

// MODEL DỮ LIỆU BÀI VIẾT (Giữ nguyên)
class PostItem {
  final String id;
  final String thumbnailUrl;
  final String type;

  PostItem({required this.id, required this.thumbnailUrl, required this.type});
}

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color mainOrange = Color(0xFFF9622E);
  static const Color greyText = Color(0xFF797979);
  bool isMe = false;

  late Future<UserModel> _userFuture;
  final UserService _userService = UserService();

  late TabController _tabController;
  final TokenManager _tokenManager = TokenManager();

  // DỮ LIỆU GIẢ LẬP (Giữ nguyên)
  final List<PostItem> _feeds = List.generate(
    15,
    (i) => PostItem(
      id: 'f_$i',
      thumbnailUrl: 'https://placehold.co/300x300/png?text=Feed+$i',
      type: 'image',
    ),
  );
  final List<PostItem> _shorts = List.generate(
    10,
    (i) => PostItem(
      id: 's_$i',
      thumbnailUrl: 'https://placehold.co/300x500/png?text=Short+$i',
      type: 'video',
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Khởi tạo gọi API lấy thông tin User từ Prisma
    _userFuture = _userService.fetchUserProfile(widget.userId);
    _initData();

    _checkOwnership();
  }

  void _initData() {
    _userFuture = _userService.fetchUserProfile(widget.userId);
    isMe = (_tokenManager.userId == widget.userId);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      setState(() {
        _initData();
      });
    }
  }

  void _checkOwnership() {
    // So sánh ID truyền vào với ID đang lưu trong máy
    final currentUserId = _tokenManager.userId;
    setState(() {
      isMe = (currentUserId == widget.userId);
    });
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
        child: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Lỗi: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "Không tìm thấy người dùng",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final user =
                snapshot.data!; // Dữ liệu người dùng từ schema [cite: 2, 3]

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildHeaderActions(),
                ),
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
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
                                    _buildUserInfo(
                                      user,
                                    ), // Truyền dữ liệu user vào đây
                                    const SizedBox(height: 20),
                                    _buildStatsSection(),
                                    const SizedBox(height: 24),
                                    _buildActionButtons(),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: _buildAvatar(
                                  context,
                                  user,
                                ), // Truyền dữ liệu user vào avatar
                              ),
                            ],
                          ),
                        ),
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
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
                                  Tab(
                                    icon: Icon(Icons.grid_view),
                                    text: "Feeds",
                                  ),
                                  Tab(
                                    icon: Icon(Icons.video_library_outlined),
                                    text: "Shorts",
                                  ),
                                  Tab(
                                    icon: Icon(Icons.sell_outlined),
                                    text: "Tag",
                                  ),
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
            );
          },
        ),
      ),
    );
  }

  // Cập nhật Avatar hiển thị từ URL trong database
  // Trong ProfileScreen, tìm chỗ navigate đến EditProfile và sửa lại:

  Widget _buildAvatar(BuildContext context, UserModel user) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // ✅ Chờ result từ EditProfile
          final result = await Navigator.pushNamed(
            context,
            RouteNames.editProfile,
          );

          // ✅ Nếu có result (user đã update), reload lại
          if (result != null && mounted) {
            setState(() {
              _userFuture = _userService.fetchUserProfile(widget.userId);
            });
          }
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
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
              user.avatarUrl ?? 'https://via.placeholder.com/150',
            ),
          ),
        ),
      ),
    );
  }

  // Hiển thị tên (name) từ schema User
  Widget _buildUserInfo(UserModel user) {
    return Column(
      children: [
        Text(
          user.name ?? "Người dùng mới",
          style: const TextStyle(
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
    // Nếu là chính mình, không hiển thị cụm nút Follow/Message
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Có thể điều hướng đến trang Edit Profile ở đây nếu muốn
              Navigator.pushNamed(context, RouteNames.editProfile).then((
                value,
              ) {
                if (value != null)
                  setState(() {
                    _userFuture = _userService.fetchUserProfile(widget.userId);
                  });
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Color(0xFFF9622E),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    // Hiển thị cho người dùng khác
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: mainOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Follow",
                style: TextStyle(color: Colors.white),
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
              ),
              child: const Text("Message", style: TextStyle(color: mainOrange)),
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
        const SizedBox(width: 30),
        const Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        CircleIconButton(
          icon: Icons.settings,
          onPressed: () => Navigator.pushNamed(context, RouteNames.setting),
        ),
      ],
    );
  }

  Widget _buildMediaGrid(List<PostItem> data) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    Image.network(data[index].thumbnailUrl, fit: BoxFit.cover),
                childCount: data.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String number, String label) => Column(
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
  Widget _buildVerticalLine() =>
      Container(width: 1, height: 25, color: const Color(0xFFD9D9D9));
}

// Delegate cho TabBar (Giữ nguyên)
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverTabBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(context, shrinkOffset, overlapsContent) =>
      Container(color: Colors.white, child: _tabBar);
  @override
  bool shouldRebuild(_SliverTabBarDelegate old) => false;
}
