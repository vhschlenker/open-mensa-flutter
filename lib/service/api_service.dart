import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openmensa/classes/canteen.dart';

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
}
