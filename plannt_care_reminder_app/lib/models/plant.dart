import 'plant_task.dart';

class Plant {
  final String id;
  final String name;
  final String species;
  final String imageUrl;
  final bool isIndoor;
  final String lightRequirement;
  final String wateringFrequency;
  final DateTime lastWatered;
  final DateTime nextWaterDate;
  final DateTime addedDate;
  final DateTime? lastPruned;
  final String healthStatus;
  final List<PlantTask> completedTasks;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.isIndoor,
    required this.lightRequirement,
    required this.wateringFrequency,
    required this.lastWatered,
    required this.nextWaterDate,
    required this.addedDate,
    required this.healthStatus,
    this.lastPruned,
    this.completedTasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'species': species,
      'imageUrl': imageUrl,
      'isIndoor': isIndoor,
      'lightRequirement': lightRequirement,
      'wateringFrequency': wateringFrequency,
      'lastWatered': lastWatered.toIso8601String(),
      'nextWaterDate': nextWaterDate.toIso8601String(),
      'addedDate': addedDate.toIso8601String(),
      'lastPruned': lastPruned?.toIso8601String(),
      'healthStatus': healthStatus,
      'completedTasks': completedTasks.map((task) => task.toMap()).toList(),
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as String,
      name: map['name'] as String,
      species: map['species'] as String,
      imageUrl: map['imageUrl'] as String,
      isIndoor: map['isIndoor'] as bool,
      lightRequirement: map['lightRequirement'] as String,
      wateringFrequency: map['wateringFrequency'] as String,
      lastWatered: DateTime.parse(map['lastWatered']),
      nextWaterDate: DateTime.parse(map['nextWaterDate']),
      addedDate: DateTime.parse(map['addedDate']),
      lastPruned:
          map['lastPruned'] != null ? DateTime.parse(map['lastPruned']) : null,
      healthStatus: map['healthStatus'] as String,
      completedTasks: (map['completedTasks'] as List<dynamic>?)
              ?.map((taskMap) =>
                  PlantTask.fromMap(taskMap as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Plant copyWith({
    String? id,
    String? name,
    String? species,
    String? imageUrl,
    bool? isIndoor,
    String? lightRequirement,
    String? wateringFrequency,
    DateTime? lastWatered,
    DateTime? nextWaterDate,
    DateTime? addedDate,
    DateTime? lastPruned,
    String? healthStatus,
    List<PlantTask>? completedTasks,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      imageUrl: imageUrl ?? this.imageUrl,
      isIndoor: isIndoor ?? this.isIndoor,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWaterDate: nextWaterDate ?? this.nextWaterDate,
      addedDate: addedDate ?? this.addedDate,
      lastPruned: lastPruned ?? this.lastPruned,
      healthStatus: healthStatus ?? this.healthStatus,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
