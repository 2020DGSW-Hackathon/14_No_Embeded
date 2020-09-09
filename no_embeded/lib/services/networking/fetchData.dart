import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:no_embeded/models/data_model.dart';

final client = http.Client();

final address = "http://192.168.43.240:3000";
Future<DataModel> findMax(String type) async {
  try {
    final response = await client.get("$address/datas/max?type=$type");
    if (response.statusCode == 200) {
      print(response.body);
      return DataModel.fromJson(json.decode(response.body));
    } else {
      return DataModel.empty;
    }
  } catch (err) {
    print(err);
  }
}

Future<DataModel> findMin(String type) async {
  try {
    final response = await client.get("$address/datas/min?type=$type");
    if (response.statusCode == 200) {
      print(response.body);
      return DataModel.fromJson(json.decode(response.body));
    } else {
      return DataModel.empty;
    }
  } catch (err) {
    print(err);
  }
}

Future<DataModel> fetchData(int max) async {
  try {
    final response = await client.get("$address/datas/test");
    if (response.statusCode == 200) {
      print(response.body);
      return DataModel.fromJson(json.decode(response.body));
    } else {
      return DataModel.empty;
    }
  } catch (err) {
    print(err);
  }
}
