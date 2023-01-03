import 'dart:convert';

class PaginatedDataRequestModel {
  int pageIndex;
  int pageSize;

  PaginatedDataRequestModel({
    required this.pageIndex,
    required this.pageSize,
  });

  PaginatedDataRequestModel copyWith({
    int? pageIndex,
    int? pageSize,
  }) {
    return PaginatedDataRequestModel(
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  Map<String, dynamic> toMap() {
    return {'page': pageIndex, 'per_page': pageSize};
  }

  factory PaginatedDataRequestModel.fromMap(Map<String, dynamic> map) {
    return PaginatedDataRequestModel(
      pageIndex: map['page']?.toInt() ?? 0,
      pageSize: map['per_page']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginatedDataRequestModel.fromJson(String source) =>
      PaginatedDataRequestModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PaginatedDataRequestModel(pageIndex: $pageIndex, pageSize: $pageSize)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginatedDataRequestModel &&
        other.pageIndex == pageIndex &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode => pageIndex.hashCode ^ pageSize.hashCode;
}
