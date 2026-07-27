// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Moodflix';

  @override
  String get moodMindBenderTitle => 'Beynimi Yaksın';

  @override
  String get moodNostalgiaTitle => 'Nostalji';

  @override
  String get moodThrillerTitle => 'Gerilim';

  @override
  String get moodNetflixTitle => 'Netflix Filmleri';

  @override
  String get emptyMovies => 'Bu modda film bulunamadı.';

  @override
  String get errorGeneric => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get myListsScreenTitle => 'Listelerim';

  @override
  String get watchlistTabLabel => 'İzleyeceklerim';

  @override
  String get favoritesTabLabel => 'Favorilerim';

  @override
  String get emptyWatchlist => 'Henüz izleyeceklerine bir şey eklemedin.';

  @override
  String get emptyFavorites => 'Henüz favori eklemedin.';

  @override
  String get removeFromListTooltip => 'Kaldır';

  @override
  String get addToFavoritesTooltip => 'Favorilere ekle';

  @override
  String get removeFromFavoritesTooltip => 'Favorilerden çıkar';

  @override
  String get shareTooltip => 'Arkadaşa gönder';

  @override
  String shareMessage(String title, String url) {
    return '$title filmine göz at: $url';
  }

  @override
  String get trailerSectionTitle => 'Fragman';

  @override
  String get trailerRequiresInternet =>
      'Fragmanı izlemek için internet bağlantısı gerekiyor.';

  @override
  String get trailerUnavailable => 'Bu film için fragman bulunamadı.';

  @override
  String get howToBrowseTitle => 'Nasıl film bulmak istersin?';

  @override
  String get browseByMoodLabel => 'Moda Göre';

  @override
  String get browseByMoodSubtitle => 'O anki ruh haline uygun öneriler al';

  @override
  String get browseByCategoryLabel => 'Kategoriye Göre';

  @override
  String get browseByCategorySubtitle => 'Bir tür seç, içindeki her şeye gözat';

  @override
  String get moodSelectionTitle => 'Mod Seç';

  @override
  String get categorySelectionTitle => 'Kategoriler';

  @override
  String get genreAction => 'Aksiyon';

  @override
  String get genreAdventure => 'Macera';

  @override
  String get genreAnimation => 'Animasyon';

  @override
  String get genreComedy => 'Komedi';

  @override
  String get genreCrime => 'Suç';

  @override
  String get genreDocumentary => 'Belgesel';

  @override
  String get genreDrama => 'Dram';

  @override
  String get genreFamily => 'Aile';

  @override
  String get genreFantasy => 'Fantastik';

  @override
  String get genreHistory => 'Tarih';

  @override
  String get genreHorror => 'Korku';

  @override
  String get genreMusic => 'Müzik';

  @override
  String get genreMystery => 'Gizem';

  @override
  String get genreRomance => 'Romantik';

  @override
  String get genreScienceFiction => 'Bilim Kurgu';

  @override
  String get genreTvMovie => 'TV Filmi';

  @override
  String get genreThriller => 'Gerilim';

  @override
  String get genreWar => 'Savaş';

  @override
  String get genreWestern => 'Vahşi Batı';

  @override
  String get searchHint => 'Film ara...';

  @override
  String get searchPrompt => 'Bir film adı yazmaya başla';

  @override
  String get searchNoResults => 'Sonuç bulunamadı';

  @override
  String get homeTooltip => 'Ana ekrana dön';

  @override
  String get undoSwipeTooltip => 'Geri al';

  @override
  String get settingsScreenTitle => 'Ayarlar';

  @override
  String get themeSectionTitle => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get languageSectionTitle => 'Dil';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get languageEn => 'İngilizce';
}
