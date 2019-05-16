import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:geoworkerv4/models/Stats.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel('vida.software/geoworkerv4');
  List<Stats> _stats = new List<Stats>();

  String _responseFromNativeCode = "";

  Future<void> responseFromNativeCode () async {
    String response = "";
    try {
      await platform.invokeMethod('startGeoWorker', {"threads": 5});
      response = "DONE";
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }

    setState(() {
      _responseFromNativeCode = response;
    });
  }

  Future<void> getStats () async {
    try {
      Iterable response = await platform.invokeMethod("getStats");
      setState(() {
        _stats = response.map((x) => Stats.fromMap(x)).toList();
      });
    } on PlatformException catch (e) {
      print("ERROR");
      print(e);
    }
  }

  Future<void> showStats () async {
    _stats.forEach((stat) {
      print("-----");
      print(stat.identifier);
      print(stat.successfullyCompleted);
      print(stat.completedWithErrors);
      print(stat.totalSuccessfullyCompleted + stat.successfullyCompleted);
      print(stat.totalCompletedWithErrors + stat.completedWithErrors);
      print("-----");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Init transport'),
              onPressed: responseFromNativeCode,
            ),
            RaisedButton(
              child: Text('Get stats'),
              onPressed: getStats,
            ),
            RaisedButton(
              child: Text('Show stats'),
              onPressed: showStats,
            ),
            Text(_responseFromNativeCode),
          ],
        ),
      ),
    );
  }
}
