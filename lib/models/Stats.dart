import 'package:meta/meta.dart';

@immutable
class Stats {

  final int successfullyCompleted;
  final int completedWithErrors;
  final int currentDataSize;
  final bool isConnected;
  final String identifier;
  final int timesCompleted;

  Stats(
    this.successfullyCompleted,
    this.completedWithErrors,
    this.currentDataSize,
    this.isConnected,
    this.identifier,
    this.timesCompleted
  );

  /// Creates Stats from a map containing its properties.
  Stats.fromMap(Map map) :
        this.successfullyCompleted = map["successfullyCompleted"],
        this.completedWithErrors = map["completedWithErrors"],
        this.currentDataSize = map["currentDataSize"],
        this.isConnected = map["isConnected"],
        this.identifier = map["identifier"],
        this.timesCompleted = map["timesCompleted"];

  /// Creates a map from the Stats properties.
  Map toMap() => {
    "successfullyCompleted": this.successfullyCompleted,
    "completedWithErrors": this.completedWithErrors,
    "currentDataSize": this.currentDataSize,
    "isConnected": this.isConnected,
    "identifier": this.identifier,
    "timesCompleted": this.timesCompleted
  };

  String toString() => "{$successfullyCompleted,$completedWithErrors,$currentDataSize,$isConnected,$identifier,$timesCompleted}";
}