class ConditionResult {
  final String condition;
  final int confidence;

  const ConditionResult({required this.condition, required this.confidence});

  factory ConditionResult.fromJson(Map<String, dynamic> json) {
    // Try multiple confidence key variants
    double confidenceScore = double.tryParse(
      json['confidence_score']?.toString() ??
      json['confidenceScore']?.toString() ??
      json['confidence']?.toString() ??
      json['confidence_percent']?.toString() ??
      "0"
    ) ?? 0;
    
    // If backend returns 0-100, keep as is. Otherwise normalize to 0-100
    if (confidenceScore > 1.0 && confidenceScore <= 100.0) {
      // Already in 0-100 format
    } else if (confidenceScore > 0 && confidenceScore <= 1.0) {
      // Convert from 0-1 to 0-100
      confidenceScore = confidenceScore * 100;
    }
    
    return ConditionResult(
      condition: json['condition'] as String? ?? 'Unknown',
      confidence: confidenceScore.toInt().clamp(0, 100),
    );
  }
}

class TriageFlags {
  final String? redFlag;
  final String? yellowFlag;

  const TriageFlags({this.redFlag, this.yellowFlag});

  factory TriageFlags.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TriageFlags();
    return TriageFlags(
      redFlag: json['redFlag'] as String?,
      yellowFlag: json['yellowFlag'] as String?,
    );
  }
}

class TriageAnalysis {
  final String? age;
  final String? gender;

  const TriageAnalysis({this.age, this.gender});

  factory TriageAnalysis.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TriageAnalysis();
    return TriageAnalysis(
      age: json['age'] as String?,
      gender: json['gender'] as String?,
    );
  }
}

class TriageResult {
  final String riskLevel;
  final List<ConditionResult> topConditions;
  final String explanation;
  final String triageType;
  final TriageFlags flags;
  final TriageAnalysis analysis;

  const TriageResult({
    required this.riskLevel,
    required this.topConditions,
    required this.explanation,
    required this.triageType,
    required this.flags,
    required this.analysis,
  });

  factory TriageResult.fromJson(Map<String, dynamic> json) {
    final list = (json['topConditions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ConditionResult.fromJson)
        .toList();

    return TriageResult(
      riskLevel: json['riskLevel'] as String? ?? 'Green',
      topConditions: list,
      explanation: json['explanation'] as String? ?? 'No explanation provided.',
      triageType: json['triageType'] as String? ?? 'rule-based-gemini',
      flags: TriageFlags.fromJson(json['flags'] as Map<String, dynamic>?),
      analysis: TriageAnalysis.fromJson(json['analysis'] as Map<String, dynamic>?),
    );
  }
}
