import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant.dart';
import '../models/plant_task.dart';

class PlantProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Plant> _plants = [];
  bool _isLoading = false;

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;

  Future<void> loadPlants(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .get();

      _plants = snapshot.docs
          .map((doc) => Plant.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load plants: $e');
    }
  }

  Future<void> addPlant({
    required String userId,
    required String name,
    required String species,
    required bool isIndoor,
    required String lightRequirement,
    required String wateringFrequency,
    required String imageUrl, // Now passed directly
  }) async {
    try {
      final now = DateTime.now();
      DateTime nextWaterDate =
          now.add(wateringFrequency.toLowerCase().contains('daily')
              ? const Duration(days: 1)
              : wateringFrequency.toLowerCase().contains('weekly')
                  ? const Duration(days: 7)
                  : const Duration(days: 3));

      final plant = Plant(
        id: '',
        name: name,
        species: species,
        imageUrl: imageUrl, // Set directly from PlantGuide or default
        isIndoor: isIndoor,
        lastWatered: now,
        nextWaterDate: nextWaterDate,
        lightRequirement: lightRequirement,
        healthStatus: 'Good',
        addedDate: now,
        wateringFrequency: wateringFrequency,
        completedTasks: [],
      );

      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .add(plant.toMap());

      final newPlant = plant.copyWith(id: docRef.id);
      _plants.add(newPlant);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add plant: $e');
    }
  }

  Future<void> updatePlant(String userId, Plant plant) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(plant.id)
          .update(plant.toMap());

      final index = _plants.indexWhere((p) => p.id == plant.id);
      if (index != -1) {
        _plants[index] = plant;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update plant: $e');
    }
  }

  Future<void> deletePlant(String userId, String plantId) async {
    try {
      // No image to delete, remove plant directly
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(plantId)
          .delete();

      _plants.removeWhere((p) => p.id == plantId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete plant: $e');
    }
  }

  Future<void> waterPlant(String userId, String plantId) async {
    try {
      final plant = _plants.firstWhere((p) => p.id == plantId);
      final now = DateTime.now();

      DateTime nextWaterDate =
          now.add(plant.wateringFrequency.toLowerCase().contains('daily')
              ? const Duration(days: 1)
              : plant.wateringFrequency.toLowerCase().contains('weekly')
                  ? const Duration(days: 7)
                  : const Duration(days: 3));

      final List<PlantTask> updatedTasks = [
        ...plant.completedTasks,
        PlantTask(
          type: 'watering',
          completedDate: now,
        ),
      ];

      final updatedPlant = plant.copyWith(
        lastWatered: now,
        nextWaterDate: nextWaterDate,
        completedTasks: updatedTasks,
      );

      await updatePlant(userId, updatedPlant);
    } catch (e) {
      throw Exception('Failed to water plant: $e');
    }
  }

  Future<void> updatePlantHealth(
      String userId, String plantId, String newStatus) async {
    try {
      final plant = _plants.firstWhere((p) => p.id == plantId);

      final updatedPlant = plant.copyWith(
        healthStatus: newStatus,
        completedTasks: [
          ...plant.completedTasks,
          PlantTask(
            type: 'health_check',
            completedDate: DateTime.now(),
            notes: 'Health status updated to: $newStatus',
          ),
        ],
      );

      await updatePlant(userId, updatedPlant);
    } catch (e) {
      throw Exception('Failed to update plant health: $e');
    }
  }

  Future<void> prunePlant(String userId, String plantId) async {
    try {
      final plant = _plants.firstWhere((p) => p.id == plantId);
      final now = DateTime.now();

      final updatedPlant = plant.copyWith(
        lastPruned: now,
        completedTasks: [
          ...plant.completedTasks,
          PlantTask(
            type: 'pruning',
            completedDate: now,
          ),
        ],
      );

      await updatePlant(userId, updatedPlant);
    } catch (e) {
      throw Exception('Failed to record pruning: $e');
    }
  }

  List<Plant> getPlantsNeedingAttention() {
    final now = DateTime.now();
    return _plants.where((plant) {
      if (plant.nextWaterDate.isBefore(now)) return true;
      if (plant.healthStatus != 'Good') return true;

      if (plant.lastPruned != null) {
        final daysSinceLastPruning = now.difference(plant.lastPruned!).inDays;
        if (daysSinceLastPruning >= 30) return true;
      }

      return false;
    }).toList();
  }
}
