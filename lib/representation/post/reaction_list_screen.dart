import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Bỏ comment dòng này khi đã cài firebase

// --- PREVIEW ---
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReactionListScreen(),
  ));
}

// --- MODELS (Chuẩn bị cho Firebase) ---
class ReactionUser {
  final String id;
  final String name;
  final String avatarUrl;
  final String reactionType; // Mặc định là 'heart' theo yêu cầu
  final DateTime? timestamp; // Thời gian thả tim để sort

  ReactionUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.reactionType,
    this.timestamp,
  });

  // Factory chuẩn để parse dữ liệu từ Firestore Document
  factory ReactionUser.fromFirestore(Map<String, dynamic> data, String id) {
    return ReactionUser(
      id: id,
      name: data['displayName'] ?? 'Người dùng ẩn danh',
      avatarUrl: data['photoURL'] ?? 'https://placehold.co/100x100/png?text=User',
      // Nếu data['type'] null thì mặc định là heart
      reactionType: data['type'] ?? 'heart',
      // timestamp: (data['createdAt'] as Timestamp?)?.toDate(), // Code mẫu lấy time từ Firestore
    );
  }
}

class ReactionListScreen extends StatefulWidget {
  const ReactionListScreen({super.key, this.postId});
  final String? postId;

  @override
  State<ReactionListScreen> createState() => _ReactionListScreenState();
}

class _ReactionListScreenState extends State<ReactionListScreen> {
  // Constants
  static const Color mainOrange = Color(0xFFF9622E);
  static const Color borderColor = Color(0xFFE2E5E9);
  
  // Stream quản lý dữ liệu Real-time
  late Stream<List<ReactionUser>> _reactionsStream;

  @override
  void initState() {
    super.initState();
    // Khởi tạo Stream (Hiện tại là giả lập, sau này thay bằng hàm Firebase bên dưới)
    _reactionsStream = _getMockReactionsStream();
    // _reactionsStream = _getRealFirebaseStream();
  }

  // --- HÀM GIẢ LẬP STREAM (MOCK) ---
  Stream<List<ReactionUser>> _getMockReactionsStream() async* {
    // Giả lập độ trễ mạng như thật
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Trả về dữ liệu
    yield List.generate(20, (index) => ReactionUser(
      id: 'user_$index',
      name: 'User Name $index',
      avatarUrl: 'https://placehold.co/100x100/png?text=U$index',
      reactionType: 'heart',
    ));
  }

  // --- HÀM KẾT NỐI FIREBASE THỰC TẾ (CODE MẪU) ---
  /*
  Stream<List<ReactionUser>> _getRealFirebaseStream() {
    // Truy cập vào sub-collection 'reactions' của bài viết
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('reactions') 
        .orderBy('createdAt', descending: true) // Sắp xếp mới nhất lên đầu
        .snapshots() // Lắng nghe real-time
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ReactionUser.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange, // Nền cam toàn màn hình
      body: SafeArea(
        bottom: false, // Để nội dung trắng tràn xuống đáy
        child: Column(
          children: [
            // 1. HEADER (Trên nền cam)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Nút Back nằm bên trái
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B20)),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ),
                  
                  // Tiêu đề "Feeling" nằm chính giữa
                  const Text(
                    "Feeling",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // 2. PHẦN NỘI DUNG TRẮNG (Expanded để chiếm hết phần còn lại)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                // --- STREAM BUILDER CHÍNH ---
                // Bao trùm cả phần Số lượng và Danh sách để xử lý dữ liệu tập trung
                child: StreamBuilder<List<ReactionUser>>(
                  stream: _reactionsStream,
                  builder: (context, snapshot) {
                    // Trạng thái: Đang tải
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: mainOrange));
                    }
                    
                    // Trạng thái: Lỗi
                    if (snapshot.hasError) {
                      return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
                    }

                    // Trạng thái: Có dữ liệu
                    final users = snapshot.data ?? [];

                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        // Thanh handle nhỏ trang trí
                        Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        // Phần hiển thị Số lượng & Trái tim hồng (Sử dụng dữ liệu từ Stream)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon trái tim hồng lớn
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.1), // Nền hồng nhạt
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite, color: Colors.pink, size: 24),
                            ),
                            const SizedBox(width: 12),
                            // Text số lượng
                            Text(
                              "${users.length} người đã thả tim",
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 1, color: Color(0xFFF2F2F2)),

                        // Danh sách người dùng (ListView)
                        Expanded(
                          child: users.isEmpty 
                            ? const Center(child: Text("Chưa có lượt tương tác nào."))
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                itemCount: users.length,
                                separatorBuilder: (ctx, index) => const Divider(height: 24, color: Color(0xFFF2F2F2)),
                                itemBuilder: (ctx, index) {
                                  return _buildUserItem(users[index]);
                                },
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CÁC WIDGET CON ---

  Widget _buildUserItem(ReactionUser user) {
    return Row(
      children: [
        // 1. Avatar + Badge Trái tim
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                // Luôn hiển thị icon trái tim đỏ
                child: Container(
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(Icons.favorite, size: 10, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(width: 12),
        
        // 2. Thông tin User
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Đã thả tim", // Cố định text
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        
        // Đã xóa nút Follow theo yêu cầu
      ],
    );
  }
}