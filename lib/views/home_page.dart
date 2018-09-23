import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedDate = _dateChoices[0];

  void _selectDate(String dateChoice) {
    setState(() {
      _selectedDate = dateChoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: new Text('OpenMensa'), actions: <Widget>[
      new PopupMenuButton(
        child: new Padding(
          padding: new EdgeInsets.only(right: 24.0),
          child: new Center(
              child: new Text(
            _selectedDate,
            style: new TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
        onSelected: _selectDate,
        itemBuilder: (BuildContext context) {
          return _dateChoices.where((choice) {
            return choice != _selectedDate;
          }).map((String dateChoice) {
            return PopupMenuItem(value: dateChoice, child: Text(dateChoice));
          }).toList();
        },
      )
    ]));
  }
}

const List<String> _dateChoices = const <String>[
  'Heute (23.09)',
  'Morgen (24.09)',
  'Übermorgen (25.09)'
];
