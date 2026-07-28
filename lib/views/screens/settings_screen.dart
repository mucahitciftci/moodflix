import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/preset_avatar_config.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/app_user.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/list_sharing_viewmodel.dart';
import '../widgets/preset_avatar_picker_dialog.dart';
import '../widgets/user_avatar.dart';

/// Account (login state, username/email/password changes), theme
/// (light/dark/system) and language (TR/EN) — the app's "Menü" screen,
/// reached from `BrowseModeScreen`'s account icon.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final myProfile = currentUser == null
        ? null
        : ref.watch(currentUserProfileProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        children: [
          Text(l10n.accountSectionTitle, style: AppTextStyles.title),
          const SizedBox(height: AppDimens.spaceS),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(currentUser?.email ?? l10n.notLoggedInMessage),
                  trailing: currentUser != null
                      ? TextButton(
                          onPressed: () => ref
                              .read(authViewModelProvider.notifier)
                              .signOut(),
                          child: Text(l10n.logoutLabel),
                        )
                      : TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.login),
                          child: Text(l10n.loginScreenTitle),
                        ),
                ),
                if (currentUser != null) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: UserAvatar(
                      base64Photo: myProfile?.photoBase64,
                      presetAnimal: myProfile?.presetAvatarAnimal,
                      presetColorValue: myProfile?.presetAvatarColorValue,
                      radius: AppDimens.avatarRadiusS,
                    ),
                    title: Text(l10n.changePhotoLabel),
                    onTap: () => _showPhotoOptions(
                      context,
                      ref,
                      hasPhoto: myProfile?.photoBase64 != null,
                      initialAnimal: myProfile?.presetAvatarAnimal,
                      initialColorValue: myProfile?.presetAvatarColorValue,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: Text(l10n.changeUsernameLabel),
                    onTap: () => _showChangeUsernameDialog(
                      context,
                      ref,
                      currentUser.displayName,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(l10n.changeEmailLabel),
                    onTap: () => _showChangeEmailDialog(context, ref),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text(l10n.changePasswordLabel),
                    onTap: () => _showChangePasswordDialog(context, ref),
                  ),
                ],
              ],
            ),
          ),
          if (currentUser != null) ...[
            const SizedBox(height: AppDimens.spaceL),
            Text(l10n.privacySectionTitle, style: AppTextStyles.title),
            const SizedBox(height: AppDimens.spaceS),
            _OptionTile(
              label: l10n.listSharingOff,
              selected: (myProfile?.listSharing ?? ListSharingVisibility.off) ==
                  ListSharingVisibility.off,
              onTap: () => ref
                  .read(listSharingViewModelProvider.notifier)
                  .setVisibility(ListSharingVisibility.off),
            ),
            _OptionTile(
              label: l10n.listSharingPublic,
              selected: myProfile?.listSharing == ListSharingVisibility.public,
              onTap: () => ref
                  .read(listSharingViewModelProvider.notifier)
                  .setVisibility(ListSharingVisibility.public),
            ),
            _OptionTile(
              label: l10n.listSharingFollowers,
              selected: myProfile?.listSharing == ListSharingVisibility.followers,
              onTap: () => ref
                  .read(listSharingViewModelProvider.notifier)
                  .setVisibility(ListSharingVisibility.followers),
            ),
          ],
          const SizedBox(height: AppDimens.spaceL),
          Text(l10n.themeSectionTitle, style: AppTextStyles.title),
          const SizedBox(height: AppDimens.spaceS),
          _OptionTile(
            label: l10n.themeSystem,
            selected: themeMode == ThemeMode.system,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.system),
          ),
          _OptionTile(
            label: l10n.themeLight,
            selected: themeMode == ThemeMode.light,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.light),
          ),
          _OptionTile(
            label: l10n.themeDark,
            selected: themeMode == ThemeMode.dark,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.dark),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Text(l10n.languageSectionTitle, style: AppTextStyles.title),
          const SizedBox(height: AppDimens.spaceS),
          _OptionTile(
            label: l10n.languageTr,
            selected: locale.languageCode == 'tr',
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('tr')),
          ),
          _OptionTile(
            label: l10n.languageEn,
            selected: locale.languageCode == 'en',
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }
}

Future<void> _showPhotoOptions(
  BuildContext context,
  WidgetRef ref, {
  required bool hasPhoto,
  PresetAnimal? initialAnimal,
  int? initialColorValue,
}) async {
  final l10n = AppLocalizations.of(context);

  Future<void> pick(ImageSource source) async {
    Navigator.of(context).pop();
    await ref.read(authViewModelProvider.notifier).pickAndUpdatePhoto(source);
    if (!context.mounted) return;
    if (ref.read(authViewModelProvider).hasError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.authErrorGeneric)));
    }
  }

  Future<void> remove() async {
    Navigator.of(context).pop();
    await ref.read(authViewModelProvider.notifier).removePhoto();
    if (!context.mounted) return;
    if (ref.read(authViewModelProvider).hasError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.authErrorGeneric)));
    }
  }

  Future<void> createPreset() async {
    Navigator.of(context).pop();
    final result = await showDialog<(PresetAnimal, Color)>(
      context: context,
      builder: (_) => PresetAvatarPickerDialog(
        initialAnimal: initialAnimal,
        initialColor: initialColorValue == null ? null : Color(initialColorValue),
      ),
    );
    if (result == null || !context.mounted) return;
    final (animal, color) = result;
    await ref.read(authViewModelProvider.notifier).setPresetAvatar(animal, color);
    if (!context.mounted) return;
    if (ref.read(authViewModelProvider).hasError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.authErrorGeneric)));
    }
  }

  await showModalBottomSheet<void>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.choosePhotoFromGalleryLabel),
            onTap: () => pick(ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.takePhotoLabel),
            onTap: () => pick(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: Text(l10n.createPresetAvatarLabel),
            onTap: createPreset,
          ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.removePhotoLabel),
              onTap: remove,
            ),
        ],
      ),
    ),
  );
}

Future<void> _showChangeUsernameDialog(
  BuildContext context,
  WidgetRef ref,
  String? currentName,
) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: currentName ?? '');

  final newName = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.changeUsernameLabel),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: l10n.displayNameLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
          child: Text(l10n.saveLabel),
        ),
      ],
    ),
  );
  controller.dispose();

  if (newName == null || newName.isEmpty || !context.mounted) return;
  await ref.read(authViewModelProvider.notifier).updateDisplayName(newName);
  if (!context.mounted) return;
  final hasError = ref.read(authViewModelProvider).hasError;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(hasError ? l10n.authErrorGeneric : l10n.usernameUpdatedMessage),
    ),
  );
}

Future<void> _showChangeEmailDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController();

  final newEmail = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.changeEmailLabel),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: l10n.newEmailLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
          child: Text(l10n.saveLabel),
        ),
      ],
    ),
  );
  controller.dispose();

  if (newEmail == null || newEmail.isEmpty || !context.mounted) return;
  await ref.read(authViewModelProvider.notifier).updateEmail(newEmail);
  if (!context.mounted) return;
  final hasError = ref.read(authViewModelProvider).hasError;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(hasError ? l10n.authErrorGeneric : l10n.emailUpdateSentMessage),
    ),
  );
}

Future<void> _showChangePasswordDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final currentController = TextEditingController();
  final newController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.changePasswordLabel),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: currentController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.currentPasswordLabel),
          ),
          const SizedBox(height: AppDimens.spaceM),
          TextField(
            controller: newController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.newPasswordLabel),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.saveLabel),
        ),
      ],
    ),
  );

  final currentPassword = currentController.text;
  final newPassword = newController.text;
  currentController.dispose();
  newController.dispose();

  if (confirmed != true ||
      currentPassword.isEmpty ||
      newPassword.isEmpty ||
      !context.mounted) {
    return;
  }

  await ref.read(authViewModelProvider.notifier).updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
  if (!context.mounted) return;
  final hasError = ref.read(authViewModelProvider).hasError;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(hasError ? l10n.authErrorGeneric : l10n.passwordUpdatedMessage),
    ),
  );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceXs),
      child: ListTile(
        title: Text(label),
        trailing: selected
            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
