import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../providers/auth_provider.dart';
import '../models/plant_guide.dart';

class AddPlantScreen extends StatefulWidget {
  final PlantGuide selectedPlant;

  const AddPlantScreen({
    super.key,
    required this.selectedPlant,
  });

  @override
  AddPlantScreenState createState() => AddPlantScreenState();
}

class AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isIndoor = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.selectedPlant.name);
  }

  Future<void> _addPlant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userId = context.read<AuthProvider>().userProfile?.id;
      if (userId == null) throw Exception('User not logged in');

      // Use the imageUrl from PlantGuide or a default placeholder
      final imageUrl = widget.selectedPlant.imageUrl ??
          'https://via.placeholder.com/150'; // Default image

      await context.read<PlantProvider>().addPlant(
            userId: userId,
            name: _nameController.text,
            species: widget.selectedPlant.scientificName,
            isIndoor: _isIndoor,
            lightRequirement: widget.selectedPlant.lightRequirement,
            wateringFrequency: widget.selectedPlant.wateringFrequency,
            imageUrl: imageUrl, // Set directly
          );

      if (!mounted) return;
      Navigator.of(context).pop(); // Close AddPlantScreen
      Navigator.of(context)
          .pop(); // Possibly close PlantSearchScreen or wherever we came from
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding plant: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildPlantInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedPlant.imageUrl != null)
              Center(
                child: Image.network(
                  widget.selectedPlant.imageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_florist, size: 100),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              widget.selectedPlant.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.selectedPlant.scientificName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text('Watering: ${widget.selectedPlant.wateringFrequency}'),
            Text('Light: ${widget.selectedPlant.lightRequirement}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Custom Name',
            hintText: 'Give your plant a personal name',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a name' : null,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Location:'),
                const Spacer(),
                ToggleButtons(
                  isSelected: [_isIndoor, !_isIndoor],
                  onPressed: (index) {
                    setState(() => _isIndoor = index == 0);
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Indoor'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Outdoor'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Removed image upload button and image display
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _addPlant,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Add to My Plants'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to My Plants'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildPlantInfoCard(),
            const SizedBox(height: 16),
            _buildCustomizationFields(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
