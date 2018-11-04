import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:openmensa/colors.dart';
import 'package:openmensa/views/home_page.dart';

void main() => runApp(new OpenMensaApp());

class OpenMensaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primaryColor: primaryColor,
              accentColor: accentColor,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'OpenMensa',
            theme: theme,
            home: new HomePage(),
          );
        });
  }
}
