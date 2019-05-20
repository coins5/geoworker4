import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:geoworkerv4/models/Stats.dart';
import 'package:geoworkerv4/widgets/TransportStats.dart';
import 'package:geoworkerv4/widgets/TransportsOverview.dart';

class GeoworkerPage extends StatefulWidget {
  GeoworkerPage({Key key, this.title, this.server, this.deviceName, this.threads }) : super(key: key);

  final String title;
  final String server;
  final String deviceName;
  final int threads;
  
  @override
  _GeoworkerPageState createState() => _GeoworkerPageState();
}

class _GeoworkerPageState extends State<GeoworkerPage> {
  static const platform = const MethodChannel('vida.software/geoworkerv4');
  List<Stats> _stats = new List<Stats>();
  bool _isOverview = false;
  DateTime startTime;

  @override
  void initState() {
    super.initState();
    startTransport();
  }


  Future<void> startTransport () async {
    try {
      await platform.invokeMethod('startGeoWorker', {'threads': widget.threads, 'server': widget.server});
      startTime = DateTime.now();
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

  Widget makeBody(isOverview) {
    if (isOverview) {
      return new SingleChildScrollView(
        child: TransportsOverview().makeBody(_stats, startTime)
      );
    } else {
      return new TransportStats().makeBody(_stats);
    }
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
      body: makeBody(_isOverview),
      /*
      body: SingleChildScrollView(
        child: _isOverview ? new TransportsOverview().makeBody(_stats, startTime) : new TransportStats().makeBody(_stats),
      ),
      */
    );
  }
}
