class MedicineVerificationResult {
  final int confidence;
  final String riskLevel;
  final String message;
  final Map<String, dynamic> metadata;

  const MedicineVerificationResult({
    required this.confidence,
    required this.riskLevel,
    required this.message,
    required this.metadata,
  });

  factory MedicineVerificationResult.fromJson(Map<String, dynamic> json) {
    return MedicineVerificationResult(
      confidence: (json['confidence'] as num?)?.toInt() ?? 0,
      riskLevel: json['riskLevel'] as String? ?? 'Unknown',
      message: json['message'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );
  }
}
