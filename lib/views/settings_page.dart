import 'package:flutter/material.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/service/api_service.dart';
import 'package:openmensa/service/database_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiService = new ApiService();
  final DatabaseService db = new DatabaseService();

  final List<Canteen> _canteens = [];
  final List<Canteen> _canteensToShow = [];
  final List<Canteen> _favoriteCanteens = [];

  @override
  void initState() {
    super.initState();
    _apiService.fetchCanteens().then((canteens) {
      _canteens.addAll(canteens);
      setState(() {
        _canteensToShow.addAll(canteens);
      });
    });
    this._loadFavoriteCanteens();
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () => _clearAll(),
            ),
          ],
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
              child: ListView.builder(
                  itemCount: _canteensToShow.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_canteensToShow[index].name),
                      subtitle: Text(_canteensToShow[index].address),
                      trailing: _favoriteCanteenButton(_canteensToShow[index]),
                    );
                  }))
        ]));
  }

  IconButton _favoriteCanteenButton(Canteen canteen) {
    if (_favoriteCanteens.contains(canteen)) {
      return IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () => _removeCanteenFromFavorites(canteen));
    } else {
      return IconButton(
        icon: Icon(Icons.favorite),
        onPressed: () => _addCanteenToFavorites(canteen),
      );
    }
  }

  void _loadFavoriteCanteens() async {
    await db.setUpDb();
    List<Canteen> favoriteCanteens = await db.loadFavoriteCanteensFromDb();
    setState(() {
      _favoriteCanteens.addAll(favoriteCanteens);
    });
  }

  void _addCanteenToFavorites(Canteen canteen) {
    setState(() {
      _favoriteCanteens.add(canteen);
    });
    db.insertFavoriteCanteen(canteen);
  }

  void _removeCanteenFromFavorites(Canteen canteen) {
    setState(() {
      _favoriteCanteens.remove(canteen);
    });
    db.removeFavoriteCanteen(canteen);
  }

  void _clearAll() {
    setState(() {
      _favoriteCanteens.clear();
    });
    db.clearAll();
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
