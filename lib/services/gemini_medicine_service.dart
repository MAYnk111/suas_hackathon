import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../exceptions/medicine_validation_exception.dart';
import '../models/medicine_verification.dart';

/// 🚨 CRITICAL: Direct Gemini API Integration for Medicine Validation
/// Two-step process: Detection → Analysis
/// NO BACKEND NEEDED - All processing happens client-side
class GeminiMedicineService {
  // 🔑 ADD YOUR GEMINI API KEY HERE
  // Get it from: https://makersuite.google.com/app/apikey
  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  // Confidence threshold for detection
  static const double _detectionThreshold = 0.7;
  
  /// ====================================================
  /// 1️⃣ STRICT DETECTION STEP (FIRST GATE)
  /// ====================================================
  /// Detects if image contains medicine packaging BEFORE any analysis
  /// Returns: true if medicine detected with high confidence
  Future<Map<String, dynamic>> detectMedicine(File imageFile) async {
    print('🔍 STEP 1: DETECTION - Checking if image contains medicine...');
    
    try {
      // Initialize Gemini
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
      );
      
      // Read image bytes
      final imageBytes = await imageFile.readAsBytes();
      
      // Detection prompt - ONLY checks if medicine exists
      final prompt = TextPart('''You are a strict classifier.
Is this image a medicine strip, pill bottle, or pharmaceutical packaging?

Return ONLY JSON:

{
  "is_medicine": true or false,
  "confidence": number between 0 and 1
}

If unsure -> false.

TRUE only for:
- Medicine tablet strips/blister packs
- Pill bottles with pharmaceutical labels
- Medicine box packaging with drug names

FALSE for everything else:
- Food, objects, furniture, documents
- People, animals, plants, buildings
- Screenshots, blank images
- Unclear/blurry images''');
      
      final imagePart = DataPart('image/jpeg', imageBytes);
      
      // Call Gemini
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);
      
      final resultText = response.text ?? '{"is_medicine": false, "confidence": 0.0}';
      print('📝 Gemini detection response: $resultText');
      
      // Parse JSON response
      String cleanedJson = resultText.trim();
      if (cleanedJson.contains('```json')) {
        cleanedJson = cleanedJson.split('```json')[1].split('```')[0].trim();
      } else if (cleanedJson.contains('```')) {
        cleanedJson = cleanedJson.split('```')[1].split('```')[0].trim();
      }
      
      final result = json.decode(cleanedJson) as Map<String, dynamic>;
      
      final isMedicine = result['is_medicine'] == true;
      final confidence = (result['confidence'] as num).toDouble();
      
      print('🎯 DETECTION RESULT: is_medicine=$isMedicine, confidence=$confidence');
      
      return {
        'is_medicine': isMedicine,
        'confidence': confidence,
      };
      
    } catch (e) {
      print('❌ Detection error: $e');
      // SAFE DEFAULT: Assume NOT medicine on error
      return {
        'is_medicine': false,
        'confidence': 0.0,
        'error': e.toString(),
      };
    }
  }
  
  /// ====================================================
  /// 2️⃣ HARD STOP - Validate Detection Result
  /// ====================================================
  /// Checks if detection passed threshold
  /// Throws exception if not medicine or confidence too low
  void validateDetection(Map<String, dynamic> detectionResult) {
    final isMedicine = detectionResult['is_medicine'] == true;
    final confidence = (detectionResult['confidence'] as num).toDouble();
    
    // 🚨 CRITICAL: HARD STOP if not medicine or low confidence
    if (!isMedicine || confidence < _detectionThreshold) {
      print('🛑 HARD STOP: Image validation failed');
      print('   is_medicine: $isMedicine');
      print('   confidence: $confidence');
      print('   threshold: $_detectionThreshold');
      
      throw MedicineValidationException(
        'Medicine not detected. Upload a clear medicine image.',
        details: {
          'detected_as_medicine': isMedicine,
          'confidence': confidence,
          'reason': isMedicine 
              ? 'Confidence too low ($confidence < $_detectionThreshold)'
              : 'Image does not appear to be medicine packaging',
        },
      );
    }
    
    print('✅ DETECTION PASSED: Proceeding to analysis...');
  }
  
  /// ====================================================
  /// 3️⃣ ANALYSIS STEP (ONLY IF DETECTION PASSED)
  /// ====================================================
  /// Analyzes medicine authenticity - fake vs real
  /// This code ONLY runs if detection passed
  Future<MedicineVerificationResult> analyzeMedicine(File imageFile) async {
    print('🔬 STEP 2: ANALYSIS - Checking if medicine is fake or real...');
    
    try {
      // Initialize Gemini
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
      );
      
      // Read image bytes
      final imageBytes = await imageFile.readAsBytes();
      
      // Analysis prompt - fake vs real
      final prompt = TextPart('''You are a medicine authenticity expert.
Analyze this medicine image and determine if it appears to be fake or authentic.

Look for signs of fake medicine:
- Poor print quality, smudged text
- Spelling mistakes in drug name or manufacturer
- Incorrect packaging colors or design
- Missing batch number, expiry date, or MRP
- Suspicious labeling or unclear text

Return ONLY JSON:

{
  "is_fake": true or false,
  "confidence": number between 0 and 1,
  "risk_level": "low" or "medium" or "high",
  "message": "brief explanation",
  "signs": ["list", "of", "suspicious", "signs"]
}

If you cannot determine with confidence, set is_fake to false and risk_level to "medium".''');
      
      final imagePart = DataPart('image/jpeg', imageBytes);
      
      // Call Gemini
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);
      
      final resultText = response.text ?? '{"is_fake": false, "confidence": 0.5, "risk_level": "medium", "message": "Could not analyze"}';
      print('📝 Gemini analysis response: $resultText');
      
      // Parse JSON response
      String cleanedJson = resultText.trim();
      if (cleanedJson.contains('```json')) {
        cleanedJson = cleanedJson.split('```json')[1].split('```')[0].trim();
      } else if (cleanedJson.contains('```')) {
        cleanedJson = cleanedJson.split('```')[1].split('```')[0].trim();
      }
      
      final result = json.decode(cleanedJson) as Map<String, dynamic>;
      
      final isFake = result['is_fake'] == true;
      final confidence = (result['confidence'] as num).toDouble();
      final riskLevel = result['risk_level'] as String? ?? 'medium';
      final message = result['message'] as String? ?? 'Analysis completed';
      final signs = (result['signs'] as List?)?.cast<String>() ?? [];
      
      print('🎯 ANALYSIS RESULT: is_fake=$isFake, confidence=$confidence, risk=$riskLevel');
      
      // Return result (convert confidence to int percentage)
      return MedicineVerificationResult(
        confidence: (confidence * 100).toInt(),
        riskLevel: riskLevel,
        message: isFake 
            ? '⚠️ WARNING: This medicine shows signs of being fake'
            : '✅ This medicine appears to be authentic',
        metadata: {
          'is_fake': isFake,
          'signs': signs,
          'analysis': message,
          'raw_confidence': confidence,
        },
      );
      
    } catch (e) {
      print('❌ Analysis error: $e');
      throw Exception('Failed to analyze medicine: $e');
    }
  }
  
  /// ====================================================
  /// 🎯 MAIN ENTRY POINT - TWO-STEP VERIFICATION
  /// ====================================================
  /// Combines detection + analysis with hard stop between them
  /// This ensures percentage is NEVER shown for non-medicine images
  Future<MedicineVerificationResult> verifyMedicine(File imageFile) async {
    print('🚀 Starting TWO-STEP medicine verification...');
    print('═══════════════════════════════════════════════════');
    
    // ====================================================
    // STEP 1: DETECT if image contains medicine
    // ====================================================
    final detectionResult = await detectMedicine(imageFile);
    
    // ====================================================
    // STEP 2: HARD STOP - Validate detection
    // ====================================================
    // This throws exception if not medicine or low confidence
    // NO CODE AFTER THIS RUNS if validation fails
    validateDetection(detectionResult);
    
    // ====================================================
    // STEP 3: ANALYZE medicine (ONLY if detection passed)
    // ====================================================
    // Code reaches here ONLY if is_medicine == true AND confidence >= 0.7
    final analysisResult = await analyzeMedicine(imageFile);
    
    print('═══════════════════════════════════════════════════');
    print('✅ Verification complete!');
    
    return analysisResult;
  }
}
