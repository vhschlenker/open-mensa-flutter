import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/classes/meal.dart';

class ApiService {
  final String _endpoint = 'http://openmensa.org/api/v2';

  Future<List<Canteen>> fetchCanteens() async {
    List<Canteen> returnList = [];
    final response = await http.get(_endpoint + '/canteens');
    final pages = int.parse(response.headers['x-total-pages']);
    List jsonDecoded = json.decode(response.body);
    returnList.addAll(
        jsonDecoded.map((canteen) => Canteen.fromJson(canteen)).toList());
    for (int i = 2; i <= pages; i++) {
      final response =
          await http.get(_endpoint + '/canteens?page=' + i.toString());
      List jsonDecoded = json.decode(response.body);
      returnList.addAll(
          jsonDecoded.map((canteen) => Canteen.fromJson(canteen)).toList());
    }
    return returnList;
  }

  Future<List<Meal>> fetchMeals(String canteenId, DateTime dayDate) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    final response = await http.get(_endpoint +
        '/canteens/' +
        canteenId +
        '/days/' +
        formatter.format(dayDate) +
        '/meals');
    if (response.statusCode == 404) {
      return [];
    }
    List jsonDecoded = json.decode(response.body);
    return jsonDecoded.map((meal) => Meal.fromJson(meal)).toList();
  }
}
