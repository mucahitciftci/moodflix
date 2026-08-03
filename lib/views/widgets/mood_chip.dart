import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/localization/mood_localizer.dart';
import '../../models/mood_model.dart';

/// A single selectable mood card: icon + localized title on the mood's own
/// accent color. Used by `MoodSelectionScreen`'s grid.
class MoodChip extends StatelessWidget {
  const MoodChip({super.key, required this.mood, required this.onTap});

  final MoodModel mood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        boxShadow: [
          BoxShadow(
            color: mood.color.withValues(alpha: 0.45),
            blurRadius: AppDimens.spaceL,
            offset: const Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Material(
        color: mood.color,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  mood.icon,
                  size: AppDimens.iconXl,
                  color: AppColors.onColorSurface,
                ),
                const SizedBox(height: AppDimens.spaceS),
                Text(
                  l10n.moodTitle(mood.titleKey),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: AppColors.onColorSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
