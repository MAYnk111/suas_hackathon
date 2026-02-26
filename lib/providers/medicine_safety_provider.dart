import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../exceptions/medicine_validation_exception.dart';
import '../models/medicine_verification.dart';
import '../services/gemini_medicine_service.dart';

class MedicineSafetyProvider extends ChangeNotifier {
  final GeminiMedicineService _geminiService = GeminiMedicineService();
  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;
  MedicineVerificationResult? result;
  bool isLoading = false;
  String? error;
  MedicineValidationException? validationError;

  Future<void> selectImage(ImageSource source) async {
    error = null;
    validationError = null;
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
    validationError = null;
    notifyListeners();
  }

  Future<void> verifySelectedImage() async {
    if (selectedImage == null) return;

    isLoading = true;
    error = null;
    validationError = null;
    notifyListeners();

    try {
      final file = File(selectedImage!.path);
      // 🚨 CRITICAL: Two-step verification (detection → analysis)
      // Percentage is NEVER shown for non-medicine images
      result = await _geminiService.verifyMedicine(file);
    } on MedicineValidationException catch (e) {
      // Image validation failed - not a medicine image
      // ignore: avoid_print
      print('⚠️ VALIDATION ERROR: ${e.message}');
      // ignore: avoid_print
      print('Details: confidence=${e.confidence}, reason=${e.reason}');
      validationError = e;
      error = e.message;
    } catch (e) {
      // Other errors (network, Gemini API, etc.)
      // ignore: avoid_print
      print('❌ ERROR: $e');
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
