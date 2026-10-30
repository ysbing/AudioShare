// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Otwórz Ustawienia systemowe';

  @override
  String get noDevices => 'Nie znaleziono urządzeń';

  @override
  String get connect => 'Połącz';

  @override
  String get connecting => 'Łączenie';

  @override
  String get disconnect => 'Odłącz';

  @override
  String get autoConnectLastDevice =>
      'Automatycznie łącz z ostatnio używanym urządzeniem';

  @override
  String get language => 'Język';

  @override
  String get followSystem => 'Zgodnie z systemem';

  @override
  String get noLanguageMatch => 'Brak pasującego języka';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Wymagane uprawnienia do nagrywania';

  @override
  String get recordingPermissionDescription =>
      'W Ustawieniach systemowych przejdź do Prywatności i bezpieczeństwa > Nagrywanie ekranu i dźwięku systemowego i zezwól na AudioShare. macOS wymaga ponownego uruchomienia aplikacji, aby nowe uprawnienie zaczęło obowiązywać; zamknij AudioShare, otwórz go ponownie, a następnie połącz się jeszcze raz.';

  @override
  String get connectionFailedTitle => 'Połączenie nieudane';

  @override
  String get captureInitializationFailed =>
      'Nie udało się zainicjalizować przechwytywania dźwięku systemowego.';

  @override
  String get captureStopped =>
      'Przechwytywanie dźwięku systemowego zostało zatrzymane.';

  @override
  String get captureStartFailed =>
      'Nie udało się rozpocząć przechwytywania dźwięku systemowego.';

  @override
  String get listenerStartFailed =>
      'Nie udało się uruchomić lokalnej usługi strumieniowania dźwięku.';

  @override
  String get noAvailablePort => 'Brak dostępnych lokalnych portów nasłuchu.';

  @override
  String get connectAndroidDeviceFailed =>
      'Podczas łączenia z urządzeniem z systemem Android wystąpił błąd.';

  @override
  String get connectDeviceFailed =>
      'Podczas łączenia z urządzeniem wystąpił błąd.';

  @override
  String nativeErrorDetails(String code) {
    return 'Kod błędu: $code';
  }

  @override
  String get nativeError1000 =>
      'Nie udało się zainicjalizować przechwytywania dźwięku.';

  @override
  String get nativeError1001 =>
      'Ta wersja systemu macOS nie obsługuje przechwytywania dźwięku systemowego.';

  @override
  String get nativeError1002 =>
      'Uprawnienie do nagrywania ekranu i dźwięku systemowego jest niedostępne.';

  @override
  String get nativeError1100 =>
      'Nie udało się uruchomić lokalnego nasłuchu dźwięku.';

  @override
  String get nativeError1101 =>
      'Nie udało się utworzyć lokalnego gniazda nasłuchowego.';

  @override
  String get nativeError1102 =>
      'Nie udało się powiązać lokalnego gniazda nasłuchowego.';

  @override
  String get nativeError1103 =>
      'Lokalne gniazdo nasłuchowe nie mogło rozpocząć nasłuchu.';

  @override
  String get nativeError1104 =>
      'Nie udało się utworzyć wątku nasłuchu lokalnego.';

  @override
  String get nativeError1105 =>
      'Uruchamianie nasłuchu lokalnego przekroczyło limit czasu.';

  @override
  String get nativeError1106 =>
      'Nie udało się przyjąć połączenia z urządzenia z systemem Android.';

  @override
  String get nativeError1107 =>
      'Nie udało się odczytać kodu połączenia urządzenia z systemem Android.';

  @override
  String get nativeError1200 =>
      'Nie udało się rozpocząć przechwytywania dźwięku systemowego.';

  @override
  String get nativeError1201 =>
      'Nie udało się pobrać zawartości udostępniania ekranu.';

  @override
  String get nativeError1202 =>
      'Brak wyświetlaczy dostępnych do przechwytywania dźwięku systemowego.';

  @override
  String get nativeError1203 =>
      'Nie udało się skonfigurować wyjścia audio ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Nie udało się rozpocząć przechwytywania dźwięku w ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Przechwytywanie dźwięku w ScreenCaptureKit zakończyło się niespodziewanie.';

  @override
  String get nativeError1206 =>
      'Uruchamianie przechwytywania dźwięku w ScreenCaptureKit przekroczyło limit czasu.';

  @override
  String get nativeErrorUnknown =>
      'Wystąpił nieznany błąd przechwytywania dźwięku systemowego.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostyka: $message';
  }

  @override
  String get winMinimize => 'Minimalizuj';

  @override
  String get winClose => 'Zamknij';
}
