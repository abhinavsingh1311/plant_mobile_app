// lib/screens/home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/plant_provider.dart';
import '../providers/units_provider.dart';
import '../models/plant.dart';
import '../services/weather_services.dart';
import 'package:weather/weather.dart';
import 'search_plant.dart';
import 'plants_screen.dart';
import 'profile_screen.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardTab(),
      const PlantsScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlantSearchScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  DashboardTabState createState() => DashboardTabState();
}

class DashboardTabState extends State<DashboardTab> {
  final WeatherService _weatherService = WeatherService();
  Weather? _currentWeather;
  bool _isLoadingWeather = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await _weatherService.getCurrentWeather();
      if (!mounted) return;
      setState(() {
        _currentWeather = weather;
        _isLoadingWeather = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingWeather = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().userProfile;
    final plants = context.watch<PlantProvider>().plants;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await _loadWeather();
          if (user != null) {
            if(!context.mounted)return;
            await context.read<PlantProvider>().loadPlants(user.id);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${user?.name ?? 'to Plant Care'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildTasksCard(context, plants, user?.id),
              const SizedBox(height: 16),
              _buildWeatherCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksCard(
      BuildContext context, List<Plant> plants, String? userId) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.task_alt, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTasksList(context, plants, userId),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(
      BuildContext context, List<Plant> plants, String? userId) {
    final todaysTasks = plants
        .where((plant) =>
            plant.nextWaterDate.difference(DateTime.now()).inDays <= 0)
        .toList();

    if (todaysTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'No tasks for today!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todaysTasks.length,
      itemBuilder: (context, index) {
        final plant = todaysTasks[index];
        return Dismissible(
          key: Key(plant.id),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (direction) async {
            if (userId == null) return false;
            try {
              await context.read<PlantProvider>().waterPlant(userId, plant.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${plant.name} has been watered!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
              return true;
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              return false;
            }
          },
          background: Container(
            color: Colors.green.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Icon(Icons.check, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Water Plant',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green,
                      ),
                ),
              ],
            ),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              leading: Hero(
                tag: 'plant-task-${plant.id}',
                child: CircleAvatar(
                  backgroundImage: plant.imageUrl.isNotEmpty
                      ? NetworkImage(plant.imageUrl)
                      : null,
                  child: plant.imageUrl.isEmpty
                      ? const Icon(Icons.water_drop, color: Colors.blue)
                      : null,
                ),
              ),
              title: Text(plant.name),
              subtitle: Text(
                'Needs watering',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: ElevatedButton(
                onPressed: userId == null
                    ? null
                    : () async {
                        try {
                          await context
                              .read<PlantProvider>()
                              .waterPlant(userId, plant.id);
                          if(!context.mounted)return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plant.name} has been watered!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Water'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Weather',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWeatherInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(BuildContext context) {
    if (_isLoadingWeather) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentWeather == null) {
      return const Text('Unable to load weather information');
    }

    final selectedUnit = context.watch<UnitsProvider>().selectedUnit;
    final tempInCelsius = _currentWeather!.temperature?.celsius ?? 0;
    final displayTemp = selectedUnit == 'Imperial'
        ? (tempInCelsius * 9 / 5) + 32
        : tempInCelsius;
    final tempUnit = selectedUnit == 'Imperial' ? '°F' : '°C';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${displayTemp.toStringAsFixed(1)}$tempUnit',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            Icon(
              _getWeatherIcon(_currentWeather!.weatherMain ?? ''),
              size: 40,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(_currentWeather!.weatherMain ?? ''),
        const SizedBox(height: 16),
        Text(
          'Watering Advice:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(_weatherService.getWateringAdvice(_currentWeather!, selectedUnit)),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('rain')) return Icons.water_drop;
    if (condition.contains('cloud')) return Icons.cloud;
    if (condition.contains('snow')) return Icons.ac_unit;
    return Icons.wb_sunny;
  }
}
