import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:geoworkerv4/models/Stats.dart';
import 'package:geoworkerv4/utils/Geoworker.dart';
import 'package:geoworkerv4/widgets/TransportStats.dart';
import 'package:geoworkerv4/widgets/TransportsOverview.dart';

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
      home: new MyHomePage(title: 'Geoworker'),
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
  /*
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
  */
  static const platform = const MethodChannel('vida.software/geoworkerv4');
  List<Stats> _stats = new List<Stats>();
  bool _isOverview = false;

  @override
  void initState() {
    super.initState();
    startTransport();
  }


  Future<void> startTransport () async {
    try {
      await platform.invokeMethod('startGeoWorker', {"threads": 5});
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> getStats() async {
    try {
      Iterable response = await platform.invokeMethod("getStats");
      setState(() {
        _stats = response.map((x) => Stats.fromMap(x)).toList();
      });
    } on PlatformException catch (e) {
      print("ERROR ON GET STATS");
      print(e);
    }
  }

  Future<void> changeView() async {
    setState(() {
      _isOverview = !_isOverview;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Geoworker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: changeView,
          ),
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: getStats,
          )
        ],
      ),
      body: _isOverview ? new TransportsOverview().makeBody(_stats) : new TransportStats().makeBody(_stats),
    );
  }
}
