import 'package:flutter/material.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/service/api_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiService = new ApiService();
  List<Canteen> _canteens = [];
  List<Canteen> _canteensToShow = [];

  @override
  void initState() {
    super.initState();

    _apiService.fetchCanteens().then((canteens) {
      _canteens = canteens;
      setState(() {
        _canteensToShow.addAll(_canteens);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Einstellungen"),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: new EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Suche...'),
              onChanged: _searchTextChanged,
            ),
          ),
          new Expanded(
              child: ListView(
            children: _canteensToShow.map((canteen) {
              return ListTile(title: Text(canteen.name));
            }).toList(),
          ))
        ]));
  }

  void _searchTextChanged(String searchText) {
    _canteensToShow.clear();
    searchText = searchText.toLowerCase();

    if (searchText.isEmpty) {
      setState(() {
        _canteensToShow.addAll(_canteens);
      });
    } else {
      var filteredCanteens = _canteens.where((canteen) {
        return canteen.name.toLowerCase().contains(searchText);
      });
      setState(() {
        _canteensToShow.addAll(filteredCanteens);
      });
    }
  }
}
