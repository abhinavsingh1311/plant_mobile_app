class PlantTask {
  final String type;
  final DateTime completedDate;
  final String? notes;

  PlantTask({
    required this.type,
    required this.completedDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'completedDate': completedDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory PlantTask.fromMap(Map<String, dynamic> map) {
    return PlantTask(
      type: map['type'] as String,
      completedDate: DateTime.parse(map['completedDate'] as String),
      notes: map['notes'] as String?,
    );
  }
}
