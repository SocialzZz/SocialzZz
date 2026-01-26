import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/search_item.dart';
import 'package:flutter_social_media_app/representation/profile/profile_screen.dart';
import 'avatar_widget.dart';
import 'follow_button.dart';

class AccountList extends StatelessWidget {
  final List<AccountItem> accounts;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color dividerColor;
  final Function(AccountItem) onToggleFollow;

  const AccountList({
    super.key,
    required this.accounts,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.dividerColor,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: accounts.length,
      separatorBuilder: (context, index) =>
          Divider(color: dividerColor, height: 12, thickness: 0.5),
      itemBuilder: (context, index) {
        final account = accounts[index];

        return InkWell(
          // Nhấn vào vùng trống của row thì mở Profile
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userId: account.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              children: [
                AvatarWidget(accent: accentColor, imageUrl: account.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      if (account.category != null)
                        Text(
                          account.category!,
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // ✅ Nút bấm với đầy đủ logic trạng thái
                FollowButton(
                  isFollowing: account.isFollowing,
                  requestSent: account.requestSent, // Trạng thái "Pending"
                  isFriend: account.isFriend, // Trạng thái "Unfriend"
                  accent: accentColor,

                  // Khi chưa gửi yêu cầu
                  onTap: () => onToggleFollow(account),

                  // Khi đang ở trạng thái Pending (Hủy yêu cầu)
                  onCancel: () => onToggleFollow(account),

                  // Khi đã là bạn bè (Hủy kết bạn)
                  onUnfriend: () => onToggleFollow(account),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
