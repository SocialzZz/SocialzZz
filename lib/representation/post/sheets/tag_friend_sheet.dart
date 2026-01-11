import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';

class TagFriendSheet {
  static const Color mainOrange = Color(0xFFF9622E);
  
  static void show(BuildContext context, CreatePostController controller) {
    final List<Map<String, String>> allFriends = List.generate(
      20, 
      (index) => {"name": "Bạn bè ${index + 1}", "info": "Bạn chung: 1${index}"}
    );
    List<Map<String, String>> filteredFriends = List.from(allFriends);
    List<String> tempTagged = List.from(controller.taggedFriends);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: StatefulBuilder(
                builder: (context, setStateModal) {
                  return Column(
                    children: [
                      // Header & Search
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Search bar
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    hintText: "Tìm kiếm bạn bè...",
                                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onChanged: (val) {
                                    setStateModal(() {
                                      filteredFriends = allFriends
                                          .where((f) => f['name']!
                                              .toLowerCase()
                                              .contains(val.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            // Done button
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                controller.setTaggedFriends(tempTagged);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Xong", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16, 
                                  color: mainOrange
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      // Selected friends chips
                      if (tempTagged.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tempTagged.map((friend) => Chip(
                              label: Text(friend),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setStateModal(() {
                                  tempTagged.remove(friend);
                                });
                              },
                              backgroundColor: Colors.blue[50],
                              side: BorderSide.none,
                            )).toList(),
                          ),
                        ),
                      
                      // Friends list
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filteredFriends.length,
                          itemBuilder: (ctx, index) {
                            final friendName = filteredFriends[index]['name']!;
                            final friendInfo = filteredFriends[index]['info']!;
                            final isSelected = tempTagged.contains(friendName);
                            
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFF2F2F2), width: 1)
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  child: const Icon(Icons.person, color: Colors.blue),
                                ),
                                title: Text(
                                  friendName, 
                                  style: const TextStyle(fontWeight: FontWeight.bold)
                                ),
                                subtitle: Text(
                                  friendInfo, 
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)
                                ),
                                trailing: Checkbox(
                                  value: isSelected,
                                  activeColor: mainOrange,
                                  shape: const CircleBorder(),
                                  onChanged: (val) {
                                    setStateModal(() {
                                      if (val == true) {
                                        tempTagged.add(friendName);
                                      } else {
                                        tempTagged.remove(friendName);
                                      }
                                    });
                                  },
                                ),
                                onTap: () {
                                  setStateModal(() {
                                    if (isSelected) {
                                      tempTagged.remove(friendName);
                                    } else {
                                      tempTagged.add(friendName);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
