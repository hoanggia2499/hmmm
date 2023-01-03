import 'package:dartz/dartz.dart';

import '../../../../core/error/error_model.dart';

abstract class AboutDataSource {
  Future<Either<ReponseErrorModel, String>> getAbout();
}

// class AboutDataSourceImpl implements AboutDataSource {
//   AboutDataSourceImpl();
//
//   @override
//   Future<Either<ReponseErrorModel, String>> getAbout() async {
//    // return ;
//   }
// }
