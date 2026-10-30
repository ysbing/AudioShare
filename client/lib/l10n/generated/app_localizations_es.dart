// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'Aceptar';

  @override
  String get openSystemSettings => 'Abrir ajustes del sistema';

  @override
  String get noDevices => 'No se encontraron dispositivos';

  @override
  String get connect => 'Conectar';

  @override
  String get connecting => 'Conectando';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get autoConnectLastDevice =>
      'Conectar automáticamente al último dispositivo usado';

  @override
  String get language => 'Idioma';

  @override
  String get followSystem => 'Seguir al sistema';

  @override
  String get noLanguageMatch => 'Ningún idioma coincide';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Se requiere permiso de grabación';

  @override
  String get recordingPermissionDescription =>
      'En Ajustes del Sistema, ve a Privacidad y seguridad > Grabación de pantalla y audio del sistema y permite AudioShare. macOS requiere reiniciar la aplicación para que el nuevo permiso surta efecto: sal de AudioShare, vuelve a abrirla y conéctate de nuevo.';

  @override
  String get connectionFailedTitle => 'Error de conexión';

  @override
  String get captureInitializationFailed =>
      'No se pudo inicializar la captura de audio del sistema.';

  @override
  String get captureStopped => 'Se detuvo la captura de audio del sistema.';

  @override
  String get captureStartFailed =>
      'No se pudo iniciar la captura de audio del sistema.';

  @override
  String get listenerStartFailed =>
      'No se pudo iniciar el servicio local de transmisión de audio.';

  @override
  String get noAvailablePort =>
      'No hay ningún puerto de escucha local disponible.';

  @override
  String get connectAndroidDeviceFailed =>
      'Se produjo un error al conectar con el dispositivo Android.';

  @override
  String get connectDeviceFailed =>
      'Se produjo un error al conectar con el dispositivo.';

  @override
  String nativeErrorDetails(String code) {
    return 'Código de error: $code';
  }

  @override
  String get nativeError1000 => 'Error al inicializar la captura de audio.';

  @override
  String get nativeError1001 =>
      'Esta versión de macOS no admite la captura de audio del sistema.';

  @override
  String get nativeError1002 =>
      'El permiso de grabación de pantalla y audio del sistema no está disponible.';

  @override
  String get nativeError1100 =>
      'No se pudo iniciar el servicio local de escucha de audio.';

  @override
  String get nativeError1101 => 'No se pudo crear el socket de escucha local.';

  @override
  String get nativeError1102 =>
      'No se pudo enlazar el socket de escucha local.';

  @override
  String get nativeError1103 =>
      'El socket de escucha local no pudo comenzar a escuchar.';

  @override
  String get nativeError1104 => 'No se pudo crear el hilo de escucha local.';

  @override
  String get nativeError1105 =>
      'Se agotó el tiempo de espera al iniciar el servicio local de escucha.';

  @override
  String get nativeError1106 =>
      'No se pudo aceptar la conexión del dispositivo Android.';

  @override
  String get nativeError1107 =>
      'No se pudo leer el código de conexión del dispositivo Android.';

  @override
  String get nativeError1200 =>
      'No se pudo iniciar la captura de audio del sistema.';

  @override
  String get nativeError1201 =>
      'No se pudo obtener el contenido de la pantalla compartida.';

  @override
  String get nativeError1202 =>
      'No hay ninguna pantalla disponible para la captura de audio del sistema.';

  @override
  String get nativeError1203 =>
      'No se pudo configurar la salida de audio de ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'No se pudo iniciar la captura de audio de ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'La captura de audio de ScreenCaptureKit se detuvo inesperadamente.';

  @override
  String get nativeError1206 =>
      'Se agotó el tiempo de espera al iniciar la captura de audio de ScreenCaptureKit.';

  @override
  String get nativeErrorUnknown =>
      'Se produjo un error desconocido de captura de audio del sistema.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnóstico: $message';
  }

  @override
  String get winMinimize => 'Minimizar';

  @override
  String get winClose => 'Cerrar';
}
