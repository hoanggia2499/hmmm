import 'package:dio/dio.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/interceptors/log_interceptor.dart';
import 'package:mirukuru/core/network/interceptors/refresh_interceptor.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/features/login/data/datasources/login_remote_data_source.dart';
import 'package:mirukuru/features/login/domain/repositories/login_repository.dart';
import 'package:mirukuru/features/login/domain/usecases/check_user_available.dart';
import 'package:mirukuru/features/login/domain/usecases/post_login.dart';
import 'package:mirukuru/features/login/domain/usecases/post_push_id.dart';
import 'package:mirukuru/features/new_user_registration/data/datasources/user_registration_remote_data_source.dart';
import 'package:mirukuru/features/new_user_registration/domain/repositories/user_registration_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  /// Login page
  LoginRepository,
  LoginDataSource,
  PostLogin,

  /// User registration
  UserRegistrationRepository,
  UserRegistrationDataSource,

  ///  Base
  Dio,
  DefaultLogInterceptor,
  RefreshTokenInterceptor,
  CheckUserAvailable,
  InternetConnection,
  RequestOptions,
  RequestInterceptorHandler,
  PostPushId,
], customMocks: [
  MockSpec<BaseDio>(as: #MockBaseDio)
])
void main() {}

/// to generate mock, run at terminal -> flutter pub run build_runner build
/// when error -> flutter packages pub run build_runner build --delete-conflicting-outputs
