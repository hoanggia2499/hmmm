import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/result_entity.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/new_user_registration/data/datasources/user_registration_remote_data_source.dart';
import 'package:mirukuru/features/new_user_registration/data/models/user_registration_model.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserRegistrationDataSourceImpl? userRegistrationDataSourceImpl;
  late MockBaseDio mockBaseDio;
  // late FlutterDriver driver;

  String url = Common.apiPostPretreatment;
  final int id = 196;
  final String telRight = "0708654321";
  final String telWrong = "090876543215";
  final String userNameRight = 'oke';
  final String userNameWrong = 'oke';
  final String userNameKanaRight = 'oke';
  final String userNameKanaWrong = 'oke';
  final String hostUrl = "http://192.168.200.114:8888/MirukuruApi";
  setUp(() async {
    // driver = await FlutterDriver.connect();
    BaseDio(hostUrl: hostUrl);
    mockBaseDio = MockBaseDio();
    userRegistrationDataSourceImpl =
        UserRegistrationDataSourceImpl(client: mockBaseDio);
  });

  void setUpMockBaseDioSuccess() {
    when(
        mockBaseDio.request<UserRegistrationModel>(url, MethodType.POST, data: {
      'id': id,
      'tel': telRight,
      // 'userName': userNameRight,
      // 'userNameKana': userNameKanaRight,
    })).thenAnswer((_) async => ResultEntity(TaskResult.success, {}));
  }

  void setUpMockBaseDioFail() {
    when(
        mockBaseDio.request<UserRegistrationModel>(url, MethodType.POST, data: {
      'id': id,
      'tel': telWrong,
      // 'userName': userNameWrong,
      // 'userNameKana': userNameKanaWrong,
    })).thenAnswer((_) async => ResultEntity(TaskResult.error, {}));
  }

  group('post UserRegistrationModel remote data source', () {
    // final loginModel = LoginModel(
    //     accessToken: '', refreshToken: '', memberNum: "33333333", userNum: 5);

    test('return response success', () async {
      setUpMockBaseDioSuccess();
      final result = await userRegistrationDataSourceImpl!.requestPretreatment(
        id,
        telRight,
        // userNameRight,
        // userNameWrong,
      );
      expect(result!.isExists, false);
    });

    test('return response fail', () async {
      setUpMockBaseDioFail();
      final result = userRegistrationDataSourceImpl!.requestPretreatment;
      expect(
          () => result(
                id,
                telWrong,
                // userNameWrong,
                // userNameKanaWrong,
              ),
          throwsA(isA<ServerException>()));
    });
  });
}
