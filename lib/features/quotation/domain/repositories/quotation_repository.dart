import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/quotation/data/models/inquiry_request_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import '../../../../core/error/error_model.dart';
import '../../../search_detail/data/models/search_car_input_model.dart';
import '../../../search_detail/data/models/search_car_model.dart';

abstract class QuotationRepository {
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> getSeachDetail(
      SearchCarInputModel searchCarInputModel);
  Future<Either<ReponseErrorModel, String>> getQuotation();
  Future<Either<ReponseErrorModel, String>> makeAnInquiry(
      InquiryRequestModel quotationRequest);
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getFavoriteList(
      String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> addFavorite(
      ItemSearchModel item, String tableName, String questionNo);
}
