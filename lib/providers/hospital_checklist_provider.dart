import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HospitalChecklistItem {
  final String id;
  final String title;
  bool isChecked;

  HospitalChecklistItem({
    required this.id,
    required this.title,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isChecked': isChecked,
      };

  factory HospitalChecklistItem.fromJson(Map<String, dynamic> json) =>
      HospitalChecklistItem(
        id: json['id'],
        title: json['title'],
        isChecked: json['isChecked'] ?? false,
      );
}

class HospitalChecklistProvider extends ChangeNotifier {
  static const String _storageKey = 'sudha_hospital_checklist';
  
  final List<HospitalChecklistItem> _items = [
    HospitalChecklistItem(id: '1', title: 'Medical records'),
    HospitalChecklistItem(id: '2', title: 'Insurance documents'),
    HospitalChecklistItem(id: '3', title: 'Current medications list'),
    HospitalChecklistItem(id: '4', title: 'Emergency contact numbers'),
    HospitalChecklistItem(id: '5', title: 'Allergy information'),
  ];

  List<HospitalChecklistItem> get items => _items;

  HospitalChecklistProvider() {
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final jsonData = jsonDecode(data) as List;
        _items.clear();
        _items.addAll(
          jsonData.map((item) => HospitalChecklistItem.fromJson(item)),
        );
        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading checklist: $e');
    }
  }

  Future<void> _saveChecklist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(_items.map((item) => item.toJson()).toList());
      await prefs.setString(_storageKey, jsonData);
    } catch (e) {
      // ignore: avoid_print
      print('Error saving checklist: $e');
    }
  }

  void toggleItem(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isChecked = !_items[index].isChecked;
      _saveChecklist();
      notifyListeners();
    }
  }

  void addItem(String title) {
    if (title.trim().isEmpty) return;
    
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    _items.add(HospitalChecklistItem(id: newId, title: title.trim()));
    _saveChecklist();
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    _saveChecklist();
    notifyListeners();
  }

  int getCompletionPercentage() {
    if (_items.isEmpty) return 0;
    final checked = _items.where((item) => item.isChecked).length;
    return ((checked / _items.length) * 100).toInt();
  }
}
