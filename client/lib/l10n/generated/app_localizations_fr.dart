// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Ouvrir les réglages Système';

  @override
  String get noDevices => 'Aucun appareil trouvé';

  @override
  String get connect => 'Connecter';

  @override
  String get connecting => 'Connexion';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get autoConnectLastDevice =>
      'Se connecter automatiquement au dernier appareil utilisé';

  @override
  String get language => 'Langue';

  @override
  String get followSystem => 'Suivre le système';

  @override
  String get noLanguageMatch => 'Aucune langue correspondante';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle =>
      'Autorisation d\'enregistrement requise';

  @override
  String get recordingPermissionDescription =>
      'Dans les réglages Système, accédez à Confidentialité et sécurité > Enregistrement de l\'écran et du son du système, puis autorisez AudioShare. macOS exige un redémarrage de l\'application pour que la nouvelle autorisation prenne effet : quittez AudioShare, rouvrez-la, puis reconnectez-vous.';

  @override
  String get connectionFailedTitle => 'Échec de la connexion';

  @override
  String get captureInitializationFailed =>
      'Impossible d\'initialiser la capture du son du système.';

  @override
  String get captureStopped => 'La capture du son du système s\'est arrêtée.';

  @override
  String get captureStartFailed =>
      'Impossible de démarrer la capture du son du système.';

  @override
  String get listenerStartFailed =>
      'Impossible de démarrer le service local de streaming audio.';

  @override
  String get noAvailablePort => 'Aucun port d\'écoute local n\'est disponible.';

  @override
  String get connectAndroidDeviceFailed =>
      'Une erreur s\'est produite lors de la connexion à l\'appareil Android.';

  @override
  String get connectDeviceFailed =>
      'Une erreur s\'est produite lors de la connexion à l\'appareil.';

  @override
  String nativeErrorDetails(String code) {
    return 'Code d\'erreur : $code';
  }

  @override
  String get nativeError1000 =>
      'Échec de l\'initialisation de la capture audio.';

  @override
  String get nativeError1001 =>
      'Cette version de macOS ne prend pas en charge la capture du son du système.';

  @override
  String get nativeError1002 =>
      'L\'autorisation d\'enregistrement de l\'écran et du son du système n\'est pas disponible.';

  @override
  String get nativeError1100 =>
      'Impossible de démarrer l\'écoute audio locale.';

  @override
  String get nativeError1101 =>
      'Impossible de créer le socket d\'écoute local.';

  @override
  String get nativeError1102 => 'Impossible de lier le socket d\'écoute local.';

  @override
  String get nativeError1103 =>
      'Le socket d\'écoute local n\'a pas pu commencer à écouter.';

  @override
  String get nativeError1104 =>
      'Impossible de créer le thread d\'écoute local.';

  @override
  String get nativeError1105 => 'Le démarrage de l\'écoute locale a expiré.';

  @override
  String get nativeError1106 =>
      'Impossible d\'accepter la connexion de l\'appareil Android.';

  @override
  String get nativeError1107 =>
      'Impossible de lire le code de connexion de l\'appareil Android.';

  @override
  String get nativeError1200 =>
      'Impossible de démarrer la capture du son du système.';

  @override
  String get nativeError1201 =>
      'Impossible d\'obtenir le contenu du partage d\'écran.';

  @override
  String get nativeError1202 =>
      'Aucun écran n\'est disponible pour la capture du son du système.';

  @override
  String get nativeError1203 =>
      'Impossible de configurer la sortie audio de ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Impossible de démarrer la capture audio de ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'La capture audio de ScreenCaptureKit s\'est arrêtée de manière inattendue.';

  @override
  String get nativeError1206 =>
      'Le démarrage de la capture audio de ScreenCaptureKit a expiré.';

  @override
  String get nativeErrorUnknown =>
      'Une erreur inconnue de capture du son du système s\'est produite.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostic : $message';
  }
}
