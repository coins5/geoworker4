import 'package:flutter/material.dart';
import 'package:geoworkerv4/models/Stats.dart';

class TransportStats {
  ListTile makeListTile(Stats stats) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
        border: new Border(
          right: new BorderSide(width: 1.0, color: Colors.white24)
        )
      ),
      child: Icon(Icons.directions_bus, color: Colors.white),
    ),
    title: Text(
      "${stats.identifier}:  ${stats.timesCompleted} veces",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            // tag: 'hero',
            child: LinearProgressIndicator(
              backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
              value: (stats.successfullyCompleted + stats.notFound + stats.completedWithErrors) / stats.currentDataSize * 1.0,
              valueColor: AlwaysStoppedAnimation(Colors.green)
            ),
          )
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text( 
              stats.isReady ? (stats.isConnected ? 'Conectado' : 'Desconectado') : 'No está listo',
              style: TextStyle(color: Colors.white)
            )
          ),
        )
      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
  );

  Card makeCard(Stats stats) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: makeListTile(stats),
    ),
  );

  /*
  final makeBody = Container(
    // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: Transports.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(Transport[index]);
      },
    ),
  );
  */
  Container makeBody(List<Stats> statsLists) {
    return Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: statsLists.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(statsLists[index]);
        },
      ),
    );
  }
}
