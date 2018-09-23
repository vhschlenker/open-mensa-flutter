import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openmensa/classes/canteen.dart';

class ApiService {
  final String _endpoint = 'http://openmensa.org/api/v2';

  Future<List<Canteen>> fetchCanteens() async {
    final response = await http.get(_endpoint + '/canteens');
    List jsonDecoded = json.decode(response.body);
    return jsonDecoded.map((canteen) => Canteen.fromJson(canteen)).toList();
  }
}
