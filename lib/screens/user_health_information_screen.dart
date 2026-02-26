import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/health_data_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class UserHealthInformationScreen extends StatefulWidget {
  const UserHealthInformationScreen({super.key});

  @override
  State<UserHealthInformationScreen> createState() => _UserHealthInformationScreenState();
}

class _UserHealthInformationScreenState extends State<UserHealthInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _phoneController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _insuranceController = TextEditingController();

  String _gender = 'Select';
  String _bloodGroup = 'Select';

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _phoneController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _emergencyContactController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthData = context.read<HealthDataProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Health Information'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SectionHeader(
              title: 'Health Information',
              subtitle: 'Complete your health profile for snapshots',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => _required(value, 'Name'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                      onTap: () => _pickDob(context),
                      validator: (value) => _required(value, 'Date of birth'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: const [
                        DropdownMenuItem(value: 'Select', child: Text('Select gender')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) => setState(() => _gender = value ?? 'Select'),
                      validator: (value) => value == 'Select' ? 'Select gender' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _bloodGroup,
                      decoration: const InputDecoration(labelText: 'Blood Group'),
                      items: const [
                        DropdownMenuItem(value: 'Select', child: Text('Select blood group')),
                        DropdownMenuItem(value: 'A+', child: Text('A+')),
                        DropdownMenuItem(value: 'A-', child: Text('A-')),
                        DropdownMenuItem(value: 'B+', child: Text('B+')),
                        DropdownMenuItem(value: 'B-', child: Text('B-')),
                        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        DropdownMenuItem(value: 'O+', child: Text('O+')),
                        DropdownMenuItem(value: 'O-', child: Text('O-')),
                      ],
                      onChanged: (value) => setState(() => _bloodGroup = value ?? 'Select'),
                      validator: (value) => value == 'Select' ? 'Select blood group' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Height (cm)'),
                      validator: (value) => _required(value, 'Height'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Weight (kg)'),
                      validator: (value) => _required(value, 'Weight'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (value) => _required(value, 'Phone'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _allergiesController,
                      decoration: const InputDecoration(labelText: 'Allergies (required)'),
                      validator: (value) => _required(value, 'Allergies'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _medicationsController,
                      decoration: const InputDecoration(labelText: 'Medications'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _emergencyContactController,
                      decoration: const InputDecoration(labelText: 'Emergency Contact'),
                      validator: (value) => _required(value, 'Emergency contact'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _insuranceController,
                      decoration: const InputDecoration(labelText: 'Insurance Info'),
                      validator: (value) => _required(value, 'Insurance info'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!(_formKey.currentState?.validate() ?? false)) return;

                          final info = HealthUserInfo(
                            name: _nameController.text.trim(),
                            dob: _dobController.text.trim(),
                            gender: _gender,
                            bloodGroup: _bloodGroup,
                            height: _heightController.text.trim(),
                            weight: _weightController.text.trim(),
                            phone: _phoneController.text.trim(),
                            allergies: _allergiesController.text.trim(),
                            medications: _medicationsController.text.trim(),
                            emergencyContact: _emergencyContactController.text.trim(),
                            insuranceInfo: _insuranceController.text.trim(),
                          );

                          await healthData.saveUserHealthInfo(info);

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Health information saved')),
                          );
                          Navigator.pop(context, true);
                        },
                        child: const Text('Save Information'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  Future<void> _pickDob(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );
    if (picked != null) {
      _dobController.text = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }
}
