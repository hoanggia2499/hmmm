import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/features/login/data/datasources/login_remote_data_source.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/login/domain/usecases/post_login.dart';
import 'package:mirukuru/features/login/presentation/bloc/login_bloc.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginBloc bloc;
  late MockPostLogin mockPostLogin;
  late MockCheckUserAvailable mockCheckUserAvailable;
  late MockPostPushId mockPostPushId;
  late LoginDataSourceImpl loginDataSourceImpl;
  late MockBaseDio mockBaseDio;
  late MockLoginDataSource mockLoginDataSource;
  late MockLoginRepository mockLoginRepository;
  String url = Common.apiLogin;
  final int id = 196;
  final String passwordRight = "0908654321";
  final String passwordWrong = "09087654321";
  final String appVersion = "1.0.0";
  final String hostUrl = "http://192.168.200.114:8888/MirukuruApi";
  setUp(() {
    mockPostLogin = MockPostLogin();
    mockBaseDio = MockBaseDio();
    mockLoginDataSource = MockLoginDataSource();
    mockCheckUserAvailable = MockCheckUserAvailable();
    mockPostPushId = MockPostPushId();
    mockLoginRepository = MockLoginRepository();
    loginDataSourceImpl = LoginDataSourceImpl(
        client: BaseDio(hostUrl: hostUrl, defaultTimeOut: 15000));
    bloc = LoginBloc(mockPostLogin, mockCheckUserAvailable, mockPostPushId);
  });

  group('post login bloc', () {
    final loginModel = LoginModel(
        accessToken: "",
        refreshToken: "",
        memberNum: "33333333",
        userNum: 5,
        tel: "8888008248",
        storeName: "８２４８モータース",
        storeName2: "テスト３３３３",
        logoMark: "company_logo_20221202_125902.png");

    test('has a correct initialState', () {
      expect(bloc.state, Empty());
    });
    blocTest<LoginBloc, LoginState>(
      'emit Loading and Completed state',
      build: () {
        when(mockPostLogin.call(
                ParamLogin(id: id, apVersion: appVersion, pass: passwordRight)))
            .thenThrow('Weather Error');
        return LoginBloc(mockPostLogin, mockCheckUserAvailable, mockPostPushId);
      },
      act: (bloc) {
        bloc.add(LoginSubmitted(id.toString(), passwordRight));
      },
      expect: () => <LoginState>[
        Loading(),
        Error(messageCode: '5MA013CE', messageContent: '5MA013CE')
      ],
    );
  });
}
