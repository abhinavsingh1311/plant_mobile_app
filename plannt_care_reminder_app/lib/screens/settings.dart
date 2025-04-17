import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/units_provider.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final selectedUnit = context.watch<UnitsProvider>().selectedUnit;
    final units = ['Metric', 'Imperial'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              // Theme Settings
              _buildSectionHeader(context, 'Appearance'),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark/light theme'),
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeProvider>().setDarkMode(value);
                },
              ),
              const Divider(),

              // Units Preference
              _buildSectionHeader(context, 'Units'),
              ListTile(
                title: const Text('Measurement System'),
                subtitle: Text('Currently using $selectedUnit'),
                trailing: DropdownButton<String>(
                  value: selectedUnit,
                  items: units.map((String unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<UnitsProvider>().setUnit(newValue);
                    }
                  },
                ),
              ),
              const Divider(),

              // Account Settings
              _buildSectionHeader(context, 'Account'),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile Settings'),
                subtitle: Text(
                  context.read<AuthProvider>().userProfile?.email ??
                      'Not signed in',
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Delete Account'),
                subtitle:
                    const Text('Permanently delete your account and data'),
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => _showDeleteAccountDialog(context),
              ),
              const Divider(),

              // App Information
              _buildSectionHeader(context, 'About'),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('App Version'),
                subtitle: Text('1.0.0'),
              ),
              const SizedBox(height: 24),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _isLoading = true);
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Delete user data from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Delete user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete Firebase Auth account
      await user.delete();
      if(!mounted)return;
      // Sign out
      await context.read<AuthProvider>().signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
