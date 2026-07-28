import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/preset_avatar_config.dart';
import 'preset_avatar_icon.dart';

/// A user's avatar: a real profile photo (decoded from the base64 string
/// stored on their `AppUser`/denormalized onto reviews & comments) takes
/// priority if set; otherwise a preset animal+color avatar if they picked
/// one; otherwise a plain person icon. Also falls back to the person icon
/// if the stored photo string fails to decode, since it's
/// externally-sourced Firestore data.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.base64Photo,
    this.presetAnimal,
    this.presetColorValue,
    this.radius = AppDimens.avatarRadiusM,
  });

  final String? base64Photo;
  final PresetAnimal? presetAnimal;
  final int? presetColorValue;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final photo = base64Photo;
    if (photo != null && photo.isNotEmpty) {
      try {
        return CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(base64Decode(photo)),
        );
      } catch (_) {
        // Falls through to the preset/fallback branches below.
      }
    }

    final animal = presetAnimal;
    if (animal != null && presetColorValue != null) {
      final color = Color(presetColorValue!);
      return CircleAvatar(
        radius: radius,
        backgroundColor: color,
        child: PresetAvatarIcon(
          animal: animal,
          color: AppColors.onColorSurface,
          size: radius * 1.15,
        ),
      );
    }

    return CircleAvatar(radius: radius, child: const Icon(Icons.person));
  }
}
