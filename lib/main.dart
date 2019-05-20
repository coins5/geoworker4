import 'package:flutter/material.dart';
import 'package:geoworkerv4/pages/GeoworkerPage.dart';
import 'package:geoworkerv4/pages/ConfigPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        fontFamily: 'Raleway'
      ),
      home: new ConfigPage(),// new GeoworkerPage(title: 'Geoworker', threads: 6, server: 'http://192.168.0.175:2193',),
      /*
      home: new ConfigPage(),
      routes: <String, WidgetBuilder> {
        'GEOWORKER': (BuildContext context) => new GeoworkerPage(title: 'Geoworker'),
      },
      */
    );
  }
}

