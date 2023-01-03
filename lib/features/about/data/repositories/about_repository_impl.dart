import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/features/about/data/datasources/about_remote_data_source.dart';
import 'package:mirukuru/features/about/domain/repositories/about_repository.dart';
import '../../../../core/error/error_model.dart';

class AboutRepositoryImpl implements AboutRepository {
  final AboutDataSource aboutDataSource;

  AboutRepositoryImpl({required this.aboutDataSource});

  @override
  Future<Either<ReponseErrorModel, String>> getAbout() async {
    if (await InternetConnection.instance.isHasConnection()) {
      return await aboutDataSource.getAbout();
    } else {
      return Left(ReponseErrorModel(msgCode: '', msgContent: ''));
    }
  }
}
