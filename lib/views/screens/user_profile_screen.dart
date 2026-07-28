import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../models/app_user.dart';
import '../../models/movie_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/list_sharing_viewmodel.dart';
import '../../viewmodels/review_viewmodel.dart';
import '../../viewmodels/social_viewmodel.dart';
import '../widgets/app_bar_home_leading.dart';
import '../widgets/movie_list_tile.dart';
import '../widgets/review_tile.dart';
import '../widgets/user_avatar.dart';

/// A user's public profile: their name, a follow/unfollow button (hidden
/// when viewing your own profile), every review they've written, and —
/// only if they've turned list sharing on and the viewer is allowed to see
/// it (public, or followers-only + actually following them) — their
/// shared watchlist/favorites.
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final myUid = ref.watch(authStateProvider).valueOrNull?.uid;
    final isOwnProfile = myUid == user.uid;
    final reviewsAsync = ref.watch(userReviewsProvider(user.uid));

    // Always prefer the live profile over the possibly-stale [user] that
    // was passed in via navigation (e.g. from a search result fetched a
    // while ago) — `listSharing` needs to be current.
    final liveProfile = ref.watch(userProfileProvider(user.uid)).valueOrNull;
    final displayName = liveProfile?.displayName ?? user.displayName;
    final listSharing = liveProfile?.listSharing ?? user.listSharing;
    final photoBase64 = liveProfile?.photoBase64 ?? user.photoBase64;
    final presetAnimal = liveProfile?.presetAvatarAnimal ?? user.presetAvatarAnimal;
    final presetColorValue =
        liveProfile?.presetAvatarColorValue ?? user.presetAvatarColorValue;

    final isFollowing =
        ref.watch(isFollowingProvider(user.uid)).valueOrNull ?? false;
    final canSeeLists = !isOwnProfile &&
        (listSharing == ListSharingVisibility.public ||
            (listSharing == ListSharingVisibility.followers && isFollowing));

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppDimens.appBarLeadingWidthWide,
        leading: const AppBarHomeLeading(),
        title: Text(displayName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        children: [
          Row(
            children: [
              UserAvatar(
                base64Photo: photoBase64,
                presetAnimal: presetAnimal,
                presetColorValue: presetColorValue,
                radius: AppDimens.avatarRadiusL,
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: Text(displayName, style: AppTextStyles.headline),
              ),
              if (!isOwnProfile) _FollowButton(targetUid: user.uid),
            ],
          ),
          if (canSeeLists) ...[
            const SizedBox(height: AppDimens.spaceL),
            Text(l10n.theirWatchlistTitle, style: AppTextStyles.title),
            const SizedBox(height: AppDimens.spaceS),
            _SharedMovieList(
              moviesAsync: ref.watch(sharedWatchlistProvider(user.uid)),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(l10n.theirFavoritesTitle, style: AppTextStyles.title),
            const SizedBox(height: AppDimens.spaceS),
            _SharedMovieList(
              moviesAsync: ref.watch(sharedFavoritesProvider(user.uid)),
            ),
          ],
          const SizedBox(height: AppDimens.spaceL),
          Text(l10n.reviewsSectionTitle, style: AppTextStyles.title),
          const SizedBox(height: AppDimens.spaceS),
          reviewsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(l10n.errorGeneric),
            data: (reviews) {
              if (reviews.isEmpty) {
                return Text(l10n.userHasNoReviewsYet, style: AppTextStyles.body);
              }
              return Column(
                children: [for (final review in reviews) ReviewTile(review: review)],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SharedMovieList extends StatelessWidget {
  const _SharedMovieList({required this.moviesAsync});

  final AsyncValue<List<MovieModel>> moviesAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return moviesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(l10n.errorGeneric),
      data: (movies) {
        if (movies.isEmpty) {
          return Text(l10n.emptySharedListMessage, style: AppTextStyles.body);
        }
        return Column(
          children: [
            for (final movie in movies) MovieListTile(movie: movie),
          ],
        );
      },
    );
  }
}

class _FollowButton extends ConsumerWidget {
  const _FollowButton({required this.targetUid});

  final String targetUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isFollowingAsync = ref.watch(isFollowingProvider(targetUid));
    final actionState = ref.watch(followViewModelProvider);
    final isFollowing = isFollowingAsync.valueOrNull ?? false;

    return OutlinedButton(
      onPressed: actionState.isLoading
          ? null
          : () {
              final notifier = ref.read(followViewModelProvider.notifier);
              if (isFollowing) {
                notifier.unfollow(targetUid);
              } else {
                notifier.follow(targetUid);
              }
            },
      child: Text(isFollowing ? l10n.unfollowButtonLabel : l10n.followButtonLabel),
    );
  }
}
