import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/routing/app_router.dart';
import '../../models/app_user.dart';
import 'user_avatar.dart';

/// A single row for a user in search results / following / followers
/// lists. Navigates to `UserProfileScreen` on tap.
class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceS),
      child: ListTile(
        leading: UserAvatar(
          base64Photo: user.photoBase64,
          presetAnimal: user.presetAvatarAnimal,
          presetColorValue: user.presetAvatarColorValue,
        ),
        title: Text(user.displayName),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).pushNamed(
          AppRoutes.userProfile,
          arguments: user,
        ),
      ),
    );
  }
}
