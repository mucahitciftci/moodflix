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
  String get authTagline => 'Ruh haline uygun filmler';

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
  String get browseByTrendingLabel => 'Popüler';

  @override
  String get browseByTrendingSubtitle => 'Şu anda herkesin izlediklerine gözat';

  @override
  String get trendingMoviesTitle => 'Popüler Filmler';

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
  String get settingsScreenTitle => 'Menü';

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

  @override
  String get loginScreenTitle => 'Giriş Yap';

  @override
  String get signUpScreenTitle => 'Kayıt Ol';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get displayNameLabel => 'Adın';

  @override
  String get forgotPasswordLabel => 'Şifremi unuttum';

  @override
  String get sendResetLinkLabel => 'Gönder';

  @override
  String get resetLinkSentMessage =>
      'Şifre sıfırlama bağlantısı e-postana gönderildi.';

  @override
  String get cancelLabel => 'Vazgeç';

  @override
  String get goToSignUpLabel => 'Hesabın yok mu? Kayıt ol';

  @override
  String get goToLoginLabel => 'Zaten hesabın var mı? Giriş yap';

  @override
  String get authErrorGeneric =>
      'Bir şeyler ters gitti. Bilgilerini kontrol edip tekrar dene.';

  @override
  String get accountSectionTitle => 'Hesap';

  @override
  String get logoutLabel => 'Çıkış Yap';

  @override
  String get notLoggedInMessage => 'Giriş yapılmadı';

  @override
  String get reviewsSectionTitle => 'İncelemeler';

  @override
  String get writeReviewLabel => 'İnceleme Yaz';

  @override
  String get writeReviewTitle => 'İncelemeni yaz';

  @override
  String get reviewTextHint => 'Bu film hakkında ne düşünüyorsun?';

  @override
  String get submitReviewLabel => 'Gönder';

  @override
  String get noReviewsYet => 'Henüz inceleme yok. İlk incelemeyi sen yaz!';

  @override
  String get continueAsGuestLabel => 'Misafir olarak devam et';

  @override
  String get orContinueWithLabel => 'veya devam et';

  @override
  String get continueWithGoogleLabel => 'Google ile devam et';

  @override
  String get continueWithAppleLabel => 'Apple ile devam et';

  @override
  String howToBrowseTitleWithName(String name) {
    return 'Nasıl film bulmak istersin, $name?';
  }

  @override
  String get changePhotoLabel => 'Profil fotoğrafını değiştir';

  @override
  String get choosePhotoFromGalleryLabel => 'Galeriden seç';

  @override
  String get takePhotoLabel => 'Kamerayla çek';

  @override
  String get removePhotoLabel => 'Fotoğrafı kaldır';

  @override
  String get createPresetAvatarLabel => 'Hazır avatar oluştur';

  @override
  String get chooseAnimalLabel => 'Hayvan seç';

  @override
  String get chooseColorLabel => 'Renk seç';

  @override
  String get changeUsernameLabel => 'Kullanıcı Adını Değiştir';

  @override
  String get changeEmailLabel => 'E-postayı Değiştir';

  @override
  String get changePasswordLabel => 'Şifreyi Değiştir';

  @override
  String get newEmailLabel => 'Yeni e-posta';

  @override
  String get currentPasswordLabel => 'Mevcut şifre';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get saveLabel => 'Kaydet';

  @override
  String get usernameUpdatedMessage => 'Kullanıcı adın güncellendi.';

  @override
  String get emailUpdateSentMessage =>
      'Yeni e-postana bir onay linki gönderdik. Onaylayınca e-postan değişecek.';

  @override
  String get passwordUpdatedMessage => 'Şifren güncellendi.';

  @override
  String get socialScreenTitle => 'Sosyal';

  @override
  String get searchTabLabel => 'Ara';

  @override
  String get followingTabLabel => 'Takip Ettiklerim';

  @override
  String get searchUsersHint => 'Kullanıcı ara...';

  @override
  String get noUsersFound => 'Kullanıcı bulunamadı';

  @override
  String get noFollowingYet => 'Henüz kimseyi takip etmiyorsun';

  @override
  String get followButtonLabel => 'Takip Et';

  @override
  String get unfollowButtonLabel => 'Takip Ediliyor';

  @override
  String get userHasNoReviewsYet => 'Bu kullanıcı henüz inceleme yazmamış.';

  @override
  String get likeTooltip => 'Beğen';

  @override
  String get commentsTooltip => 'Yorumlar';

  @override
  String get commentHint => 'Yorum yaz...';

  @override
  String get noCommentsYet => 'Henüz yorum yok.';

  @override
  String get privacySectionTitle => 'Gizlilik';

  @override
  String get listSharingOff => 'Kapalı';

  @override
  String get listSharingPublic => 'Herkese Açık';

  @override
  String get listSharingFollowers => 'Sadece Takipçilerime';

  @override
  String get theirWatchlistTitle => 'İzleyecekleri';

  @override
  String get theirFavoritesTitle => 'Favorileri';

  @override
  String get emptySharedListMessage => 'Henüz bir şey eklenmemiş.';
}
