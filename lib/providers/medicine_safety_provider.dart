import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/medicine_verification.dart';
import '../services/api_service.dart';

class MedicineSafetyProvider extends ChangeNotifier {
  final ApiService _apiService = const ApiService();
  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;
  MedicineVerificationResult? result;
  bool isLoading = false;
  String? error;

  Future<void> selectImage(ImageSource source) async {
    error = null;
    final image = await _picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      selectedImage = image;
      result = null;
    }
    notifyListeners();
  }

  void clearImage() {
    selectedImage = null;
    result = null;
    error = null;
    notifyListeners();
  }

  Future<void> verifySelectedImage() async {
    if (selectedImage == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final file = File(selectedImage!.path);
      result = await _apiService.verifyMedicine(file);
    } catch (e) {
      // ignore: avoid_print
      print('REAL ERROR FROM BACKEND: $e');
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
