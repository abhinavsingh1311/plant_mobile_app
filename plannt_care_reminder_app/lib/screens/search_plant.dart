import 'package:flutter/material.dart';
import '../services/plant_api_service.dart';
import '../models/plant_guide.dart';
import 'add_plant.dart';

class PlantSearchScreen extends StatefulWidget {
  const PlantSearchScreen({super.key});

  @override
  PlantSearchScreenState createState() => PlantSearchScreenState();
}

class PlantSearchScreenState extends State<PlantSearchScreen> {
  final _searchController = TextEditingController();
  final _plantApiService = PlantApiService();
  List<PlantGuide> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchPlants(String query) async {
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);
    try {
      final results = await _plantApiService.searchPlants(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching plants: $e')),
      );
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Plants'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a plant',
                hintText: 'Enter plant name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: _searchPlants,
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final plant = _searchResults[index];
                      return ListTile(
                        leading: plant.imageUrl != null
                            ? Image.network(
                                plant.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.local_florist),
                              )
                            : const Icon(Icons.local_florist),
                        title: Text(plant.name),
                        subtitle: Text(plant.scientificName),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddPlantScreen(selectedPlant: plant),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
