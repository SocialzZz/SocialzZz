# SocialzZz - Flutter Mobile App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Socket.io](https://img.shields.io/badge/Socket.io-010101?style=for-the-badge&logo=socket.io&logoColor=white)

**Ứng dụng mạng xã hội hiện đại được xây dựng với Flutter**

</div>

## 📱 Tổng quan

SocialzZz là ứng dụng mạng xã hội cross-platform được phát triển bằng Flutter, hỗ trợ iOS, Android và Web. Ứng dụng cung cấp trải nghiệm người dùng mượt mà với các tính năng đầy đủ như đăng bài, nhắn tin real-time, kết bạn và nhiều hơn nữa.

## 🎯 Tính năng chính

### 🔐 Xác thực & Bảo mật

- ✅ Đăng ký/Đăng nhập với email & password
- ✅ Đăng nhập với Google OAuth
- ✅ JWT token authentication
- ✅ Refresh token tự động
- ✅ Persistent login session

### 📝 Quản lý bài viết

- ✅ Tạo bài viết với text, ảnh, video
- ✅ Thêm cảm xúc (feelings) vào bài viết
- ✅ Thêm vị trí (location)
- ✅ Thêm GIF từ thư viện
- ✅ Tag bạn bè trong bài viết
- ✅ Hashtags
- ✅ Cài đặt quyền riêng tư (Public/Friends/Private)
- ✅ Chỉnh sửa và xóa bài viết

### 💬 Tương tác xã hội

- ✅ 6 loại reactions (Like, Love, Haha, Wow, Sad, Angry)
- ✅ Bình luận bài viết
- ✅ Xem danh sách reactions
- ✅ Real-time updates

### 👥 Kết bạn & Theo dõi

- ✅ Gửi/Nhận lời mời kết bạn
- ✅ Chấp nhận/Từ chối lời mời
- ✅ Danh sách bạn bè
- ✅ Danh sách người theo dõi/đang theo dõi
- ✅ Gợi ý kết bạn
- ✅ Kiểm tra trạng thái kết bạn

### 💬 Nhắn tin Real-time

- ✅ Chat 1-1 với WebSocket
- ✅ Gửi/nhận tin nhắn real-time
- ✅ Danh sách cuộc hội thoại
- ✅ Đánh dấu đã đọc
- ✅ Chọn người dùng để chat
- ✅ Hiển thị trạng thái online

### 🔔 Thông báo

- ✅ Thông báo kết bạn
- ✅ Thông báo tương tác (like, comment)
- ✅ Thông báo tin nhắn mới
- ✅ Badge đếm thông báo chưa đọc
- ✅ Real-time notifications

### 🔍 Tìm kiếm & Khám phá

- ✅ Tìm kiếm người dùng
- ✅ Tìm kiếm bài viết
- ✅ Tìm kiếm theo hashtag
- ✅ Tìm kiếm địa điểm
- ✅ Tab navigation (Accounts, Hashtags, Places, Reels)

### 👤 Hồ sơ cá nhân

- ✅ Xem và chỉnh sửa profile
- ✅ Thay đổi avatar
- ✅ Xem bài viết của bản thân
- ✅ Thống kê (số bạn bè, bài viết)
- ✅ Cài đặt tài khoản

## 🏗️ Kiến trúc ứng dụng

```
lib/
├── data/                          # Data layer
│   ├── models/                    # Data models
│   │   ├── message.dart          # Message & Conversation models
│   │   ├── user_model.dart       # User model
│   │   ├── comment_data.dart     # Comment model
│   │   ├── follow_item.dart      # Follow/Follower model
│   │   └── step_model.dart       # Onboarding step model
│   │
│   └── services/                  # API services
│       ├── message_service.dart  # Message API & WebSocket
│       ├── user_service.dart     # User API
│       ├── follow_service.dart   # Follow/Friend API
│       └── token_manager.dart    # Token management
│
├── representation/                # Presentation layer (UI)
│   ├── auth/                     # Authentication screens
│   │   ├── auth_service.dart    # Auth API service
│   │   ├── login_screen.dart    # Login UI
│   │   └── register_screen.dart # Register UI
│   │
│   ├── home/                     # Home feed
│   │   ├── home_screen.dart     # Feed UI
│   │   ├── main_screen.dart     # Main container with bottom nav
│   │   ├── home_header.dart     # Header widget
│   │   ├── live_card_widget.dart
│   │   └── status_card_widget.dart
│   │
│   ├── post/                     # Post management
│   │   ├── screens/
│   │   │   ├── create_post_screen.dart
│   │   │   └── reaction_list_screen.dart
│   │   ├── controllers/
│   │   │   ├── create_post_controller.dart
│   │   │   └── reaction_controller.dart
│   │   ├── widgets/
│   │   │   ├── post_header.dart
│   │   │   ├── post_action_bar.dart
│   │   │   ├── post_image_grid.dart
│   │   │   ├── post_input.dart
│   │   │   ├── reaction_counter.dart
│   │   │   └── reaction_item.dart
│   │   └── sheets/
│   │       ├── feeling_sheet.dart
│   │       ├── image_picker_sheet.dart
│   │       ├── privacy_sheet.dart
│   │       └── tag_friend_sheet.dart
│   │
│   ├── message/                  # Messaging
│   │   ├── message_list_screen.dart    # Conversations list
│   │   ├── chat_detail_screen.dart     # Chat UI
│   │   ├── select_user_screen.dart     # User selection
│   │   ├── message_header.dart
│   │   └── message_item.dart
│   │
│   ├── profile/                  # User profile
│   │   └── profile_screen.dart
│   │
│   ├── search/                   # Search & discovery
│   │   ├── search_screen.dart
│   │   ├── search_header.dart
│   │   ├── search_tabs.dart
│   │   ├── account_list.dart
│   │   ├── hashtag_list.dart
│   │   ├── place_list.dart
│   │   ├── reel_list.dart
│   │   ├── avatar_widget.dart
│   │   └── follow_button.dart
│   │
│   ├── notification/             # Notifications
│   │   ├── notification_screen.dart
│   │   ├── notification_header.dart
│   │   ├── notification_list_widget.dart
│   │   ├── notification_item_widget.dart
│   │   ├── request_buttons.dart
│   │   ├── avatar_placeholder.dart
│   │   └── post_preview_placeholder.dart
│   │
│   ├── follow/                   # Friends & followers
│   │   ├── followers_screen.dart
│   │   └── following_screen.dart
│   │
│   ├── comment/                  # Comments
│   │   ├── comment_screen.dart
│   │   └── comment_item.dart
│   │
│   ├── setting/                  # Settings
│   │   └── setting_screen.dart
│   │
│   ├── step/                     # Onboarding
│   │   ├── step_screen.dart
│   │   └── step_item.dart
│   │
│   ├── splash/                   # Splash screen
│   │   └── splash_screen.dart
│   │
│   ├── welcome/                  # Welcome screen
│   │   └── welcome.dart
│   │
│   └── video/                    # Video player
│       └── video_screen.dart
│
├── routes/                        # Navigation
│   ├── app_router.dart           # Route definitions
│   └── route_names.dart          # Route constants
│
├── widgets/                       # Reusable widgets
│   ├── app_bottom_navbar.dart    # Bottom navigation bar
│   ├── circle_icon_btn.dart      # Circular icon button
│   ├── video_player_item.dart    # Video player widget
│   └── show_snackbar.dart        # Snackbar helper
│
├── app.dart                       # App widget
└── main.dart                      # Entry point
```

## 🛠️ Tech Stack

### Core

- **Flutter SDK**: ^3.24.5
- **Dart**: ^3.5.4

### State Management & Navigation

- **go_router**: ^14.6.2 - Declarative routing

### Networking

- **http**: ^1.2.2 - REST API calls
- **dio**: ^5.7.0 - Advanced HTTP client
- **socket_io_client**: ^2.0.3+1 - WebSocket real-time communication

### Authentication

- **google_sign_in**: ^6.3.0 - Google OAuth
- **supabase_flutter**: ^2.9.1 - Backend services

### Storage

- **shared_preferences**: ^2.3.3 - Local storage
- **flutter_dotenv**: ^5.2.1 - Environment variables

### Media

- **image_picker**: ^1.1.2 - Pick images/videos
- **video_player**: ^2.9.2 - Video playback
- **flutter_svg**: ^2.0.16 - SVG support

### UI Components

- **flutter_staggered_grid_view**: ^0.7.0 - Grid layouts
- **shimmer**: ^3.0.0 - Loading animations
- **cached_network_image**: ^3.4.1 - Image caching

### Utilities

- **intl**: ^0.20.1 - Internationalization
- **url_launcher**: ^6.3.1 - Launch URLs

## 📦 Cài đặt

### Yêu cầu hệ thống

- Flutter SDK >= 3.24.5
- Dart SDK >= 3.5.4
- Android Studio / VS Code
- Xcode (cho iOS development)
- Git

### Bước 1: Clone repository

```bash
git clone https://github.com/SocialzZz/SocialzZz.git
cd SocialzZz/socialzzz
```

### Bước 2: Cài đặt dependencies

```bash
flutter pub get
```

### Bước 3: Cấu hình môi trường

Tạo file `.env` trong thư mục root:

```env
# Supabase Config
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Google Auth Config
GOOGLE_WEB_CLIENT_ID=your_google_web_client_id
GOOGLE_IOS_CLIENT_ID=your_google_ios_client_id
GOOGLE_ANDROID_CLIENT_ID=your_google_android_client_id

# API URL Configuration
# Cho Web và iOS Simulator
API_URL=http://localhost:3000

# Cho Android Emulator
# API_URL=http://10.0.2.2:3000

# Cho thiết bị thật (cùng mạng WiFi)
# API_URL=http://YOUR_COMPUTER_IP:3000

# Cho test từ xa với ngrok
# API_URL=https://your-ngrok-url.ngrok-free.dev
```

### Bước 4: Chạy ứng dụng

**Web:**

```bash
flutter run -d chrome
```

**Android Emulator:**

```bash
flutter run -d android
```

**iOS Simulator:**

```bash
flutter run -d ios
```

**Thiết bị thật:**

```bash
# Kiểm tra devices
flutter devices

# Chạy trên device cụ thể
flutter run -d <device-id>
```

## 🚀 Build Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle (cho Google Play)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🔧 Cấu hình theo môi trường

### Development (Local)

```env
API_URL=http://localhost:3000
```

### Android Emulator

```env
API_URL=http://10.0.2.2:3000
```

### iOS Simulator

```env
API_URL=http://localhost:3000
```

### Thiết bị thật (cùng mạng WiFi)

```env
# Thay YOUR_IP bằng IP máy tính của bạn
API_URL=http://192.168.1.100:3000
```

### Test từ xa với ngrok

```bash
# Chạy ngrok
ngrok http 3000

# Copy URL và cập nhật .env
API_URL=https://abc123.ngrok-free.dev
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test
```

## 📱 Hỗ trợ Platform

| Platform | Supported | Notes                     |
| -------- | --------- | ------------------------- |
| Android  | ✅        | Min SDK: 21 (Android 5.0) |
| iOS      | ✅        | Min iOS: 12.0             |
| Web      | ✅        | Chrome, Safari, Edge      |
| macOS    | ⚠️        | Experimental              |
| Windows  | ⚠️        | Experimental              |
| Linux    | ⚠️        | Experimental              |

## 🐛 Troubleshooting

### Lỗi kết nối API

**Vấn đề:** `ClientException: Failed to fetch`

**Giải pháp:**

1. Kiểm tra backend đang chạy: `http://localhost:3000`
2. Kiểm tra `.env` file có đúng API_URL
3. Restart Flutter app sau khi đổi `.env`
4. Kiểm tra CORS trong backend

### Lỗi WebSocket

**Vấn đề:** Socket không kết nối

**Giải pháp:**

1. Kiểm tra userId đã được lưu trong TokenManager
2. Kiểm tra backend Messages Gateway đang chạy
3. Kiểm tra console log: "Connected to socket"

### Lỗi Google Sign In

**Vấn đề:** Google login không hoạt động

**Giải pháp:**

1. Kiểm tra Google OAuth credentials
2. Cấu hình SHA-1 fingerprint (Android)
3. Cấu hình URL schemes (iOS)

## 📝 Environment Variables

| Variable                   | Description                    | Required        |
| -------------------------- | ------------------------------ | --------------- |
| `API_URL`                  | Backend API URL                | ✅              |
| `SUPABASE_URL`             | Supabase project URL           | ✅              |
| `SUPABASE_ANON_KEY`        | Supabase anonymous key         | ✅              |
| `GOOGLE_WEB_CLIENT_ID`     | Google OAuth Web Client ID     | ✅              |
| `GOOGLE_IOS_CLIENT_ID`     | Google OAuth iOS Client ID     | ⚠️ iOS only     |
| `GOOGLE_ANDROID_CLIENT_ID` | Google OAuth Android Client ID | ⚠️ Android only |

## 🤝 Đóng góp

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 License

Dự án này được phân phối dưới giấy phép MIT.

## 👥 Team

- **Mobile Developer**: [Your Name]
- **UI/UX Designer**: [Your Name]

## 📞 Liên hệ

- GitHub: [https://github.com/SocialzZz/SocialzZz](https://github.com/SocialzZz/SocialzZz)
- Email: doanbao690@gmail.com

---

<div align="center">
Made with ❤️ using Flutter
</div>
