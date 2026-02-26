/// Exception thrown when medicine image validation fails
class MedicineValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? details;

  MedicineValidationException(this.message, {this.details});

  @override
  String toString() => message;

  /// Whether the image was detected as NOT medicine
  bool get isNotMedicine =>
      details?['detected_as_medicine'] == false ||
      details?['is_medicine'] == false;

  /// Confidence score from validation (0.0 to 1.0)
  double get confidence => details?['confidence']?.toDouble() ?? 0.0;

  /// Reason why validation failed
  String get reason => details?['reason'] ?? 'Unknown';
}
