import 'package:flutter/material.dart';

class PostItem {
  final String id;
  final String thumbnailUrl;
  final String type; // 'image' hoặc 'video'

  PostItem({required this.id, required this.thumbnailUrl, required this.type});
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Constants
  static const Color mainOrange = Color(0xFFF9622E);
  static const Color borderColor = Color(0xFFE2E5E9);

  final TextEditingController _contentController = TextEditingController();

  // STATE MANAGEMENT
  String _selectedPrivacy = 'Public';
  bool _isUploading = false;

  // Danh sách ảnh đã chọn (Lưu URL)
  List<String> _selectedImages = [];

  // Danh sách bạn bè được tag
  List<String> _taggedFriends = [];

  // Cảm xúc & Địa điểm
  String? _selectedFeeling;
  String? _selectedLocation;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // --- LOGIC HANDLERS ---

  Future<void> _handlePostToFirebase() async {
    if (_contentController.text.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung hoặc chọn ảnh!')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isUploading = true);

    // Giả lập gửi dữ liệu
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã đăng bài thành công!')));
    }
  }

  void _onHashtagTap(String tag) {
    setState(() {
      String currentText = _contentController.text;
      if (currentText.isNotEmpty && !currentText.endsWith(' ')) {
        _contentController.text = "$currentText $tag ";
      } else {
        _contentController.text = "$currentText$tag ";
      }
      _contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _contentController.text.length),
      );
    });
  }

  // --- SELECTION SHEETS (MODALS) ---

  //  Chọn Quyền riêng tư
  void _showPrivacySelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Ai có thể xem bài viết này?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.public, color: Colors.blue),
                title: const Text("Công khai (Public)"),
                subtitle: const Text("Bất kỳ ai trên hoặc ngoài ứng dụng"),
                trailing: _selectedPrivacy == 'Public'
                    ? const Icon(Icons.check, color: mainOrange)
                    : null,
                onTap: () {
                  setState(() => _selectedPrivacy = 'Public');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.red),
                title: const Text("Chỉ mình tôi (Private)"),
                subtitle: const Text("Chỉ bạn mới có thể xem bài viết này"),
                trailing: _selectedPrivacy == 'Private'
                    ? const Icon(Icons.check, color: mainOrange)
                    : null,
                onTap: () {
                  setState(() => _selectedPrivacy = 'Private');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //  Chọn Ảnh/GIF
  void _showImagePicker({bool isGif = false}) {
    final List<String> mockImages = List.generate(
      30,
      (index) =>
          'https://placehold.co/300x${isGif ? 200 : 300}/png?text=${isGif ? "GIF" : "IMG"}+$index',
    );

    List<String> tempSelectedImages = List.from(_selectedImages);
    List<String> filteredImages = List.from(mockImages);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
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
                      // Header Modal
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isGif ? "Chọn GIF" : "Thư viện ảnh",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImages = tempSelectedImages;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Xong",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: mainOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Thanh tìm kiếm chỉ hiện cho GIF
                      if (isGif)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Tìm kiếm GIF...",
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          searchController.clear();
                                          setStateModal(
                                            () => filteredImages = mockImages,
                                          );
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (val) {
                                setStateModal(() {
                                  if (val.isEmpty) {
                                    filteredImages = mockImages;
                                  } else {
                                    filteredImages = mockImages
                                        .take(10)
                                        .toList();
                                  }
                                });
                              },
                            ),
                          ),
                        ),

                      const Divider(height: 1),

                      // Grid Ảnh
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(4),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemCount: filteredImages.length,
                          itemBuilder: (ctx, index) {
                            final imgUrl = filteredImages[index];
                            final isSelected = tempSelectedImages.contains(
                              imgUrl,
                            );
                            final selectionIndex =
                                tempSelectedImages.indexOf(imgUrl) + 1;

                            return GestureDetector(
                              onTap: () {
                                setStateModal(() {
                                  if (isSelected) {
                                    tempSelectedImages.remove(imgUrl);
                                  } else {
                                    tempSelectedImages.add(imgUrl);
                                  }
                                });
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  AnimatedScale(
                                    scale: isSelected ? 0.9 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imgUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: mainOrange,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          "$selectionIndex",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
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

  //  Chọn Bạn bè
  void _showFriendSelector() {
    final List<Map<String, String>> allFriends = List.generate(
      20,
      (index) => {
        "name": "Bạn bè ${index + 1}",
        "info": "Bạn chung: 1${index}",
      },
    );
    List<Map<String, String>> filteredFriends = List.from(allFriends);
    List<String> tempTagged = List.from(_taggedFriends);
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
                            // Thanh tìm kiếm
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
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setStateModal(() {
                                      filteredFriends = allFriends
                                          .where(
                                            (f) => f['name']!
                                                .toLowerCase()
                                                .contains(val.toLowerCase()),
                                          )
                                          .toList();
                                    });
                                  },
                                ),
                              ),
                            ),

                            // Nút Xong
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                setState(() => _taggedFriends = tempTagged);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Xong",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: mainOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Danh sách bạn bè đã chọn
                      if (tempTagged.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFF2F2F2)),
                            ),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tempTagged
                                .map(
                                  (friend) => Chip(
                                    label: Text(friend),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () {
                                      setStateModal(() {
                                        tempTagged.remove(friend);
                                      });
                                    },
                                    backgroundColor: Colors.blue[50],
                                    side: BorderSide.none,
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                      // List Friend Items
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
                                  bottom: BorderSide(
                                    color: Color(0xFFF2F2F2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                title: Text(
                                  friendName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  friendInfo,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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

  //  Chọn Cảm xúc
  void _showFeelingSelector() {
    final List<String> allFeelings = [
      "Hạnh phúc 😄",
      "Buồn 😔",
      "Hào hứng 🤩",
      "Mệt mỏi 😫",
      "Biết ơn 🙏",
      "Yêu đời 🥰",
      "Giận dữ 😡",
    ];
    List<String> filteredFeelings = List.from(allFeelings);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, controller) {
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: "Tìm kiếm cảm xúc...",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              onChanged: (val) {
                                setStateModal(() {
                                  filteredFeelings = allFeelings
                                      .where(
                                        (f) => f.toLowerCase().contains(
                                          val.toLowerCase(),
                                        ),
                                      )
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
                        controller: controller,
                        itemCount: filteredFeelings.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFF2F2F2)),
                              ),
                            ),
                            child: ListTile(
                              title: Text(filteredFeelings[index]),
                              onTap: () {
                                setState(
                                  () => _selectedFeeling =
                                      filteredFeelings[index],
                                );
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // Helper
  String indexToChar(String val) => "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      body: Stack(
        children: [
          //  Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1D1B20),
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    const Text(
                      'Create Post',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: _isUploading ? null : _handlePostToFirebase,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                      ),
                      child: _isUploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: mainOrange,
                              ),
                            )
                          : const Text(
                              'POST',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: mainOrange,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //  Nội dung chính
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserInfo(),
                          const SizedBox(height: 20),
                          _buildInputArea(),
                          const SizedBox(height: 16),

                          if (_taggedFriends.isNotEmpty) ...[
                            _buildTaggedFriendsList(),
                            const SizedBox(height: 16),
                          ],

                          _buildHashtagsSection(),
                          const SizedBox(height: 16),

                          // Hiển thị ảnh (Đã sửa lỗi layout)
                          if (_selectedImages.isNotEmpty) _buildImageGrid(),
                        ],
                      ),
                    ),
                  ),

                  _buildBottomActionArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTS ---

  Widget _buildUserInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
          backgroundColor: Color(0xFFEADDFF),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  if (_selectedFeeling != null) ...[
                    const Text(
                      " đang cảm thấy ",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      _selectedFeeling!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFeeling = null),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  if (_selectedLocation != null) ...[
                    const Text(
                      " tại ",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      _selectedLocation!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _showPrivacySelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _selectedPrivacy == 'Public'
                            ? Icons.public
                            : Icons.lock,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedPrivacy == 'Public' ? 'Công khai' : 'Riêng tư',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return TextField(
      controller: _contentController,
      maxLines: null,
      minLines: 6,
      style: const TextStyle(fontSize: 18, color: Colors.black87),
      decoration: const InputDecoration(
        hintText: 'Bạn đang nghĩ gì thế?',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildTaggedFriendsList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, size: 16, color: mainOrange),
              const SizedBox(width: 6),
              Text(
                "Cùng với ${_taggedFriends.length} người khác:",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _taggedFriends.map((friend) {
              return Chip(
                label: Text(friend, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => setState(() => _taggedFriends.remove(friend)),
                backgroundColor: Colors.grey[100],
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- FIX GRID LOGIC (4+ ẢNH) ---
  Widget _buildImageGrid() {
    int count = _selectedImages.length;

    // 1 Ảnh
    if (count == 1) {
      return _buildImageItem(0, height: 250, width: double.infinity);
    }

    // 2 Ảnh
    if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildImageItem(0, height: 200)),
          const SizedBox(width: 4),
          Expanded(child: _buildImageItem(1, height: 200)),
        ],
      );
    }

    // 3 Ảnh
    if (count == 3) {
      return Column(
        children: [
          _buildImageItem(0, height: 200, width: double.infinity),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _buildImageItem(1, height: 150)),
              const SizedBox(width: 4),
              Expanded(child: _buildImageItem(2, height: 150)),
            ],
          ),
        ],
      );
    }

    // 4 Ảnh trở lên
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildImageItem(0, height: 180)),
            const SizedBox(width: 4),
            Expanded(child: _buildImageItem(1, height: 180)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildImageItem(2, height: 180)),
            const SizedBox(width: 4),
            Expanded(
              // Ô thứ 4: Hiển thị ảnh 4 + Overlay (nếu có) + Nút xóa
              child: SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    // Ảnh nền (dùng Positioned.fill để ép full size)
                    Positioned.fill(
                      child: _buildImageItem(
                        3,
                        height: null,
                        width: null,
                        showRemove: false,
                        isOverlay: true,
                      ),
                    ),

                    // Overlay đếm số
                    if (count > 4)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: Text(
                            "+${count - 4}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Nút xóa (Xóa ảnh thứ 4)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedImages.removeAt(3)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget hiển thị 1 ảnh đơn lẻ
  Widget _buildImageItem(
    int index, {
    double? height,
    double? width,
    bool showRemove = true,
    bool isOverlay = false,
  }) {
    if (index >= _selectedImages.length) return const SizedBox();

    // Nếu đang được dùng làm nền cho overlay (isOverlay = true),
    // ta trả về ảnh gốc (không bọc trong SizedBox hay Stack nữa để tránh lồng nhau)
    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        _selectedImages[index],
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) =>
            Container(color: Colors.grey[300], child: const Icon(Icons.error)),
      ),
    );

    if (isOverlay) return imageWidget;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          if (showRemove)
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () => setState(() => _selectedImages.removeAt(index)),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHashtagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Hashtags",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            "#Flutter",
            "#Coding",
            "#MobileApp",
            "#LifeStyle",
          ].map((tag) => _buildHashtagChip(tag)).toList(),
        ),
      ],
    );
  }

  Widget _buildHashtagChip(String text) {
    return InkWell(
      onTap: () => _onHashtagTap(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF7E7D9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withAlpha(36)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: mainOrange,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Thêm vào bài viết",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionIcon(
                Icons.image,
                const Color(0xFF45BD62),
                onTap: () => _showImagePicker(isGif: false),
              ),
              _buildActionIcon(
                Icons.person_add_alt_1,
                const Color(0xFF1877F2),
                onTap: _showFriendSelector,
              ),
              _buildActionIcon(
                Icons.sentiment_satisfied_alt,
                const Color(0xFFF7B928),
                onTap: _showFeelingSelector,
              ),
              _buildActionIcon(
                Icons.location_on,
                const Color(0xFFF02849),
                onTap: () {
                  _showSimpleSelector("Check-in", [
                    "Hồ Chí Minh",
                    "Hà Nội",
                    "Đà Nẵng",
                    "Cần Thơ",
                  ], (val) => setState(() => _selectedLocation = val));
                },
              ),
              _buildActionIcon(
                Icons.gif_box,
                const Color(0xFFAB47BC),
                onTap: () => _showImagePicker(isGif: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSimpleSelector(
    String title,
    List<String> items,
    Function(String) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      onSelected(items[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionIcon(
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
