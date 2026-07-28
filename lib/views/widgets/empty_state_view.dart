import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import 'chameleon_mascot.dart';

/// Shared "nothing here yet" state — the chameleon mascot plus a message.
/// Used across empty lists (discovery, search, watchlist, ...) so the app
/// has one consistent, branded empty state instead of bare text everywhere.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ChameleonMascot(size: AppDimens.iconXl * 2),
          const SizedBox(height: AppDimens.spaceM),
          Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
