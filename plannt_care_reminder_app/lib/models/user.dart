class UserProfile {
  final String id;
  final String name;
  final String email;
  final DateTime memberSince;
  final int totalPlants;
  final int plantsThriving;
  final int careStreak;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
    this.totalPlants = 0,
    this.plantsThriving = 0,
    this.careStreak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'memberSince': memberSince.toIso8601String(),
      'totalPlants': totalPlants,
      'plantsThriving': plantsThriving,
      'careStreak': careStreak,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      memberSince: DateTime.parse(map['memberSince']),
      totalPlants: map['totalPlants'],
      plantsThriving: map['plantsThriving'],
      careStreak: map['careStreak'],
    );
  }
}
