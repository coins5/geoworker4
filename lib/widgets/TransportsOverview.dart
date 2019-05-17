import 'package:flutter/material.dart';
import 'package:geoworkerv4/models/Stats.dart';

class TransportsOverview {
  Container makeBody(List<Stats> statsLists) {
    
    int total = 0;
    int totalGeocoded = 0;
    int totalNotFound = 0;
    int totalErrors = 0;
    
    for (int i = 0; i < statsLists.length; i++) {
      Stats stats = statsLists[i];
      totalGeocoded += stats.totalSuccessfullyCompleted + stats.successfullyCompleted;
      totalNotFound += stats.totalNotFound + stats.notFound;
      totalErrors += stats.totalCompletedWithErrors + stats.completedWithErrors;
    }

    total = totalGeocoded + totalNotFound + totalErrors;
    
    String percent = ((totalGeocoded * 1.0) / total).toStringAsFixed(2);

    return Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: Column(
        children: <Widget>[
          new Text(
            "Total: $percent",
            style: TextStyle(color: Colors.white)
          ),
          new Text(
            "Geocoded: $totalGeocoded",
            style: TextStyle(color: Colors.white)
          ),
          new Text(
            "Not found: $totalNotFound",
            style: TextStyle(color: Colors.white)
          ),
          new Text(
            "Errors: $totalErrors",
            style: TextStyle(color: Colors.white)
          ),
          new Text(
            "Total: $total",
            style: TextStyle(color: Colors.white)
          ),
        ],
      )
    );
  }
}