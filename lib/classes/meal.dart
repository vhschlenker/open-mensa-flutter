import 'dart:core';

import 'package:intl/intl.dart';
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

  String getPupilFormattedPricing() {
    var pupilPrice = prices['pupils'];
    if (pupilPrice != null) {
      return _getPriceFormatter().format(prices['pupils']);
    } else {
      return '-';
    }
  }

  String getStudentFormattedPricing() {
    var studentPrice = prices['students'];
    if (studentPrice != null) {
      return _getPriceFormatter().format(studentPrice);
    } else {
      return '-';
    }
  }

  String getEmployeesFormattedPricing() {
    var employeePrice = prices['employees'];
    if (employeePrice != null) {
      return _getPriceFormatter().format(employeePrice);
    } else {
      return '-';
    }
  }

  String getOthersFormattedPricing() {
    var otherPrice = prices['others'];
    if (otherPrice != null) {
      return _getPriceFormatter().format(otherPrice);
    } else {
      return '-';
    }
  }

  NumberFormat _getPriceFormatter() {
    return new NumberFormat.currency(locale: 'de_DE', name: 'EUR', symbol: '€');
  }

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}
