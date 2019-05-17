import 'package:flutter/services.dart';
import 'dart:async';

import 'package:geoworkerv4/models/Stats.dart';

class Geoworker {
  static const platform = const MethodChannel('vida.software/geoworkerv4');

  Future<bool> startGeoWorker () async {
    try {
      await platform.invokeMethod('startGeoWorker', {"threads": 5});
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<List<Stats>> getStats () async {
    List<Stats> _stats = new List<Stats>();
    try {
      Iterable response = await platform.invokeMethod("getStats");
      _stats = response.map((x) => Stats.fromMap(x)).toList();
    } on PlatformException catch (e) {
      print("ERROR ON GET STATS");
      print(e);
    }
    return _stats;
  }
}