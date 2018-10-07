import 'package:flutter/material.dart';
import 'package:openmensa/classes/price_types.dart';
import 'package:openmensa/views/favorite_canteens_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: Icon(Icons.view_list),
                  title: Text("Preise"),
                  subtitle: Text("Auswählen der Preise, die angezeigt werden"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PriceSettingDialog();
                        });
                  },
                )),
          ],
        ));
  }
}

class PriceSettingDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PriceSettingDialogState();
}

class _PriceSettingDialogState extends State<PriceSettingDialog> {
  SharedPreferences _prefs;
  bool _showPupilPrices;
  bool _showStudentPrices;
  bool _showEmployeesPrices;
  bool _showOtherPrices;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      _prefs = sharedPreferences;
      _showPupilPrices = _prefs.getBool(PriceTypes.pupil) ?? true;
      _showStudentPrices = _prefs.getBool(PriceTypes.student) ?? true;
      _showEmployeesPrices = _prefs.getBool(PriceTypes.employees) ?? true;
      _showOtherPrices = _prefs.getBool(PriceTypes.other) ?? true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: Text("Preise zum anzeigen auswählen"),
      children: <Widget>[
        CheckboxListTile(
          title: const Text('Schüler'),
          value: _showPupilPrices ?? true,
          onChanged: (bool value) {
            _prefs?.setBool(PriceTypes.pupil, value);
            setState(() {
              _showPupilPrices = value;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Studenten'),
          value: _showStudentPrices ?? true,
          onChanged: (bool value) {
            _prefs?.setBool(PriceTypes.student, value);
            setState(() {
              _showStudentPrices = value;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Angestellte'),
          value: _showEmployeesPrices ?? true,
          onChanged: (bool value) {
            _prefs?.setBool(PriceTypes.employees, value);
            setState(() {
              _showEmployeesPrices = value;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Andere'),
          value: _showOtherPrices ?? true,
          onChanged: (bool value) {
            _prefs?.setBool(PriceTypes.other, value);
            setState(() {
              _showOtherPrices = value;
            });
          },
        )
      ],
    );
  }
}
