import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/movie_model.dart';
import 'movie_card.dart';

/// A Tinder-style swipeable stack of [MovieCard]s. Swiping right calls
/// [onSwipeRight] (added to watchlist), swiping left calls [onSwipeLeft]
/// (skipped). [movies] is never mutated — the stack just tracks how many
/// items from the front it has already consumed, so it keeps working as the
/// caller appends more pages to [movies] mid-swipe.
///
/// Pass a `key` that changes with the selected mood (e.g. `ValueKey(moodId)`)
/// so switching moods rebuilds a fresh stack instead of reusing swipe state
/// from the previous mood.
class SwipeableCardStack extends StatefulWidget {
  const SwipeableCardStack({
    super.key,
    required this.movies,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    this.onUndoSwipe,
    this.onStackRunningLow,
  });

  final List<MovieModel> movies;
  final ValueChanged<MovieModel> onSwipeRight;
  final ValueChanged<MovieModel> onSwipeLeft;

  /// Called when the user undoes their last swipe (right or left) via the
  /// undo button. [wasSwipeRight] tells the caller which side effect to
  /// reverse — e.g. remove the movie from the watchlist if it had just been
  /// added by a right swipe. Only the single most recent swipe can be
  /// undone, not a full history.
  final void Function(MovieModel movie, bool wasSwipeRight)? onUndoSwipe;

  final VoidCallback? onStackRunningLow;

  @override
  State<SwipeableCardStack> createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<SwipeableCardStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<Offset>? _snapAnimation;

  int _consumedCount = 0;
  Offset _dragOffset = Offset.zero;

  MovieModel? _lastSwipedMovie;
  bool _lastSwipeWasRight = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.swipeAnimationDurationMs),
    )..addListener(() {
        final animation = _snapAnimation;
        if (animation != null) {
          setState(() => _dragOffset = animation.value);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<MovieModel> get _remaining =>
      widget.movies.skip(_consumedCount).toList();

  void _onPanUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating) return;
    setState(() => _dragOffset += details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    final passedThreshold = _dragOffset.dx.abs() > AppDimens.swipeThreshold;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final target = passedThreshold
        ? Offset(_dragOffset.dx.sign * screenWidth, _dragOffset.dy)
        : Offset.zero;

    _snapAnimation = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(from: 0).whenComplete(() {
      if (passedThreshold) {
        _consumeTopCard(isRight: target.dx > 0);
      }
      _snapAnimation = null;
      if (mounted) setState(() => _dragOffset = Offset.zero);
    });
  }

  void _consumeTopCard({required bool isRight}) {
    final remainingBeforeConsume = _remaining;
    if (remainingBeforeConsume.isEmpty) return;
    final movie = remainingBeforeConsume.first;

    setState(() {
      _consumedCount++;
      _lastSwipedMovie = movie;
      _lastSwipeWasRight = isRight;
    });

    if (isRight) {
      widget.onSwipeRight(movie);
    } else {
      widget.onSwipeLeft(movie);
    }

    if (_remaining.length <= AppDimens.stackVisibleCardCount) {
      widget.onStackRunningLow?.call();
    }
  }

  /// Brings back only the single most recent swipe — not a full history —
  /// per the product decision that one level of undo is enough to let the
  /// user re-swipe a card they flicked the wrong way.
  void _undoLastSwipe() {
    final movie = _lastSwipedMovie;
    if (movie == null) return;

    setState(() {
      _consumedCount--;
      _dragOffset = Offset.zero;
    });

    widget.onUndoSwipe?.call(movie, _lastSwipeWasRight);
    _lastSwipedMovie = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final remaining = _remaining;

    if (remaining.isEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Center(child: Text(l10n.emptyMovies)),
          if (_lastSwipedMovie != null) _buildUndoButton(),
        ],
      );
    }

    final visible = remaining.take(AppDimens.stackVisibleCardCount).toList();

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var depth = visible.length - 1; depth >= 1; depth--)
            _buildBackgroundCard(visible[depth], depth: depth),
          _buildTopCard(visible.first),
          if (_lastSwipedMovie != null) _buildUndoButton(),
        ],
      ),
    );
  }

  Widget _buildUndoButton() {
    final l10n = AppLocalizations.of(context);
    return Positioned(
      left: AppDimens.spaceS,
      bottom: AppDimens.spaceS,
      child: IconButton.filledTonal(
        icon: const Icon(Icons.undo_rounded),
        iconSize: AppDimens.iconXl,
        tooltip: l10n.undoSwipeTooltip,
        onPressed: _undoLastSwipe,
      ),
    );
  }

  Widget _buildBackgroundCard(MovieModel movie, {required int depth}) {
    final scale = 1 - (depth * AppDimens.stackCardScaleStep);
    return Transform.translate(
      offset: Offset(0, depth * AppDimens.stackCardOffsetStep),
      child: Transform.scale(
        scale: scale,
        child: FractionallySizedBox(
          widthFactor: AppDimens.cardWidthFraction,
          heightFactor: AppDimens.cardHeightFraction,
          child: MovieCard(movie: movie),
        ),
      ),
    );
  }

  Widget _buildTopCard(MovieModel movie) {
    final angle = _dragOffset.dx * AppDimens.swipeRotationFactor;

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: angle,
          child: FractionallySizedBox(
            widthFactor: AppDimens.cardWidthFraction,
            heightFactor: AppDimens.cardHeightFraction,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MovieCard(movie: movie),
                if (_dragOffset.dx > 0) _buildStamp(isLike: true),
                if (_dragOffset.dx < 0) _buildStamp(isLike: false),
                _buildInfoButton(movie),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton(MovieModel movie) {
    return Positioned(
      right: AppDimens.spaceS,
      bottom: AppDimens.spaceS,
      child: IconButton.filledTonal(
        icon: const Icon(Icons.info_outline),
        iconSize: AppDimens.iconXl,
        onPressed: () => Navigator.of(context).pushNamed(
          AppRoutes.movieDetail,
          arguments: movie,
        ),
      ),
    );
  }

  Widget _buildStamp({required bool isLike}) {
    final opacity =
        (_dragOffset.dx.abs() / AppDimens.swipeThreshold).clamp(0.0, 1.0);

    return Positioned(
      top: AppDimens.spaceL,
      left: isLike ? AppDimens.spaceL : null,
      right: isLike ? null : AppDimens.spaceL,
      child: Opacity(
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceM,
            vertical: AppDimens.spaceS,
          ),
          decoration: BoxDecoration(
            color: isLike ? AppColors.swipeLike : AppColors.swipeNope,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
          child: Icon(
            isLike ? Icons.bookmark_add_rounded : Icons.close_rounded,
            color: AppColors.onColorSurface,
            size: AppDimens.iconM,
          ),
        ),
      ),
    );
  }
}
