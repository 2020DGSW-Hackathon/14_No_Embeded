import 'package:flutter/cupertino.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(val) {
    _currentIndex = val;
    notifyListeners();
  }
}
