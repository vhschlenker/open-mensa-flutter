import 'package:flutter/material.dart';
import 'package:openmensa/views/favorite_canteens_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Einstellungen"),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: Icon(Icons.restaurant),
                  title: Text("Kantinen"),
                  subtitle:
                      Text("Auswählen der Kantinen, die angezeigt werden"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteCanteensPage()),
                    );
                  },
                )),
          ],
        ));
  }
}
