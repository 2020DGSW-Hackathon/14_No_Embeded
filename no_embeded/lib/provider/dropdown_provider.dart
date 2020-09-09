import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier {
  final values = ["온도", "가스", "습도"];
  final rects = {"온도": "℃", "가스": "ppm", "습도": "%"};
  String get serverString =>
      selectedIndex == "온도" ? "temp" : selectedIndex == "습도" ? "hum" : "gas";
  String _selectedIndex = "온도";
  String get selectedIndex => _selectedIndex;
  set selectedIndex(val) {
    _selectedIndex = val;
    notifyListeners();
  }
}
