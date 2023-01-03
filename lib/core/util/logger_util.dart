import 'package:logger/logger.dart';

class Logging {
  static Logging log = Logging._internal();
  late Logger logger;

  factory Logging() {
    return log;
  }

  Logging._internal() {
    logger = Logger(
        filter: null,
        output: null,
        printer: PrettyPrinter(
            methodCount: 0,
            lineLength: 2048,
            colors: true,
            noBoxingByDefault: true));
  }

  void info(dynamic message) {
    logger.i(message);
  }

  void warn(dynamic message, [dynamic error]) {
    logger.w(message, error);
  }

  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.d(message, error, stackTrace);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error, stackTrace);
  }
}
