import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/routing/app_router.dart';
import '../../models/app_user.dart';

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
        leading: const CircleAvatar(child: Icon(Icons.person)),
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
