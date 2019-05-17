import 'package:meta/meta.dart';

@immutable
class Stats {

  final int successfullyCompleted;
  final int completedWithErrors;
  final int notFound;
  final int totalSuccessfullyCompleted;
  final int totalCompletedWithErrors;
  final int totalNotFound; 
  final int currentDataSize;
  final bool isConnected;
  final String identifier;
  final int timesCompleted;

  final bool isReady;

  Stats(
    this.successfullyCompleted,
    this.completedWithErrors,
    this.notFound,
    this.totalSuccessfullyCompleted,
    this.totalCompletedWithErrors,
    this.totalNotFound,
    this.currentDataSize,
    this.isConnected,
    this.identifier,
    this.timesCompleted,
    this.isReady
  );

  /// Creates Stats from a map containing its properties.
  Stats.fromMap(Map map) :
    this.successfullyCompleted = map["successfullyCompleted"],
    this.completedWithErrors = map["completedWithErrors"],
    this.notFound = map["notFound"],
    this.totalSuccessfullyCompleted = map["totalSuccessfullyCompleted"],
    this.totalCompletedWithErrors = map["totalCompletedWithErrors"],
    this.totalNotFound = map["totalNotFound"],
    this.currentDataSize = map["currentDataSize"],
    this.isConnected = map["isConnected"],
    this.identifier = map["identifier"],
    this.timesCompleted = map["timesCompleted"],
    this.isReady = map["isReady"];

  /// Creates a map from the Stats properties.
  Map toMap() => {
    "successfullyCompleted": this.successfullyCompleted,
    "completedWithErrors": this.completedWithErrors,
    "notFound": this.notFound,
    "totalSuccessfullyCompleted": this.totalSuccessfullyCompleted,
    "totalCompletedWithErrors": this.totalCompletedWithErrors,
    "totalNotFound": this.totalNotFound,
    "currentDataSize": this.currentDataSize,
    "isConnected": this.isConnected,
    "identifier": this.identifier,
    "timesCompleted": this.timesCompleted,
    "isReady": this.isReady
  };

  String toString() => "{$identifier}";
}