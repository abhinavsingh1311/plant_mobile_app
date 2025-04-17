import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../providers/plant_provider.dart';
import '../providers/auth_provider.dart';

class PlantDetailsScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailsScreen({super.key, required this.plant});

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().userProfile?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          // Delete plant action
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: userId == null
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Plant'),
                        content: Text(
                            'Are you sure you want to delete ${plant.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context
                                  .read<PlantProvider>()
                                  .deletePlant(userId, plant.id);
                              if (context.mounted) {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(
                                    context); // Return to previous screen
                              }
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant image
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: plant.imageUrl.isNotEmpty
                  ? Image.network(
                      plant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_florist,
                        size: 64,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.local_florist,
                      size: 64,
                      color: Colors.grey,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    context,
                    'Basic Information',
                    [
                      _buildInfoRow(Icons.eco, 'Species', plant.species),
                      _buildInfoRow(
                        Icons.home,
                        'Location',
                        plant.isIndoor ? 'Indoor' : 'Outdoor',
                      ),
                      _buildInfoRow(
                        Icons.wb_sunny,
                        'Light Requirement',
                        plant.lightRequirement,
                      ),
                      _buildInfoRow(
                        Icons.favorite,
                        'Health Status',
                        plant.healthStatus,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Watering Schedule',
                    [
                      _buildInfoRow(
                        Icons.history,
                        'Last Watered',
                        _formatDate(plant.lastWatered),
                      ),
                      _buildInfoRow(
                        Icons.event,
                        'Next Watering',
                        _formatDate(plant.nextWaterDate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Water now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.water_drop),
                      label: const Text('Water Now'),
                      onPressed: userId == null
                          ? null
                          : () async {
                              try {
                                await context
                                    .read<PlantProvider>()
                                    .waterPlant(userId, plant.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${plant.name} has been watered!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error watering plant: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Care tips section
                  _buildInfoCard(
                    context,
                    'Care Tips',
                    const [
                      ListTile(
                        leading:
                            Icon(Icons.tips_and_updates, color: Colors.amber),
                        title: Text('Water thoroughly when top soil feels dry'),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.tips_and_updates, color: Colors.amber),
                        title: Text('Maintain appropriate light conditions'),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.tips_and_updates, color: Colors.amber),
                        title: Text('Prune dead or yellowing leaves regularly'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
