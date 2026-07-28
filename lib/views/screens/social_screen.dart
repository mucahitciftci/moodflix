import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/social_viewmodel.dart';
import '../widgets/app_bar_home_leading.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/user_list_tile.dart';

/// Find and follow other users. Two tabs: search, and who the signed-in
/// user already follows. Requires being signed in — there's nothing to
/// follow with as a guest, same gating as writing a review.
class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final myUid = ref.watch(authStateProvider).valueOrNull?.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: AppDimens.appBarLeadingWidthWide,
          leading: const AppBarHomeLeading(),
          title: Text(l10n.socialScreenTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.searchTabLabel),
              Tab(text: l10n.followingTabLabel),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SearchTab(controller: _searchController),
            myUid == null
                ? Center(child: Text(l10n.notLoggedInMessage))
                : _FollowingTab(myUid: myUid),
          ],
        ),
      ),
    );
  }
}

class _SearchTab extends ConsumerWidget {
  const _SearchTab({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final resultsAsync = ref.watch(userSearchViewModelProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimens.spaceM),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.searchUsersHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (query) =>
                ref.read(userSearchViewModelProvider.notifier).search(query),
          ),
        ),
        Expanded(
          child: resultsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(l10n.errorGeneric)),
            data: (users) {
              if (controller.text.trim().isEmpty) return const SizedBox.shrink();
              if (users.isEmpty) {
                return EmptyStateView(message: l10n.noUsersFound);
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceM),
                itemCount: users.length,
                itemBuilder: (context, index) => UserListTile(user: users[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FollowingTab extends ConsumerWidget {
  const _FollowingTab({required this.myUid});

  final String myUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final followingAsync = ref.watch(followingProvider(myUid));

    return followingAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(l10n.errorGeneric)),
      data: (users) {
        if (users.isEmpty) {
          return EmptyStateView(message: l10n.noFollowingYet);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppDimens.spaceM),
          itemCount: users.length,
          itemBuilder: (context, index) => UserListTile(user: users[index]),
        );
      },
    );
  }
}
