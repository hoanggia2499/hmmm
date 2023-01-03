import 'package:dartz/dartz.dart';

import '../../../../core/error/error_model.dart';

abstract class AboutRepository {
  Future<Either<ReponseErrorModel, String>> getAbout();
}
