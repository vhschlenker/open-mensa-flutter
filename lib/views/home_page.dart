import 'package:flutter/material.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/service/database_service.dart';
import 'package:openmensa/views/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String _selectedDate = _dateChoices[0];
  List<Canteen> _canteens = [];
  DatabaseService db = new DatabaseService();
  TabController _canteenTabController;

  @override
  void initState() {
    super.initState();
    _canteenTabController =
        new TabController(vsync: this, length: _canteens.length);
    this._loadFavoriteCanteens();
  }

  @override
  void dispose() {
    _canteenTabController.dispose();
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('OpenMensa'),
        actions: <Widget>[
          _createDateSelector(),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _navigateSettingsScreen(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _canteenTabController,
          tabs: _canteens.map((canteen) {
            return Tab(text: canteen.name);
          }).toList(),
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _canteenTabController,
        children: _canteens.map((canteen) {
          return Center(child: Text(canteen.name));
        }).toList(),
      ),
    );
  }

  PopupMenuButton _createDateSelector() {
    return PopupMenuButton(
      child: new Padding(
        padding: new EdgeInsets.only(right: 24.0),
        child: new Center(
            child: new Text(
          _selectedDate,
          style: new TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      onSelected: (selectedDate) => _selectDate(selectedDate),
      itemBuilder: (BuildContext context) {
        return _dateChoices.where((choice) {
          return choice != _selectedDate;
        }).map((String dateChoice) {
          return PopupMenuItem(value: dateChoice, child: Text(dateChoice));
        }).toList();
      },
    );
  }

  void _navigateSettingsScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
    _loadFavoriteCanteens();
  }

  void _loadFavoriteCanteens() async {
    await db.setUpDb();
    List<Canteen> favoriteCanteens = await db.loadFavoriteCanteensFromDb();
    _canteens.clear();
    _canteens.addAll(favoriteCanteens);
    setState(() {
      _canteenTabController =
          new TabController(vsync: this, length: _canteens.length);
    });
  }

  void _selectDate(String dateChoice) {
    setState(() {
      _selectedDate = dateChoice;
    });
  }
}

const List<String> _dateChoices = const <String>[
  'Heute (23.09)',
  'Morgen (24.09)',
  'Übermorgen (25.09)'
];
