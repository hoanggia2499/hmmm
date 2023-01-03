// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyModel _$BodyModelFromJson(Map<String, dynamic> json) => BodyModel(
      makerName: json['makerName'] as String? ?? '',
      makerCode: json['makerCode'] as String? ?? '',
      carGroup: json['carGroup'] as String? ?? '',
      asnetCarCode: json['asnetCarCode'] as int? ?? 0,
      numOfCarASOne: json['numOfCarASOne'] as int? ?? 0,
    );

Map<String, dynamic> _$BodyModelToJson(BodyModel instance) => <String, dynamic>{
      'makerCode': instance.makerCode,
      'makerName': instance.makerName,
      'carGroup': instance.carGroup,
      'asnetCarCode': instance.asnetCarCode,
      'numOfCarASOne': instance.numOfCarASOne,
    };
