import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AudioShare'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevices;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @autoConnectLastDevice.
  ///
  /// In en, this message translates to:
  /// **'Automatically connect to the last used device'**
  String get autoConnectLastDevice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese (Simplified)'**
  String get languageChinese;

  /// No description provided for @deviceAndroidVersion.
  ///
  /// In en, this message translates to:
  /// **'Android {version} (API {apiLevel})'**
  String deviceAndroidVersion(String version, String apiLevel);

  /// No description provided for @deviceNetworkAddress.
  ///
  /// In en, this message translates to:
  /// **' - {ip}:{port}'**
  String deviceNetworkAddress(String ip, String port);

  /// No description provided for @recordingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording permission required'**
  String get recordingPermissionTitle;

  /// No description provided for @recordingPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Screen and system audio recording permission was not granted. In System Settings, go to Privacy & Security > Screen & System Audio Recording, allow AudioShare, then connect again.'**
  String get recordingPermissionDescription;

  /// No description provided for @connectionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailedTitle;

  /// No description provided for @captureInitializationFailed.
  ///
  /// In en, this message translates to:
  /// **'System audio capture could not be initialized.'**
  String get captureInitializationFailed;

  /// No description provided for @captureStopped.
  ///
  /// In en, this message translates to:
  /// **'System audio capture stopped.'**
  String get captureStopped;

  /// No description provided for @captureStartFailed.
  ///
  /// In en, this message translates to:
  /// **'System audio capture could not be started.'**
  String get captureStartFailed;

  /// No description provided for @listenerStartFailed.
  ///
  /// In en, this message translates to:
  /// **'The local audio streaming service could not be started.'**
  String get listenerStartFailed;

  /// No description provided for @noAvailablePort.
  ///
  /// In en, this message translates to:
  /// **'No local listening port is available.'**
  String get noAvailablePort;

  /// No description provided for @connectAndroidDeviceFailed.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while connecting to the Android device.'**
  String get connectAndroidDeviceFailed;

  /// No description provided for @connectDeviceFailed.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while connecting to the device.'**
  String get connectDeviceFailed;

  /// No description provided for @nativeErrorDetails.
  ///
  /// In en, this message translates to:
  /// **'Error code: {code}'**
  String nativeErrorDetails(String code);

  /// No description provided for @nativeError1000.
  ///
  /// In en, this message translates to:
  /// **'Audio capture initialization failed.'**
  String get nativeError1000;

  /// No description provided for @nativeError1001.
  ///
  /// In en, this message translates to:
  /// **'This macOS version does not support system audio capture.'**
  String get nativeError1001;

  /// No description provided for @nativeError1002.
  ///
  /// In en, this message translates to:
  /// **'Screen and system audio recording permission is unavailable.'**
  String get nativeError1002;

  /// No description provided for @nativeError1100.
  ///
  /// In en, this message translates to:
  /// **'The local audio listener could not be started.'**
  String get nativeError1100;

  /// No description provided for @nativeError1101.
  ///
  /// In en, this message translates to:
  /// **'The local listening socket could not be created.'**
  String get nativeError1101;

  /// No description provided for @nativeError1102.
  ///
  /// In en, this message translates to:
  /// **'The local listening socket could not be bound.'**
  String get nativeError1102;

  /// No description provided for @nativeError1103.
  ///
  /// In en, this message translates to:
  /// **'The local listening socket could not start listening.'**
  String get nativeError1103;

  /// No description provided for @nativeError1104.
  ///
  /// In en, this message translates to:
  /// **'The local listener thread could not be created.'**
  String get nativeError1104;

  /// No description provided for @nativeError1105.
  ///
  /// In en, this message translates to:
  /// **'Starting the local listener timed out.'**
  String get nativeError1105;

  /// No description provided for @nativeError1106.
  ///
  /// In en, this message translates to:
  /// **'The Android connection could not be accepted.'**
  String get nativeError1106;

  /// No description provided for @nativeError1107.
  ///
  /// In en, this message translates to:
  /// **'The Android connection code could not be read.'**
  String get nativeError1107;

  /// No description provided for @nativeError1200.
  ///
  /// In en, this message translates to:
  /// **'System audio capture could not be started.'**
  String get nativeError1200;

  /// No description provided for @nativeError1201.
  ///
  /// In en, this message translates to:
  /// **'Screen sharing content could not be obtained.'**
  String get nativeError1201;

  /// No description provided for @nativeError1202.
  ///
  /// In en, this message translates to:
  /// **'No display is available for system audio capture.'**
  String get nativeError1202;

  /// No description provided for @nativeError1203.
  ///
  /// In en, this message translates to:
  /// **'ScreenCaptureKit audio output could not be configured.'**
  String get nativeError1203;

  /// No description provided for @nativeError1204.
  ///
  /// In en, this message translates to:
  /// **'ScreenCaptureKit audio capture could not be started.'**
  String get nativeError1204;

  /// No description provided for @nativeError1205.
  ///
  /// In en, this message translates to:
  /// **'ScreenCaptureKit audio capture stopped unexpectedly.'**
  String get nativeError1205;

  /// No description provided for @nativeError1206.
  ///
  /// In en, this message translates to:
  /// **'Starting ScreenCaptureKit audio capture timed out.'**
  String get nativeError1206;

  /// No description provided for @nativeErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown system audio capture error occurred.'**
  String get nativeErrorUnknown;

  /// No description provided for @exceptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic: {message}'**
  String exceptionDetails(String message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
