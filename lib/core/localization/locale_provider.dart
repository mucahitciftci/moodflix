import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/local_cache_service.dart';

/// App-wide locale (TR/EN), persisted to Hive so it survives app restarts
/// and sign in/out — device-local, independent of which account (if any)
/// is signed in. Falls back to the device locale (if supported) on first
/// launch, before any preference has been saved.
class LocaleNotifier extends Notifier<Locale> {
  static const List<Locale> supportedLocales = [Locale('tr'), Locale('en')];

  @override
  Locale build() {
    final saved = ref.read(localCacheServiceProvider).getLocaleLanguageCode();
    if (saved != null &&
        supportedLocales.any((locale) => locale.languageCode == saved)) {
      return Locale(saved);
    }

    final deviceLanguage = PlatformDispatcher.instance.locale.languageCode;
    final isSupported =
        supportedLocales.any((locale) => locale.languageCode == deviceLanguage);
    return isSupported ? Locale(deviceLanguage) : const Locale('tr');
  }

  void setLocale(Locale locale) {
    state = locale;
    ref.read(localCacheServiceProvider).setLocaleLanguageCode(locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
