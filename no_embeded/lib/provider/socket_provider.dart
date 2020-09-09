import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

enum Connection { waiting, connected }

class SocketProvider extends ChangeNotifier {
  Connection _connection = Connection.waiting;
  Connection get connection => _connection;

  String _hum = '0';
  String get hum => _hum;

  String _temp = '0';
  String get temp => _temp;

  set temp(val) {
    _temp = val;
    notifyListeners();
  }

  String _gas = '0';
  String get gas => _gas;

  set gas(val) {
    _gas = val;
    notifyListeners();
  }

  set hum(val) {
    hum = val;
    notifyListeners();
  }

  SocketIO _io;
  SocketIO get io => _io;

  set connection(newConnection) {
    _connection = newConnection;
    notifyListeners();
  }

  void connect() {
    connection = Connection.waiting;

    _io = SocketIOManager().createSocketIO("http://192.168.43.240:80", '/',
        socketStatusCallback: (dta) {
      _io.unSubscribesAll();
      _io.subscribe('data', (data) {
        print(data);
        final val = json.decode(data);
        _hum = "${val["hum"]}";
        _temp = "${val["temp"]}";
        _gas = "${val["gas"]}";
        notifyListeners();
        print("Saved");
      });
    });
    _io.init();
    _io.connect();
    connection = Connection.connected;
  }
}
