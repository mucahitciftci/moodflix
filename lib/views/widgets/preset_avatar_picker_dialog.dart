import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/preset_avatar_config.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import 'preset_avatar_icon.dart';

/// Animal + color picker for a preset avatar. Returns the chosen
/// `(PresetAnimal, Color)` pair via `Navigator.pop`, or `null` if cancelled.
class PresetAvatarPickerDialog extends StatefulWidget {
  const PresetAvatarPickerDialog({
    super.key,
    this.initialAnimal,
    this.initialColor,
  });

  final PresetAnimal? initialAnimal;
  final Color? initialColor;

  @override
  State<PresetAvatarPickerDialog> createState() => _PresetAvatarPickerDialogState();
}

class _PresetAvatarPickerDialogState extends State<PresetAvatarPickerDialog> {
  late PresetAnimal _animal = widget.initialAnimal ?? PresetAvatarConfig.animals.first;
  late Color _color = widget.initialColor ?? AppColors.avatarPalette.first;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.createPresetAvatarLabel),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: AppDimens.avatarRadiusL,
              backgroundColor: _color,
              child: PresetAvatarIcon(
                animal: _animal,
                color: AppColors.onColorSurface,
                size: AppDimens.avatarRadiusL * 1.15,
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.chooseAnimalLabel, style: AppTextStyles.bodyStrong),
            ),
            const SizedBox(height: AppDimens.spaceS),
            Wrap(
              spacing: AppDimens.spaceS,
              runSpacing: AppDimens.spaceS,
              children: [
                for (final animal in PresetAvatarConfig.animals)
                  _AnimalSwatch(
                    animal: animal,
                    selected: animal == _animal,
                    onTap: () => setState(() => _animal = animal),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceL),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.chooseColorLabel, style: AppTextStyles.bodyStrong),
            ),
            const SizedBox(height: AppDimens.spaceS),
            Wrap(
              spacing: AppDimens.spaceS,
              runSpacing: AppDimens.spaceS,
              children: [
                for (final color in AppColors.avatarPalette)
                  _ColorSwatch(
                    color: color,
                    selected: color == _color,
                    onTap: () => setState(() => _color = color),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop((_animal, _color)),
          child: Text(l10n.saveLabel),
        ),
      ],
    );
  }
}

class _AnimalSwatch extends StatelessWidget {
  const _AnimalSwatch({required this.animal, required this.selected, required this.onTap});

  final PresetAnimal animal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceS),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: selected ? Border.all(color: AppColors.primary, width: AppDimens.cardBorderWidth) : null,
        ),
        child: PresetAvatarIcon(
          animal: animal,
          color: Theme.of(context).colorScheme.onSurface,
          size: AppDimens.avatarRadiusM,
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      onTap: onTap,
      child: Container(
        width: AppDimens.avatarRadiusM * 2,
        height: AppDimens.avatarRadiusM * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selected
              ? Border.all(color: AppColors.onColorSurface, width: AppDimens.cardBorderWidth)
              : null,
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: AppColors.onColorSurface)
            : null,
      ),
    );
  }
}
