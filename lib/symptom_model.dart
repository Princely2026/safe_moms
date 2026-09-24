class SymptomLog {
  final int? id;
  final String loggedDate;
  final String weight;
  final String systolicBp;
  final String diastolicBp;
  final String symptomNotes;

  const SymptomLog({
    this.id,
    required this.loggedDate,
    required this.weight,
    required this.systolicBp,
    required this.diastolicBp,
    required this.symptomNotes,
  });

  // Converts a structured Object class into an index card Map string for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logged_date': loggedDate,
      'weight': weight,
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'symptom_notes': symptomNotes,
    };
  }

  // Re-builds a structured Object class blueprint from an offline SQLite query database row entry
  factory SymptomLog.fromMap(Map<String, dynamic> map) {
    return SymptomLog(
      id: map['id'] as int?,
      loggedDate: map['logged_date'] as String,
      weight: map['weight'] as String,
      systolicBp: map['systolic_bp'] as String,
      diastolicBp: map['diastolic_bp'] as String,
      symptomNotes: map['symptom_notes'] as String,
    );
  }
}
