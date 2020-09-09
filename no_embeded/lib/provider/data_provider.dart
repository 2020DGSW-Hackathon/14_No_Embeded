import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:no_embeded/models/data_model.dart';
import 'package:no_embeded/services/networking/fetchData.dart';

enum Status { loading, complete, uncomplete }

class DataProvider extends ChangeNotifier {
  Status _status = Status.loading;
  Status get status => _status;

  Status _minStatus = Status.loading;
  Status _maxStatus = Status.loading;

  DataModel model = DataModel.empty;
  DataModel min = DataModel.empty;
  DataModel max = DataModel.empty;

  Status get minStatus => _minStatus;
  Status get maxStatus => _maxStatus;
  SocketIO _io;
  SocketIO get io => _io;
  set minStatus(val) {
    _minStatus = val;
    notifyListeners();
  }

  set maxStatus(val) {
    _maxStatus = val;
    notifyListeners();
  }

  set status(val) {
    _status = val;
    notifyListeners();
  }

  Future<void> requestData(int max) async {
    status = Status.loading;
    final response = await fetchData(max);
    if (response == DataModel.empty) {
      status = Status.uncomplete;
    } else {
      model = response;
      status = Status.complete;
    }
  }

  Future<void> requestMin(String type) async {
    minStatus = Status.loading;
    final response = await findMin(type);
    if (response == DataModel.empty) {
      minStatus = Status.uncomplete;
    } else {
      min = response;
      minStatus = Status.complete;
    }
  }

  Future<void> requestMax(String type) async {
    maxStatus = Status.loading;
    final response = await findMax(type);
    if (response == DataModel.empty) {
      maxStatus = Status.uncomplete;
    } else {
      max = response;
      maxStatus = Status.complete;
    }
  }
}
