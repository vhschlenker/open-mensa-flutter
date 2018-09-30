import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'canteen.g.dart';

@JsonSerializable()
class Canteen {
  final int id;
  final String name, address;
  @JsonKey(nullable: true)
  final List<double> coordinates;

  Canteen({this.id, this.name, this.address, this.coordinates});

  factory Canteen.fromJson(Map<String, dynamic> json) =>
      _$CanteenFromJson(json);
  Map<String, dynamic> toJson() => _$CanteenToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Canteen &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address &&
          DeepCollectionEquality().equals(coordinates, other.coordinates);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ address.hashCode ^ coordinates.hashCode;
}
