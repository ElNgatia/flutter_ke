import 'package:logging/logging.dart';

/// In future, can be extended to use Sentry or other services in production.
class ErrorLoggerService {
  ErrorLoggerService._() {
    _ensureLoggingConfigured();
  }

  static final ErrorLoggerService _instance = ErrorLoggerService._();

  static ErrorLoggerService get instance => _instance;

  static final Logger _logger = Logger('ErrorLogger');

  static bool _loggingConfigured = false;

  static void _ensureLoggingConfigured() {
    if (_loggingConfigured) return;
    _loggingConfigured = true;
    Logger.root.level = Level.ALL;
  }

  /// Logs an error. In debug this uses the logging package; in production
  /// this can be switched to Sentry or similar.
  void logError(
    Object error, {
    StackTrace? stackTrace,
    String? message,
  }) {
    _logger.severe(
      message ?? error.toString(),
      error,
      stackTrace,
    );
  }
}
