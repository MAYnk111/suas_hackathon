import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/fhir_models.dart';
import '../utils/health_snapshot_storage.dart';

enum SnapshotType { normal, emergency }

class HealthUserInfo {
  final String name;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String height;
  final String weight;
  final String phone;
  final String allergies;
  final String medications;
  final String emergencyContact;
  final String insuranceInfo;

  HealthUserInfo({
    required this.name,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.phone,
    required this.allergies,
    required this.medications,
    required this.emergencyContact,
    required this.insuranceInfo,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'dob': dob,
    'gender': gender,
    'bloodGroup': bloodGroup,
    'height': height,
    'weight': weight,
    'phone': phone,
    'allergies': allergies,
    'medications': medications,
    'emergencyContact': emergencyContact,
    'insuranceInfo': insuranceInfo,
  };

  factory HealthUserInfo.fromJson(Map<String, dynamic> json) {
    return HealthUserInfo(
      name: json['name'] as String,
      dob: json['dob'] as String,
      gender: json['gender'] as String,
      bloodGroup: json['bloodGroup'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
      phone: json['phone'] as String,
      allergies: json['allergies'] as String,
      medications: json['medications'] as String,
      emergencyContact: json['emergencyContact'] as String,
      insuranceInfo: json['insuranceInfo'] as String,
    );
  }
}

class HealthSnapshotResult {
  final Map<String, dynamic> json;
  final String summary;

  HealthSnapshotResult({
    required this.json,
    required this.summary,
  });
}

class HealthDataProvider extends ChangeNotifier {
  static const String _userHealthInfoKey = 'sudha_user_health_info';

  String? _userEmail;
  String? _userId;
  HealthUserInfo? _userHealthInfo;

  HealthDataProvider() {
    _loadUserHealthInfo();
  }

  HealthUserInfo? get userHealthInfo => _userHealthInfo;

  bool get hasRequiredHealthInfo {
    if (_userHealthInfo == null) return false;
    final info = _userHealthInfo!;
    return info.name.isNotEmpty &&
        info.dob.isNotEmpty &&
        info.gender.isNotEmpty &&
        info.bloodGroup.isNotEmpty &&
        info.height.isNotEmpty &&
        info.weight.isNotEmpty &&
        info.phone.isNotEmpty &&
        info.allergies.isNotEmpty &&
        info.emergencyContact.isNotEmpty &&
        info.insuranceInfo.isNotEmpty;
  }

  void setUserData(String? email, String? userId) {
    _userEmail = email;
    _userId = userId;
    notifyListeners();
  }

  Future<void> saveUserHealthInfo(HealthUserInfo info) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userHealthInfoKey, jsonEncode(info.toJson()));
    _userHealthInfo = info;
    notifyListeners();
  }

  Future<void> _loadUserHealthInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_userHealthInfoKey);
      if (raw != null && raw.isNotEmpty) {
        _userHealthInfo = HealthUserInfo.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    } catch (_) {
      _userHealthInfo = null;
    }
    notifyListeners();
  }

  Future<HealthSnapshotResult> generateSnapshot({
    required SnapshotType type,
    required List<String> activeMedications,
  }) async {
    final snapshotId = 'snapshot-${DateTime.now().millisecondsSinceEpoch}';
    final timestamp = DateTime.now().toIso8601String();
    final info = _userHealthInfo;

    final latestSymptom = await HealthSnapshotStorage.loadLatestSymptomLog();
    final latestDaily = await HealthSnapshotStorage.loadLatestDailyEntry();

    final allergies = (info?.allergies ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final observationEntries = <Map<String, dynamic>>[];
    if (latestSymptom != null) {
      observationEntries.add({
        'resourceType': 'Observation',
        'code': {
          'text': 'Symptoms',
        },
        'valueString': latestSymptom['symptoms'],
        'effectiveDateTime': latestSymptom['recorded_at'],
      });
    }
    if (latestDaily != null) {
      observationEntries.add({
        'resourceType': 'Observation',
        'code': {
          'text': 'Daily Health Entry',
        },
        'valueString': latestDaily['entry'],
        'effectiveDateTime': latestDaily['recorded_at'],
      });
    }

    final medicationStatements = activeMedications
        .map((name) => {
              'resourceType': 'MedicationStatement',
              'status': 'active',
              'medicationCodeableConcept': {
                'text': name,
              },
            })
        .toList();

    final allergyIntolerances = allergies
        .map((name) => {
              'resourceType': 'AllergyIntolerance',
              'code': {
                'text': name,
              },
            })
        .toList();

    final coverage = info?.insuranceInfo.isNotEmpty == true
        ? {
            'resourceType': 'Coverage',
            'status': 'active',
            'subscriber': {
              'display': info!.name,
            },
            'payor': [
              {
                'display': info.insuranceInfo,
              }
            ],
          }
        : null;

    final relatedPerson = info?.emergencyContact.isNotEmpty == true
        ? {
            'resourceType': 'RelatedPerson',
            'name': {
              'text': info!.emergencyContact,
            },
            'telecom': [
              {
                'system': 'phone',
                'value': info.phone,
              }
            ],
          }
        : null;

    final patient = info == null
        ? null
        : {
            'resourceType': 'Patient',
            'name': [
              {
                'text': info.name,
              }
            ],
            'birthDate': info.dob,
            'gender': info.gender,
            'telecom': [
              {
                'system': 'phone',
                'value': info.phone,
              }
            ],
            'extension': [
              {
                'url': 'bloodGroup',
                'valueString': info.bloodGroup,
              },
              {
                'url': 'height',
                'valueString': info.height,
              },
              {
                'url': 'weight',
                'valueString': info.weight,
              },
            ],
          };

    final Map<String, dynamic> snapshot = {
      'snapshot_id': snapshotId,
      'generated_at': timestamp,
      'snapshot_type': type == SnapshotType.emergency ? 'emergency' : 'normal',
    };

    if (type == SnapshotType.emergency) {
      snapshot['patient'] = patient == null
          ? null
          : {
              'name': info!.name,
              'bloodGroup': info.bloodGroup,
            };
      snapshot['allergyIntolerances'] = allergyIntolerances;
      snapshot['medicationStatements'] = medicationStatements;
      snapshot['relatedPersons'] = relatedPerson == null ? [] : [relatedPerson];
    } else {
      snapshot['patient'] = patient;
      snapshot['observations'] = observationEntries;
      snapshot['medicationStatements'] = medicationStatements;
      snapshot['allergyIntolerances'] = allergyIntolerances;
      if (coverage != null) snapshot['coverage'] = coverage;
      if (relatedPerson != null) {
        snapshot['relatedPersons'] = [relatedPerson];
      }
    }

    final summary = _generateSnapshotSummary(
      info: info,
      snapshotId: snapshotId,
      timestamp: timestamp,
      type: type,
      activeMedications: activeMedications,
      allergies: allergies,
      latestSymptom: latestSymptom,
      latestDaily: latestDaily,
    );

    return HealthSnapshotResult(json: snapshot, summary: summary);
  }

  String _generateSnapshotSummary({
    required HealthUserInfo? info,
    required String snapshotId,
    required String timestamp,
    required SnapshotType type,
    required List<String> activeMedications,
    required List<String> allergies,
    required Map<String, dynamic>? latestSymptom,
    required Map<String, dynamic>? latestDaily,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('SUDHA HEALTH SNAPSHOT');
    buffer.writeln('Snapshot ID: $snapshotId');
    buffer.writeln('Generated At: $timestamp');
    buffer.writeln('Type: ${type == SnapshotType.emergency ? 'Emergency' : 'Normal'}');
    buffer.writeln('');

    if (info != null) {
      buffer.writeln('PATIENT');
      buffer.writeln('Name: ${info.name}');
      buffer.writeln('DOB: ${info.dob}');
      buffer.writeln('Gender: ${info.gender}');
      buffer.writeln('Blood Group: ${info.bloodGroup}');
      buffer.writeln('Height: ${info.height}');
      buffer.writeln('Weight: ${info.weight}');
      buffer.writeln('Phone: ${info.phone}');
      buffer.writeln('Emergency Contact: ${info.emergencyContact}');
      buffer.writeln('Insurance: ${info.insuranceInfo}');
      buffer.writeln('');
    }

    buffer.writeln('ALLERGIES');
    buffer.writeln(allergies.isEmpty ? 'None listed' : allergies.join(', '));
    buffer.writeln('');

    buffer.writeln('ACTIVE MEDICATIONS');
    buffer.writeln(activeMedications.isEmpty ? 'None listed' : activeMedications.join(', '));
    buffer.writeln('');

    if (type == SnapshotType.normal) {
      buffer.writeln('LATEST SYMPTOM LOG');
      if (latestSymptom == null) {
        buffer.writeln('No symptom log available');
      } else {
        buffer.writeln('Symptoms: ${latestSymptom['symptoms']}');
        buffer.writeln('Recorded At: ${latestSymptom['recorded_at']}');
      }
      buffer.writeln('');

      buffer.writeln('LATEST DAILY ENTRY');
      if (latestDaily == null) {
        buffer.writeln('No daily entry available');
      } else {
        buffer.writeln('Entry: ${latestDaily['entry']}');
        buffer.writeln('Recorded At: ${latestDaily['recorded_at']}');
      }
      buffer.writeln('');
    }

    return buffer.toString();
  }

  /// Generate sample FHIR bundle with patient, observations, medications, and care plan
  FhirBundle generateHealthDataBundle() {
    if (_userId == null || _userEmail == null) {
      return _createEmptyBundle();
    }

    final bundleId = 'bundle-${DateTime.now().millisecondsSinceEpoch}';
    final timestamp = DateTime.now().toIso8601String();
    final patientId = _userId!;

    // Create Patient resource
    final patient = PatientResource(
      id: patientId,
      name: _userEmail!.split('@')[0],
      email: _userEmail!,
      phone: null,
      birthDate: null,
      gender: 'unknown',
    );

    // Create sample observations (vital signs, symptoms history)
    final observations = [
      ObservationResource(
        id: 'obs-1',
        patientId: patientId,
        code: 'BP',
        display: 'Blood Pressure',
        value: '120/80',
        unit: 'mmHg',
        effectiveDateTime: DateTime.now(),
      ),
      ObservationResource(
        id: 'obs-2',
        patientId: patientId,
        code: 'HR',
        display: 'Heart Rate',
        value: '72',
        unit: 'bpm',
        effectiveDateTime: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ObservationResource(
        id: 'obs-3',
        patientId: patientId,
        code: 'SYMPTOM',
        display: 'General Health Assessment',
        value: 'Good',
        unit: 'qualitative',
        effectiveDateTime: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Create sample medication statement
    final medications = [
      MedicationStatementResource(
        id: 'med-1',
        patientId: patientId,
        medicationName: 'Multivitamin',
        dosage: '1 tablet',
        frequency: 'Once daily',
        status: 'active',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];

    // Create care plan
    final carePlan = CarePlanResource(
      id: 'plan-1',
      patientId: patientId,
      title: 'Personal Health Care Plan',
      description: 'Comprehensive health monitoring and wellness plan',
      status: 'active',
      intent: 'plan',
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
    );

    // Combine all resources into bundle
    final entries = [
      patient.toFhirJson(),
      ...observations.map((o) => o.toFhirJson()),
      ...medications.map((m) => m.toFhirJson()),
      carePlan.toFhirJson(),
    ];

    return FhirBundle(
      bundleId: bundleId,
      entries: entries,
      timestamp: timestamp,
    );
  }

  /// Generate health summary text
  String generateHealthSummary() {
    if (_userId == null || _userEmail == null) {
      return 'No health data available. Start tracking your health!';
    }

    return '''
SUDHA Health Summary
═══════════════════════════════════════

User Email: $_userEmail

VITAL SIGNS
• Blood Pressure: 120/80 mmHg
• Heart Rate: 72 bpm
• Last Updated: ${DateTime.now().toString().split('.')[0]}

RECENT OBSERVATIONS
• General Health: Good
• Observations Recorded: 3
• Historical Data: 30 days

MEDICATIONS
• Active Medications: 1
  - Multivitamin (1 tablet, Once daily)
  
CARE PLAN
• Status: Active
• Last Updated: ${DateTime.now().subtract(const Duration(days: 30)).toString().split('.')[0]}

═══════════════════════════════════════
Generated on: ${DateTime.now().toString().split('.')[0]}
''';
  }

  FhirBundle _createEmptyBundle() {
    return FhirBundle(
      bundleId: 'empty-bundle',
      entries: [],
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
