import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/result_entity.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/login/data/datasources/login_remote_data_source.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  LoginDataSourceImpl? loginDataSourceImpl;
  late MockBaseDio mockBaseDio;
  String url = Common.apiLogin;
  final int id = 196;
  final String passwordRight = "0908654321";
  final String passwordWrong = "09087654321";
  final String appVersion = "1.0.0";
  final String hostUrl = "http://192.168.200.114:8888/MirukuruApi";
  setUp(() {
    BaseDio(hostUrl: hostUrl);
    mockBaseDio = MockBaseDio();
    loginDataSourceImpl = LoginDataSourceImpl(client: mockBaseDio);
  });

  void setUpMockBaseDioSuccess() {
    when(mockBaseDio.request<LoginModel>(url, MethodType.GET,
            data: {'id': id, 'pass': passwordRight, 'appVersion': appVersion}))
        .thenAnswer((_) async => ResultEntity(TaskResult.success, {}));
  }

  void setUpMockBaseDioFail() {
    when(mockBaseDio.request<LoginModel>(url, MethodType.GET,
            data: {'id': id, 'pass': passwordWrong, 'appVersion': appVersion}))
        .thenAnswer((_) async => ResultEntity(TaskResult.error, {}));
  }

  group('post login remote data source', () {
    final loginModel = LoginModel(
        accessToken: '', refreshToken: '', memberNum: "33333333", userNum: 5);

    test('return response success', () async {
      setUpMockBaseDioSuccess();
      final result =
          await loginDataSourceImpl!.appLogin(id, passwordRight, appVersion);
      expect(result!.userNum, loginModel.userNum);
    });

    test('return response fail', () async {
      setUpMockBaseDioFail();
      final result = loginDataSourceImpl!.appLogin;
      expect(() => result(id, passwordWrong, appVersion),
          throwsA(isA<ServerException>()));
    });
  });
}
