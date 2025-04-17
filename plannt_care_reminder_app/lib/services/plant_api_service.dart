import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_guide.dart';

class PlantApiService {
  final String apiKey = 'sk-PYoh6755169cd2fa07869';
  Future<List<PlantGuide>> searchPlants(String query) async {
    try {
      // Using www subdomain
      final url = 'https://perenual.com/api/species-list?key=$apiKey&q=$query';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] == null) {
          return [];
        }
        return (data['data'] as List)
            .map((item) => PlantGuide.fromMap(item))
            .toList();
      } else {
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching plants: $e');
    }
  }

  Future<PlantGuide> getPlantDetails(int id) async {
    try {
      final url = 'https://perenual.com/api/species/details/$id?key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlantGuide.fromMap(data);
      } else {
        throw Exception('Failed to load plant details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting plant details: $e');
    }
  }
}
