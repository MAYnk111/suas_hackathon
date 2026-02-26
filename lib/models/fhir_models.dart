import 'dart:convert';

class PatientResource {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final String? gender;

  PatientResource({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
    this.gender,
  });

  Map<String, dynamic> toFhirJson() => {
    'resourceType': 'Patient',
    'id': id,
    'name': [
      {
        'use': 'official',
        'text': name,
      }
    ],
    'telecom': [
      {
        'system': 'email',
        'value': email,
      },
      if (phone != null)
        {
          'system': 'phone',
          'value': phone,
        }
    ],
    'birthDate': birthDate?.toIso8601String().split('T')[0],
    'gender': gender ?? 'unknown',
    'meta': {
      'lastUpdated': DateTime.now().toIso8601String(),
    },
  };
}

class ObservationResource {
  final String id;
  final String patientId;
  final String code;
  final String display;
  final String value;
  final String unit;
  final DateTime effectiveDateTime;

  ObservationResource({
    required this.id,
    required this.patientId,
    required this.code,
    required this.display,
    required this.value,
    required this.unit,
    required this.effectiveDateTime,
  });

  Map<String, dynamic> toFhirJson() => {
    'resourceType': 'Observation',
    'id': id,
    'status': 'final',
    'category': [
      {
        'coding': [
          {
            'system': 'http://terminology.hl7.org/CodeSystem/observation-category',
            'code': 'vital-signs',
            'display': 'Vital Signs',
          }
        ]
      }
    ],
    'code': {
      'coding': [
        {
          'code': code,
          'display': display,
        }
      ],
      'text': display,
    },
    'subject': {
      'reference': 'Patient/$patientId',
    },
    'effectiveDateTime': effectiveDateTime.toIso8601String(),
    'valueQuantity': {
      'value': value,
      'unit': unit,
    },
    'meta': {
      'lastUpdated': DateTime.now().toIso8601String(),
    },
  };
}

class MedicationStatementResource {
  final String id;
  final String patientId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;

  MedicationStatementResource({
    required this.id,
    required this.patientId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.status,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toFhirJson() => {
    'resourceType': 'MedicationStatement',
    'id': id,
    'status': status,
    'medicationCodeableConcept': {
      'text': medicationName,
    },
    'subject': {
      'reference': 'Patient/$patientId',
    },
    'effectivePeriod': {
      'start': startDate.toIso8601String(),
      if (endDate != null) 'end': endDate?.toIso8601String(),
    },
    'dosage': [
      {
        'text': '$dosage $frequency',
      }
    ],
    'meta': {
      'lastUpdated': DateTime.now().toIso8601String(),
    },
  };
}

class CarePlanResource {
  final String id;
  final String patientId;
  final String title;
  final String description;
  final String status;
  final String intent;
  final DateTime createdDate;

  CarePlanResource({
    required this.id,
    required this.patientId,
    required this.title,
    required this.description,
    required this.status,
    required this.intent,
    required this.createdDate,
  });

  Map<String, dynamic> toFhirJson() => {
    'resourceType': 'CarePlan',
    'id': id,
    'status': status,
    'intent': intent,
    'title': title,
    'description': description,
    'subject': {
      'reference': 'Patient/$patientId',
    },
    'created': createdDate.toIso8601String(),
    'meta': {
      'lastUpdated': DateTime.now().toIso8601String(),
    },
  };
}

class FhirBundle {
  final String bundleId;
  final List<Map<String, dynamic>> entries;
  final String timestamp;

  FhirBundle({
    required this.bundleId,
    required this.entries,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'resourceType': 'Bundle',
    'id': bundleId,
    'type': 'transaction',
    'timestamp': timestamp,
    'entry': entries.map((e) => {'resource': e}).toList(),
    'meta': {
      'lastUpdated': timestamp,
      'version': '1.0',
    },
  };

  String toJsonString() => jsonEncode(toJson());
  String toFormattedJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
