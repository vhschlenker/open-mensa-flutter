import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:openmensa/classes/meal.dart';
import 'package:openmensa/service/api_service.dart';
import 'package:openmensa/service/database_service.dart';
import 'package:openmensa/views/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final DatabaseService db = new DatabaseService();
  final _apiService = new ApiService();

  final List<Canteen> _canteens = [];
  final List<String> _dateChoices = [];
  final List<Meal> _displayedMeals = [];

  String _selectedDate = '';
  TabController _canteenTabController;

  @override
  void initState() {
    super.initState();
    _dateChoices.addAll(_createDateChoices());
    _selectedDate = _dateChoices[0];
    _canteenTabController =
        new TabController(vsync: this, length: _canteens.length);
    _canteenTabController.addListener(_fetchMeals);
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
          return ListView.separated(
              itemCount: _displayedMeals.length,
              separatorBuilder: (BuildContext context, int index) =>
                  new Divider(),
              itemBuilder: (BuildContext context, int index) {
                return _createMealsListTile(_displayedMeals[index]);
              });
        }).toList(),
      ),
    );
  }

  void _fetchMeals() async {
    var _selectedCanteen = _canteens[_canteenTabController.index];
    var displayedMeals = await _apiService.fetchMeals(
        _selectedCanteen.id.toString(), _selectedDate);
    _displayedMeals.clear();
    setState(() {
      _displayedMeals.addAll(displayedMeals);
    });
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
      _canteenTabController.addListener(_fetchMeals);
    });
    _fetchMeals();
  }

  void _selectDate(String dateChoice) {
    setState(() {
      _selectedDate = dateChoice;
    });
    _fetchMeals();
  }

  List<String> _createDateChoices() {
    final aDay = new Duration(days: 1);
    var now = new DateTime.now();
    var tomorrow = now.add(aDay);
    var dayAfterTomorrow = tomorrow.add(aDay);
    var formatter = new DateFormat('yyyy-MM-dd');
    return [
      formatter.format(now),
      formatter.format(tomorrow),
      formatter.format(dayAfterTomorrow)
    ];
  }
}
