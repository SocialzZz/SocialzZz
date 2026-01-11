import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';

class FeelingSheet {
  static void show(BuildContext context, CreatePostController controller) {
    final List<String> allFeelings = [
      "Hạnh phúc 😄", 
      "Buồn 😔", 
      "Hào hứng 🤩", 
      "Mệt mỏi 😫", 
      "Biết ơn 🙏", 
      "Yêu đời 🥰", 
      "Giận dữ 😡"
    ];
    List<String> filteredFeelings = List.from(allFeelings);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (ctx, setStateModal) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            "Bạn đang cảm thấy thế nào?", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100], 
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: "Tìm kiếm cảm xúc...",
                                prefixIcon: Icon(Icons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              onChanged: (val) {
                                setStateModal(() {
                                  filteredFeelings = allFeelings
                                      .where((f) => f.toLowerCase().contains(val.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredFeelings.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
                            ),
                            child: ListTile(
                              title: Text(filteredFeelings[index]),
                              onTap: () {
                                controller.setFeeling(filteredFeelings[index]);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            );
          },
        );
      },
    );
  }
}
