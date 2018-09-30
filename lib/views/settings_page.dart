import 'dart:io';

import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/service/api_service.dart';
import 'package:path_provider/path_provider.dart' as path;

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiService = new ApiService();
  List<Canteen> _canteens = [];
  List<Canteen> _canteensToShow = [];
  List<Canteen> _favoriteCanteens = [];
  ObjectDB db;

  @override
  void initState() {
    super.initState();
    _apiService.fetchCanteens().then((canteens) {
      _canteens = canteens;
      setState(() {
        _canteensToShow.addAll(_canteens);
      });
    });
    this._setUpDb();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
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
              return _canteenTile(canteen);
            }).toList(),
          ))
        ]));
  }

  ListTile _canteenTile(Canteen canteen) {
    if (_favoriteCanteens.contains(canteen)) {
      return ListTile(
        title: Text(canteen.name),
        trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () => _removeCanteenFromFavorites(canteen)),
      );
    } else {
      return ListTile(
          title: Text(canteen.name),
          trailing: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => _addCanteenToFavorites(canteen),
          ));
    }
  }

  void _setUpDb() async {
    Directory appDocDir = await path.getApplicationDocumentsDirectory();
    String dbFilePath = [appDocDir.path, 'favorite_canteens.db'].join('/');
    db = ObjectDB(dbFilePath);
    db.open();
    this._loadFavoriteCanteensFromDb();
  }

  void _loadFavoriteCanteensFromDb() async {
    List favoriteCanteensAsMaps = await db.find({});
    List<Canteen> favoriteCanteens = favoriteCanteensAsMaps
        .map((CanteenAsMap) => Canteen.fromJson(CanteenAsMap))
        .toList();
    setState(() {
      _favoriteCanteens.addAll(favoriteCanteens);
    });
  }

  void _addCanteenToFavorites(Canteen canteen) {
    setState(() {
      _favoriteCanteens.add(canteen);
    });
    db.insert(canteen.toJson());
  }

  void _removeCanteenFromFavorites(Canteen canteen) {
    setState(() {
      _favoriteCanteens.remove(canteen);
    });
    db.remove(canteen.toJson());
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
