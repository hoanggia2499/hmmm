import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/login/domain/usecases/post_login.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late PostLogin usecase;
  late MockLoginRepository mockLoginRepository;
  final int id = 196;
  final String passwordRight = "0908654321";
  final String passwordWrong = "09087654321";
  final String appVersion = "1.0.0";

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = PostLogin(mockLoginRepository);
  });
  final loginModel = LoginModel();
  final reponseErrorModel = ReponseErrorModel();
  test('Should post login from the repository success', () async {
    //arrange
    when(mockLoginRepository.login(id, passwordRight, appVersion))
        .thenAnswer((_) async => Right(loginModel));
    //act
    final result = await usecase(ParamLogin(
      id: id,
      pass: passwordRight,
      apVersion: appVersion,
    ));
    //assert
    expect(result, Right(loginModel));
    verify(mockLoginRepository.login(id, passwordRight, appVersion));
  });
  test('Should post login from the repository fail', () async {
    //arrange
    when(mockLoginRepository.login(id, passwordWrong, appVersion))
        .thenAnswer((_) async => Left(reponseErrorModel));
    //act
    final result = await usecase(ParamLogin(
      id: id,
      pass: passwordWrong,
      apVersion: appVersion,
    ));
    //assert
    expect(result, Left(reponseErrorModel));
    verify(mockLoginRepository.login(id, passwordWrong, appVersion));
  });
}
