import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
