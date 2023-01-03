import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/network/interceptors/log_interceptor.dart';
import 'package:mirukuru/core/network/interceptors/refresh_interceptor.dart';
import 'package:mirukuru/core/network/result_entity.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/util/error_code.dart';

class BaseDio {
  static BaseDio instance = BaseDio._internal();
  late Dio dio;

  factory BaseDio({required String hostUrl, int defaultTimeOut = 15000}) {
    instance =
        BaseDio._internal(hostUrl: hostUrl, defaultTimeOut: defaultTimeOut);
    return instance;
  }

  BaseDio._internal({String hostUrl = '', int defaultTimeOut = 15000}) {
    dio = Dio(BaseOptions(baseUrl: hostUrl, connectTimeout: defaultTimeOut));
    dio.interceptors.add(DefaultLogInterceptor());
    dio.interceptors.add(RefreshTokenInterceptor());
  }

  Future<ResultEntity<T>> request<T>(String url, MethodType method,
      {Map<String, String>? headers, dynamic data}) {
    switch (method) {
      case MethodType.POST:
        return post<T>(url, headers: headers, data: data);
      case MethodType.PUT:
        return put<T>(url, headers: headers, data: data);
      case MethodType.DELETE:
        return delete<T>(url, headers: headers, data: data);
      default:
        // GET METHOD
        return get<T>(url, headers: headers, data: data);
    }
  }

  Future<ResultEntity<T>> get<T>(String url,
      {Map<String, String>? headers, dynamic data}) async {
    try {
      headers ??= <String, String>{};
      headers.addAll({
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      });
      var realUrl = url;
      if (data != null) {
        if (data is Map<String, List<String>>) {
          var mapData = data;
          for (var item in mapData.entries) {
            item.value.forEach((element) {
              if (realUrl == url) {
                realUrl += '?${item.key}=${element.toString()}';
              } else {
                realUrl += '&${item.key}=${element.toString()}';
              }
            });
          }
        } else if (data is Map<String, dynamic>) {
          var mapData = data;
          for (var item in mapData.entries) {
            if (realUrl == url) {
              realUrl += '?${item.key}=${item.value}';
            } else {
              realUrl += '&${item.key}=${item.value}';
            }
          }
        }
      }

      var response = await dio.request(realUrl,
          options: Options(headers: headers, method: 'GET'));

      return ResultEntity<T>(TaskResult.success, response.data);
    } catch (exception) {
      if (exception is DioError &&
          exception.error == "Http status error [401]") {
        return ResultEntity<T>(
            TaskResult.tokenTimeout, exception.response?.data);
      }
      if (exception is DioError) {
        return ResultEntity<T>(TaskResult.error, exception.response?.data);
      }
      return ResultEntity<T>(TaskResult.error, {
        'messageCode': ErrorCode.MA013CE,
        'messageContent': ErrorCode.MA013CE.tr()
      });
    }
  }

  Future<ResultEntity<T>> post<T>(String url,
      {Map<String, String>? headers,
      required Map<String, dynamic> data}) async {
    try {
      headers ??= <String, String>{};
      headers.addAll({
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      });
      var response = await dio.request(url,
          data: data, options: Options(headers: headers, method: 'POST'));

      return ResultEntity(TaskResult.success, response.data);
    } catch (exception) {
      if (exception is DioError &&
          exception.error == "Http status error [401]") {
        return ResultEntity(TaskResult.tokenTimeout, exception.response?.data);
      }
      if (exception is DioError) {
        return ResultEntity(TaskResult.error, exception.response?.data);
      }
      return ResultEntity(TaskResult.error, {
        'messageCode': ErrorCode.MA013CE,
        'messageContent': ErrorCode.MA013CE.tr()
      });
    }
  }

  Future<ResultEntity<T>> uploadFile<T>(String url,
      {required Map<String, dynamic> param}) async {
    try {
      var formData = FormData.fromMap(param);
      var response = await dio.post(
        url,
        data: formData,
      );

      return ResultEntity(TaskResult.success, response.data);
    } catch (exception) {
      if (exception is DioError &&
          exception.error == "Http status error [401]") {
        return ResultEntity(TaskResult.tokenTimeout, exception.response?.data);
      }
      if (exception is DioError) {
        return ResultEntity(TaskResult.error, exception.response?.data);
      }
      return ResultEntity(TaskResult.error, {
        'messageCode': ErrorCode.MA013CE,
        'messageContent': ErrorCode.MA013CE.tr()
      });
    }
  }

  Future<ResultEntity<T>> put<T>(String url,
      {Map<String, String>? headers,
      required Map<String, dynamic> data}) async {
    try {
      headers ??= <String, String>{};
      headers.addAll({
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      });
      var response = await dio.request(url,
          data: data, options: Options(headers: headers, method: 'PUT'));

      return ResultEntity(TaskResult.success, response.data);
    } catch (exception) {
      if (exception is DioError &&
          exception.error == "Http status error [401]") {
        return ResultEntity(TaskResult.tokenTimeout, exception.response?.data);
      }
      if (exception is DioError) {
        return ResultEntity(TaskResult.error, exception.response?.data);
      }
      return ResultEntity(TaskResult.error, {
        'messageCode': ErrorCode.MA013CE,
        'messageContent': ErrorCode.MA013CE.tr()
      });
    }
  }

  Future<ResultEntity<T>> delete<T>(String url,
      {Map<String, String>? headers,
      required Map<String, dynamic> data}) async {
    try {
      headers ??= <String, String>{};
      headers.addAll({
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      });
      var response = await dio.request(url,
          data: data, options: Options(headers: headers, method: 'DELETE'));

      return ResultEntity(TaskResult.success, response.data);
    } catch (exception) {
      if (exception is DioError &&
          exception.error == "Http status error [401]") {
        return ResultEntity(TaskResult.tokenTimeout, exception.response?.data);
      }
      if (exception is DioError) {
        return ResultEntity(TaskResult.error, exception.response?.data);
      }
      return ResultEntity(TaskResult.error, {
        'messageCode': ErrorCode.MA013CE,
        'messageContent': ErrorCode.MA013CE.tr()
      });
    }
  }
}
