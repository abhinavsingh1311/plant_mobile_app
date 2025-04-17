import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/plant_card.dart';
import './search_plant.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  PlantsScreenState createState() => PlantsScreenState();
}

class PlantsScreenState extends State<PlantsScreen> {
  bool _isIndoorSelected = true;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    final userId = context.read<AuthProvider>().userProfile?.id;
    if (userId != null) {
      await context.read<PlantProvider>().loadPlants(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        actions: [
          // Filter toggle
          TextButton.icon(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            label: Text(
              _isIndoorSelected ? 'Indoor' : 'Outdoor',
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _isIndoorSelected = !_isIndoorSelected;
              });
            },
          ),
        ],
      ),
      body: Consumer<PlantProvider>(
        builder: (context, plantProvider, child) {
          if (plantProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredPlants = plantProvider.plants
              .where((plant) => plant.isIndoor == _isIndoorSelected)
              .toList();

          if (filteredPlants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_florist_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ${_isIndoorSelected ? 'indoor' : 'outdoor'} plants yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first plant by tapping the + button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlantSearchScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Plant'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadPlants,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredPlants.length,
              itemBuilder: (context, index) {
                final plant = filteredPlants[index];
                return PlantCard(plant: plant);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlantSearchScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
