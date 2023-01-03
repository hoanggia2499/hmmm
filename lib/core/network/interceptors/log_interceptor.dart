import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mirukuru/core/util/logger_util.dart';

class DefaultLogInterceptor extends Interceptor {
  DefaultLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = true,
    this.responseBody = true,
    this.error = true,
    this.logSize = 2048,
  });

  /// Print request [Options]
  late bool request;

  /// Print request header [Options.headers]
  late bool requestHeader;

  /// Print request data [Options.data]
  late bool requestBody;

  /// Print [Response.data]
  late bool responseBody;

  /// Print [Response.headers]
  late bool responseHeader;

  /// Print error message
  late bool error;

  /// Log size per print
  late final logSize;

  late DateTime startTime;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    startTime = DateTime.now();
    Logging.log.info('╔══════════ Request Start ═══════════');
    Logging.log.info('║ Uri: ${options.uri}');
    Logging.log.info('║ Method: ${options.method}');
    Logging.log.info('║ ContentType: ${options.contentType}');
    Logging.log.info('║ ResponseType: ${options.responseType}');
    Logging.log.info('║ FollowRedirects: ${options.followRedirects}');
    Logging.log.info('║ ConnectTimeout: ${options.connectTimeout}');
    Logging.log.info('║ ReceiveTimeout: ${options.receiveTimeout}');
    //Logging.log.info('║ Extra: ${options.extra}');
    Logging.log.info('║ Header: ${options.headers}');
    Logging.log.info('║ Data: ${options.data ?? '{}'}');
//    Logging.log.info('║ Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime)}');
    Logging.log.info('╚══════════  Request End  ═══════════');
    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    final now = DateTime.now();
    final duration = startTime == null ? null : now.difference(startTime);
    if (error) {
      Logging.log.warn('╔══════════ DioError Start ═══════════');
      Logging.log.warn('║ ${err.message}', err);
      if (err.response != null) {
        var response = err.response;
        // Logging.log.warn('║ Uri: ${response!.request.uri}');
        if (responseHeader) {
          Logging.log.warn('║ StatusCode: ${response!.statusCode}');
          if (response.isRedirect ?? false) {
            Logging.log.warn('║ Redirect: ${response.realUri}');
          }
          Logging.log.warn('║ Headers: ${response.headers}');
        }
        if (responseBody) {
          Logging.log.warn('║ Data: ${response.toString()}');
        }
//        Logging.log.warn('║ Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
        if (duration != null) {
          Logging.log.warn('║ Duration: ${duration.inMilliseconds}ms');
        }
      }
      Logging.log.warn('╚══════════  DioError End  ═══════════');
    }
    return super.onError(err, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    final now = DateTime.now();
    final duration = startTime == null ? null : now.difference(startTime);
    Logging.log.info('╔══════════ Response Start ═══════════');
    // Logging.log.info('║ Uri: ${response?.request.uri}');
    if (responseHeader) {
      Logging.log.info('║ StatusCode: ${response.statusCode}');
      if (response.isRedirect == true) {
        Logging.log.info('║ Redirect: ${response.realUri}');
      }
      Logging.log.info('║ Headers: ${response.headers}');
    }
    if (responseBody) {
      Logging.log.info('║ Data: $response');
    }
//    Logging.log.info('║ Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
    if (duration != null) {
      Logging.log.info('║ Duration: ${duration.inMilliseconds}ms');
    }
    Logging.log.info('╚══════════  Response End  ═══════════');
    return super.onResponse(response, handler);
  }
}
