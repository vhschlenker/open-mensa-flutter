import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  final int id;
  final String name;
  final List<String> notes;
  final Map<String, double> prices;
  final String category;

  Meal({this.id, this.name, this.notes, this.prices, this.category});

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}
