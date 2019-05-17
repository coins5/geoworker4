import 'package:flutter/material.dart';
import 'package:geoworkerv4/models/Stats.dart';
import 'package:geoworkerv4/models/Report.dart';

class TransportsOverview {

  Container makeBody(List<Stats> statsLists, DateTime startTime) {
    
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
    
    String percent = ((totalGeocoded * 100.0) / total).toStringAsFixed(2);

    int totalProblems = totalNotFound + totalErrors;

    final currentDate = DateTime.now();
    final executionTime = currentDate.difference(startTime).inSeconds;

    final mins = (executionTime / 60);
    final speed = total / mins;

    List<Report> listReports = new List<Report>();
    listReports.add(new Report(true, "Procesados: $total", "Geocodificados: $totalGeocoded ($percent%)"));
    listReports.add(new Report(false, "Problemas: $totalProblems", "No encontrados: $totalNotFound\nCon errores: $totalErrors"));

    Card generateCard(String _title, String _subTitle) {
      return new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 7.5, vertical: 3.0),
        child: new Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: new ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              _title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            subtitle: Text(
              _subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)
            ),
          ),
        ),
      );
    }

    String formatDate(DateTime dateTime) {
      // dateTime.hour
      String yyyy = dateTime.year.toString();
      String MM = dateTime.month.toString().padLeft(2,'0');
      String dd = dateTime.day.toString().padLeft(2,'0');

      String hh = dateTime.hour.toString().padLeft(2,'0');
      String mm = dateTime.minute.toString().padLeft(2,'0');
      String ss = dateTime.second.toString().padLeft(2,'0');

      return "$yyyy-$MM-$dd $hh:$mm:$ss";
    }

    String formatExecutionTime(int _executionTime) {
      
      int _ss = _executionTime % 60;
      double _mm = (_executionTime - _ss) / 60;
      double _hh = (_mm - (_mm % 60)) / 60;
      double _dd = (_hh - (_hh % 24)) / 24;
      
      String ss = (_ss).toString();
      String mm = (_mm % 60).toStringAsFixed(0);
      String hh = (_hh % 24).toStringAsFixed(0);
      String dd = (_dd % 24).toStringAsFixed(0);

      print(_executionTime);
      return "${dd}d ${hh}h $mm\' $ss\"";
    }

    ListTile makeTile(Report report) => new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24)
          )
        ),
        child: Icon(
          report.itsOk ? Icons.check : Icons.error,
          color: report.itsOk ? Colors.green : Colors.orangeAccent),
      ),
      title: Text(
        report.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text( 
                report.subTitle,
                style: TextStyle(color: Colors.white)
              )
            ),
          )
        ],
      ),
      isThreeLine: !report.itsOk,
    );

    Card makeCard(Report report) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeTile(report),
      ),
    );

    Container makeBodyReport() {
      return Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listReports.length,
          itemBuilder: (BuildContext context, int index) {
            return makeCard(listReports[index]);
          },
        ),
      );
    }

    return Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            child: Text( 
              "Iniciado en : ${formatDate(startTime)}",
              style: TextStyle(color: Colors.white)
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
            child: Text( 
              "Tiempo transcurrido: ${formatExecutionTime(executionTime)}",
              style: TextStyle(color: Colors.white)
            )
          ),
          makeBodyReport(),
          new Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: generateCard(speed.toStringAsFixed(0), 'x min'),
              ),
              Expanded(
                flex: 1,
                child: generateCard((speed * 60).toStringAsFixed(0), 'x hour'),
              ),
              Expanded(
                flex: 1,
                child: generateCard((speed * 60 * 24).toStringAsFixed(0), 'x day'),
              ),
            ],
          ),
        ],
      )
    );
  }
}