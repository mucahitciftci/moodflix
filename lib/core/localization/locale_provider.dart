import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-wide locale (TR/EN). Defaults to the device locale when it's one of
/// the supported languages, otherwise falls back to Turkish. Persistence to
/// local storage is wired in from the settings feature once
/// `LocalCacheService` supports app-level preferences.
class LocaleNotifier extends Notifier<Locale> {
  static const List<Locale> supportedLocales = [Locale('tr'), Locale('en')];

  @override
  Locale build() {
    final deviceLanguage = PlatformDispatcher.instance.locale.languageCode;
    final isSupported =
        supportedLocales.any((locale) => locale.languageCode == deviceLanguage);
    return isSupported ? Locale(deviceLanguage) : const Locale('tr');
  }

  void setLocale(Locale locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
