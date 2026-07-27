import 'package:flutter/material.dart';

import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';

/// Standard `AppBar.leading` for screens more than one level deep in the
/// navigation stack (discovery, movie detail): the normal back button plus
/// a home shortcut that jumps straight back to `BrowseModeScreen`, clearing
/// the rest of the stack. Pair with `AppBar(leadingWidth: AppDimens.appBarLeadingWidthWide)`
/// since this renders two icons instead of the usual one.
class AppBarHomeLeading extends StatelessWidget {
  const AppBarHomeLeading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BackButton(),
        IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: l10n.homeTooltip,
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.browseMode,
            (route) => false,
          ),
        ),
      ],
    );
  }
}
