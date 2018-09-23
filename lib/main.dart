import 'package:flutter/material.dart';
import 'package:openmensa/views/home_page.dart';

void main() => runApp(new OpenMensaApp());

class OpenMensaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OpenMensa',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}
