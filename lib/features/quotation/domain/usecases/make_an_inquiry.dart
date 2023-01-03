import 'package:dartz/dartz.dart';

import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/quotation/data/models/inquiry_request_model.dart';
import 'package:mirukuru/features/quotation/domain/repositories/quotation_repository.dart';

class MakeAnInquiry extends UseCaseExtend<String, InquiryRequestModel> {
  final QuotationRepository repository;

  MakeAnInquiry({
    required this.repository,
  });

  @override
  Future<Either<ReponseErrorModel, String>> call(InquiryRequestModel params) {
    return repository.makeAnInquiry(params);
  }
}
