import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/features/login/data/datasources/login_remote_data_source.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginDataSourceImpl loginDataSourceImpl;
  late MockLoginDataSource mockLoginDataSource;
  late MockInternetConnection mockInternetConnection;
  final int id = 196;
  final String passwordRight = "0908654321";
  final String passwordWrong = "090872654321";
  final String appVersion = "1.0.0";
  final String hostUrl = 'http://192.168.200.114:8888/MirukuruApi';
  setUp(() {
    mockLoginDataSource = MockLoginDataSource();
    mockInternetConnection = MockInternetConnection();
    loginDataSourceImpl = LoginDataSourceImpl(
        client: BaseDio(hostUrl: hostUrl, defaultTimeOut: 15000));
  });

  void runTestOnline(Function body) {
    group('test internet connection', () {
      setUp(() {
        when(mockInternetConnection.isHasConnection())
            .thenAnswer((_) async => true);
      });
      body();
    });
  }

  group('post login', () {
    final loginModel = LoginModel(memberNum: '33333333', userNum: 5);
    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockLoginDataSource.appLogin(id, passwordRight, appVersion))
              .thenAnswer((_) async => loginModel);
          // act
          final result =
              await loginDataSourceImpl.appLogin(id, passwordRight, appVersion);
          // assert
          expect(result!.memberNum, loginModel.memberNum);
        },
      );
      test(
        'should return remote data when the call to remote data source is fail',
        () async {
          // arrange
          when(mockLoginDataSource.appLogin(id, passwordWrong, appVersion))
              .thenThrow(ServerException('', ''));
          // act
          final result = loginDataSourceImpl.appLogin;
          // assert
          expect(() => result(id, passwordWrong, appVersion),
              throwsA(isA<ServerException>()));
        },
      );
    });
  });
}
