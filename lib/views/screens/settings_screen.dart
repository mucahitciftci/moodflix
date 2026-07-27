import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';

/// Theme (light/dark/system) and language (TR/EN) settings. Both providers
/// (`themeModeProvider`, `localeProvider`) already drive `MoodflixApp`, so
/// this screen only needs to read/write them — no new state of its own.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        children: [
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
