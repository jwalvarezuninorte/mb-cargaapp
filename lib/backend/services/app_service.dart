import 'package:flutter/material.dart';

class AppService extends ChangeNotifier {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  int get selectedIndex => this._selectedIndex;

  set selectedIndex(int value) => this._selectedIndex = value;

  get pageController => this._pageController;

  set pageController(value) => this._pageController = value;

  void changeScreen(int index, BuildContext context) {
    _selectedIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (_selectedIndex == 0) {
      // final homeService = Provider.of<HomeService>(context, listen: false);
    }
    notifyListeners();
  }
}
