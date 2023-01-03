import 'dart:convert';

import 'package:equatable/equatable.dart';

typedef PaginatedModelFromMapConverter<T> = T Function(dynamic listOfTMap);

typedef PaginatedModelToMapConverter<T> = Map<String, dynamic> Function(
    T listTypeData);

class PaginatedDataModel<T> with EquatableMixin {
  final List<T> data;
  final int pageIndex;
  final int pageSize;
  final int totalCount;

  PaginatedDataModel({
    required this.data,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
  });

  factory PaginatedDataModel.fromMap(
      Map<String, dynamic> map, PaginatedModelFromMapConverter<T> converter) {
    return PaginatedDataModel<T>(
      data: List<T>.from(map['data']?.map((x) => converter(x))),
      pageIndex: map['pageIndex']?.toInt() ?? 0,
      pageSize: map['pageSize']?.toInt() ?? 0,
      totalCount: map['totalCount']?.toInt() ?? 0,
    );
  }

  String toJson(
    PaginatedModelToMapConverter<T> converter,
  ) =>
      json.encode(toMap(converter));

  factory PaginatedDataModel.fromJson(
          String source, PaginatedModelFromMapConverter<T> converter) =>
      PaginatedDataModel.fromMap(json.decode(source), converter);

  @override
  List<Object> get props => [data, pageIndex, pageSize, totalCount];

  PaginatedDataModel<T> copyWith({
    List<T>? data,
    int? pageIndex,
    int? pageSize,
    int? totalCount,
  }) {
    return PaginatedDataModel<T>(
      data: data ?? this.data,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  Map<String, dynamic> toMap(
    PaginatedModelToMapConverter<T> converter,
  ) {
    return {
      'data': data.map((x) => converter(x)).toList(),
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'totalCount': totalCount,
    };
  }

  @override
  String toString() {
    return 'PaginatedDataModel(data: $data, pageIndex: $pageIndex, pageSize: $pageSize, totalCount: $totalCount)';
  }
}
