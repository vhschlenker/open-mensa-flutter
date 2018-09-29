// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canteen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Canteen _$CanteenFromJson(Map<String, dynamic> json) {
  return Canteen(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      coordinates: (json['coordinates'] as List)
          ?.map((e) => (e as num)?.toDouble())
          ?.toList());
}

Map<String, dynamic> _$CanteenToJson(Canteen instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'coordinates': instance.coordinates
    };
