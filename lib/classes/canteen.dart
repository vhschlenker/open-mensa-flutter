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
}
