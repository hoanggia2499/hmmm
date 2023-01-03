import 'package:dartz/dartz.dart';

import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';

mixin PaginatedDataBlocMixin<T> {
  List<T> data = [];
  int loadPageIndex = 1;
  int totalCount = 0;
  int pageSize = kDefaultPageSize;

  Future<Either<ReponseErrorModel, PaginatedDataModel<T>>> loadData(
      {required int loadPageIndex, required int pageSize});

  bool get hasMoreData =>
      (data.length == 0 && loadPageIndex == 1) || data.length < totalCount;

  static const kDefaultPageSize = 10;

  set setData(List<T> data) => this.data = data;

  void updatePaginatedDataParams(List<T> nextPageData, int totalItemsCount) {
    data.addAll(nextPageData);
    totalCount = totalItemsCount;
    if (_isValidPage(loadPageIndex)) {
      loadPageIndex = loadPageIndex + 1;
    }
  }

  void resetPaginatedDataParams() {
    data.clear();
    totalCount = 0;
    loadPageIndex = 1;
  }

  bool _isValidPage(int loadPageIndex) {
    return loadPageIndex < (totalCount / pageSize).ceil();
  }
}
