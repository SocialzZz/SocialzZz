import 'package:flutter/material.dart';
import '../controllers/reaction_controller.dart';
import '../widgets/reaction_counter.dart';
import '../widgets/reaction_item.dart';

class ReactionListScreen extends StatefulWidget {
  const ReactionListScreen({super.key, this.postId});
  final String? postId;

  @override
  State<ReactionListScreen> createState() => _ReactionListScreenState();
}

class _ReactionListScreenState extends State<ReactionListScreen> {
  static const Color mainOrange = Color(0xFFF9622E);
  
  late final ReactionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ReactionController(postId: widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 36, 
                      height: 36,
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

            // Content
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
                child: StreamBuilder<List<ReactionUser>>(
                  stream: _controller.reactionsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: mainOrange)
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Đã xảy ra lỗi: ${snapshot.error}")
                      );
                    }

                    final users = snapshot.data ?? [];

                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 40, 
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        ReactionCounter(count: users.length),

                        const SizedBox(height: 20),
                        const Divider(height: 1, color: Color(0xFFF2F2F2)),

                        Expanded(
                          child: users.isEmpty 
                            ? const Center(child: Text("Chưa có lượt tương tác nào."))
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 10
                                ),
                                itemCount: users.length,
                                separatorBuilder: (ctx, index) => const Divider(
                                  height: 24, 
                                  color: Color(0xFFF2F2F2)
                                ),
                                itemBuilder: (ctx, index) {
                                  return ReactionItem(user: users[index]);
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
}