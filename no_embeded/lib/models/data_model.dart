import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DataModel extends Equatable {
  @override
  List<Object> get props => [status, message];
  final int status;
  final String message;
  final List<Data> data;
  static final empty = DataModel(status: 0, message: "", data: null);
  DataModel(
      {@required this.status, @required this.message, @required this.data});
  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        status: json["status"],
        message: json["message"],
        data: (json["data"] as List).map((e) => Data.fromJson(e)).toList(),
      );
}

class Data {
  final int temp;
  final int hum;
  final int gas;
  final DateTime uploaded;
  Data(
      {@required this.temp,
      @required this.hum,
      @required this.gas,
      @required this.uploaded});
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        temp: json["temp"],
        hum: json["hum"],
        gas: json["gas"],
        uploaded: DateTime.parse(json["uploaded"]),
      );
}
