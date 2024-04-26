import 'package:flutter/material.dart';

/// This notifier controls which page is show on the main screen, and rebuilds
/// the widget tree accordinly.
class NotifierPage with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  NotifierPage({
    int initialPage = 0,
  }) {
    _currentPage = initialPage;
  }

  void setCurrentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }
}
