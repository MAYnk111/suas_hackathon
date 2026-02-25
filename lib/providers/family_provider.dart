import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final String? phone;
  final String? email;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    this.phone,
    this.email,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relation': relation,
    'phone': phone,
    'email': email,
  };

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String,
      name: json['name'] as String,
      relation: json['relation'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }
}

class FamilyProvider extends ChangeNotifier {
  static const String _membersKey = 'sudha_family_members';
  
  List<FamilyMember> _members = [];
  String? error;

  List<FamilyMember> get members => _members;

  FamilyProvider() {
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final membersJson = prefs.getStringList(_membersKey) ?? [];
      
      _members = membersJson.map((json) {
        final decoded = jsonDecode(json) as Map<String, dynamic>;
        return FamilyMember.fromJson(decoded);
      }).toList();
    } catch (e) {
      error = e.toString();
      _members = [];
    }
    notifyListeners();
  }

  Future<void> addMember({
    required String name,
    required String relation,
    String? phone,
    String? email,
  }) async {
    try {
      final member = FamilyMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        relation: relation,
        phone: phone,
        email: email,
      );

      _members.add(member);
      await _saveMembers();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateMember(String id, {
    required String name,
    required String relation,
    String? phone,
    String? email,
  }) async {
    try {
      final index = _members.indexWhere((m) => m.id == id);
      if (index != -1) {
        _members[index] = FamilyMember(
          id: id,
          name: name,
          relation: relation,
          phone: phone,
          email: email,
        );
        await _saveMembers();
        error = null;
      }
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteMember(String id) async {
    try {
      _members.removeWhere((m) => m.id == id);
      await _saveMembers();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> _saveMembers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final membersJson = _members
          .map((m) => jsonEncode(m.toJson()))
          .toList();
      await prefs.setStringList(_membersKey, membersJson);
    } catch (e) {
      error = e.toString();
    }
  }
}
