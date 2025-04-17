class PlantGuide {
  final String name;
  final String scientificName;
  final String wateringFrequency;
  final String lightRequirement;
  final List<String> commonProblems;
  final List<String> tips;
  final String? imageUrl;

  PlantGuide({
    required this.name,
    required this.scientificName,
    required this.wateringFrequency,
    required this.lightRequirement,
    this.commonProblems = const [],
    this.tips = const [],
    this.imageUrl,
  });

  factory PlantGuide.fromMap(Map<String, dynamic> map) {
    String getScientificName(dynamic scientificName) {
      if (scientificName is List) {
        return scientificName.isNotEmpty ? scientificName[0] : '';
      }
      return scientificName?.toString() ?? '';
    }

    String getLightRequirement(dynamic sunlight) {
      if (sunlight is List) {
        return sunlight.join(', ');
      }
      return sunlight?.toString() ?? 'Moderate light';
    }

    String? getImageUrl(Map<String, dynamic> map) {
      final defaultImage = map['default_image'];
      if (defaultImage != null && defaultImage is Map) {
        return defaultImage['regular_url'] as String?;
      }
      return null;
    }

    return PlantGuide(
      name: map['common_name'] ?? '',
      scientificName: getScientificName(map['scientific_name']),
      wateringFrequency: map['watering'] ?? 'Average',
      lightRequirement: getLightRequirement(map['sunlight']),
      imageUrl: getImageUrl(map),
    );
  }
}
