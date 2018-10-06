import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/classes/meal.dart';
import 'package:openmensa/service/api_service.dart';
import 'package:openmensa/service/database_service.dart';
import 'package:openmensa/views/settings_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final DatabaseService db = new DatabaseService();
  final _apiService = new ApiService();

  final List<Canteen> _canteens = [];
  final List<DateTime> _dateChoices = [];
  final List<Meal> _displayedMeals = [];

  DateTime _selectedDate = DateTime.now();
  TabController _canteenTabController;
  bool _loading = true;
  StreamSubscription<List> _mealSub;

  @override
  void initState() {
    super.initState();
    _dateChoices.addAll(_createDateChoices(7));
    _selectedDate = _dateChoices[0];
    _canteenTabController =
        new TabController(vsync: this, length: _canteens.length);
    _canteenTabController.addListener(() {
      if (_canteenTabController.indexIsChanging) {
        _fetchMeals();
      }
    });
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
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    var _selectedCanteen =
                        _canteens[_canteenTabController.index];
                    return new AlertDialog(
                      title: Text(_selectedCanteen.name),
                      contentPadding:
                          const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0),
                      content: new Text(_selectedCanteen.address),
                      actions: <Widget>[
                        new FlatButton(
                            child: new Text('Auf OpenStreetMap öffnen'),
                            onPressed: () => _launchCanteenPositionURL(
                                _selectedCanteen.coordinates)),
                        new FlatButton(
                          child: new Text('Schließen'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
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
          return _createMealsView(canteen);
        }).toList(),
      ),
    );
  }

  void _launchCanteenPositionURL(List<double> coordinates) async {
    var url = 'https://www.openstreetmap.org/?mlat=' +
        coordinates[0].toString() +
        '&mlon=' +
        coordinates[1].toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _fetchMeals() async {
    setState(() {
      _loading = true;
    });
    _mealSub?.cancel();
    var _selectedCanteen = _canteens[_canteenTabController.index];
    _mealSub = _apiService
        .fetchMeals(_selectedCanteen.id.toString(), _selectedDate)
        .asStream()
        .listen((List<Meal> displayedMeals) {
      _displayedMeals.clear();
      _displayedMeals.addAll(displayedMeals);
      setState(() {
        _loading = false;
      });
    });
  }

  Widget _createMealsView(Canteen canteen) {
    if (_displayedMeals.isNotEmpty && !_loading) {
      return ListView.separated(
          itemCount: _displayedMeals.length,
          separatorBuilder: (BuildContext context, int index) => new Divider(),
          itemBuilder: (BuildContext context, int index) {
            return _createMealsListTile(_displayedMeals[index]);
          });
    } else if (_loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: const CircularProgressIndicator()),
          RaisedButton.icon(
            onPressed: _fetchMeals,
            icon: Icon(Icons.refresh),
            label: const Text('Neu laden'),
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).accentTextTheme.button.color,
          )
        ],
      );
    } else {
      return const Center(
          child: const Text("Keine Gerichte für den gewählten Tag gefunden"));
    }
  }

  ListTile _createMealsListTile(Meal meal) {
    return ListTile(
      title: Text(meal.name),
      subtitle: Text(meal.category),
      trailing: Column(
        children: <Widget>[
          Text(meal.getPupilFormattedPricing()),
          Text(meal.getStudentFormattedPricing()),
          Text(meal.getEmployeesFormattedPricing()),
          Text(meal.getOthersFormattedPricing())
        ],
      ),
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return new SimpleDialog(
                title: const Text('Notes'),
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 12.0, 0.0, 16.0),
                children: meal.notes.map((note) => Text(note)).toList());
          }),
    );
  }

  PopupMenuButton _createDateSelector() {
    return PopupMenuButton(
      child: new Padding(
        padding: new EdgeInsets.only(right: 24.0),
        child: new Center(
            child: new Text(
          _getFormattedDateTime(_selectedDate),
          style: new TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      onSelected: (selectedDate) => _selectDate(selectedDate),
      itemBuilder: (BuildContext context) {
        return _dateChoices.where((choice) {
          return choice != _selectedDate;
        }).map((dateChoice) {
          return PopupMenuItem(
              value: dateChoice,
              child: Text(_getFormattedDateTime(dateChoice)));
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
      _canteenTabController.addListener(() {
        if (_canteenTabController.indexIsChanging) {
          _fetchMeals();
        }
      });
    });
    _fetchMeals();
  }

  void _selectDate(DateTime dateChoice) {
    setState(() {
      _selectedDate = dateChoice;
    });
    _fetchMeals();
  }

  String _getFormattedDateTime(DateTime dateTime) {
    var formatter = new DateFormat('E dd.MM');
    return formatter.format(dateTime);
  }

  List<DateTime> _createDateChoices(int length) {
    final now = DateTime.now();
    List<DateTime> returnList = [];
    for (int i = 0; i < length; i++) {
      returnList.add(now.add(Duration(days: i)));
    }
    return returnList;
  }
}
