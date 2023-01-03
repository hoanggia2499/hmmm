import 'package:dio/dio.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/refresh_model.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import '../task_type.dart';

class RefreshTokenInterceptor extends Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Check to add token on request
    if (mustHaveToken(options.uri.path.toLowerCase())) {
      var accessToken = await UserSecureStorage.instance.getAccessToken() ?? '';
      if (accessToken != '') {
        options.headers.addAll({"Authorization": "Bearer $accessToken"});
      }
    }

    // progress continue
    return handler.next(options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    var response = err.response;

    if (response!.statusCode == 401) {
      var json = response.data as Map<String, dynamic>?;
      if (json != null && json.containsKey('messageCode')) {
        if (json['messageCode'] == '5MA001SE') {
          var resultData = await callRefresh(response);
          if (resultData == null) {
            // Refresh OK
            return handler.resolve(await BaseDio.instance.dio.request(
                response.requestOptions.path,
                cancelToken: response.requestOptions.cancelToken,
                data: response.requestOptions.data,
                onReceiveProgress: response.requestOptions.onReceiveProgress,
                onSendProgress: response.requestOptions.onSendProgress,
                options: Options(method: response.requestOptions.method)));
          } else {
            // Refresh expired
            return handler.reject(DioError(
                requestOptions: response.requestOptions,
                type: DioErrorType.other,
                response: Response(
                    requestOptions: response.requestOptions,
                    statusCode: 401,
                    data: resultData),
                error: 'Http status error [401]'));
          }
        }
      }
    }
    if (response.requestOptions.path.toLowerCase().contains('refreshtoken')) {
      return handler.next(err);
    }
    return super.onError(err, handler);
  }

  Future<Map<String, dynamic>?> callRefresh(Response? response) async {
    var refreshAPI = '${Common.appUrl}/RefreshToken';
    var reqHeaders = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String accessToken =
        await UserSecureStorage.instance.getAccessToken() ?? '';
    String refreshToken =
        await UserSecureStorage.instance.getRefreshToken() ?? '';
    var params = {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
    var response = await BaseDio.instance
        .post<RefreshModel>(refreshAPI, headers: reqHeaders, data: params);
    switch (response.result) {
      case TaskResult.success:
        if (response.data != null) {
          await HelperFunction.instance.removeJwt();
          await HelperFunction.instance
              .saveJwt(response.data!.accessToken, response.data!.refreshToken);
        }
        // get new token ok
        return null;
      default:
        await HelperFunction.instance.removeJwt();
        await HelperFunction.instance.removeLoginModel();
        return {
          'data': response.data,
          'messageCode': response.messageCode,
          'messageContent': response.messageContent
        };
    }
  }

  bool mustHaveToken(String url) {
    for (var item in nonTokenList) {
      if (url.toLowerCase().contains(item)) {
        return false;
      }
    }
    return true;
  }

  final List<String> nonTokenList = [
    'login',
    'refreshtoken',
    'requestpretreatment',
    'userauthentication',
    'requestregister',
    'personalregister'
  ];
}
