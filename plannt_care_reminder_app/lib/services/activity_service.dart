import 'package:cloud_firestore/cloud_firestore.dart';

class PlantActivity {
  final String plantId;
  final String plantName;
  final String activityType;
  final DateTime timestamp;
  final String userId;

  PlantActivity({
    required this.plantId,
    required this.plantName,
    required this.activityType,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
        'plantId': plantId,
        'plantName': plantName,
        'activityType': activityType,
        'timestamp': timestamp.toIso8601String(),
        'userId': userId,
      };

  factory PlantActivity.fromMap(Map<String, dynamic> map) => PlantActivity(
        plantId: map['plantId'],
        plantName: map['plantName'],
        activityType: map['activityType'],
        timestamp: DateTime.parse(map['timestamp']),
        userId: map['userId'],
      );
}

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logActivity({
    required String plantId,
    required String plantName,
    required String activityType,
    required String userId,
  }) async {
    final activity = PlantActivity(
      plantId: plantId,
      plantName: plantName,
      activityType: activityType,
      timestamp: DateTime.now(),
      userId: userId,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .add(activity.toMap());
  }

  Stream<List<PlantActivity>> getRecentActivities(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PlantActivity.fromMap(doc.data()))
            .toList());
  }
}
