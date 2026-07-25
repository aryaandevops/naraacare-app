import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'gender_name_screen.dart';
import 'age_activity_screen.dart';
import 'body_type_screen.dart';
import 'saved_details_screen.dart';

class AvatarReadyScreen extends StatelessWidget {
  final Gender gender;
  final String name;
  final double heightCm;
  final String weight;
  final bool isLb;
  final String age;
  final ActivityLevel activity;
  final BodyType bodyType;
  final String allergy;

  const AvatarReadyScreen({
    super.key,
    required this.gender,
    required this.name,
    required this.heightCm,
    required this.weight,
    required this.isLb,
    required this.age,
    required this.activity,
    required this.bodyType,
    this.allergy = '',
  });

  String get _weightInKg {
    final rawWeight = double.tryParse(weight) ?? 0;
    if (isLb) {
      return (rawWeight * 0.453592).round().toString();
    }
    return rawWeight.round().toString();
  }

  String get _activityLabel {
    switch (activity) {
      case ActivityLevel.sedentary:
        return 'Sedentary (Little or no exercise)';
      case ActivityLevel.light:
        return 'Light (Walks or light workouts 1-3 days)';
      case ActivityLevel.moderate:
        return 'Active (Exercise 3-5 days/week)';
      case ActivityLevel.active:
        return 'Very Active (Exercise most days/physical job)';
    }
  }

  String get _bodyTypeLabel {
    switch (bodyType) {
      case BodyType.slim:
        return 'Ectomorph';
      case BodyType.average:
        return 'Mesomorph';
      case BodyType.heavy:
        return 'Endomorph';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'Your avatar is ready',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 24),

              // Placeholder avatar - replace with real generated avatar asset later
              Container(
                width: 200,
                height: 320,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  gender == Gender.male ? Icons.man : Icons.woman,
                  size: 140,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('Name:', name),
                    _buildRow('Height:', '${heightCm.round()} cm'),
                    _buildRow('Weight:', '$_weightInKg kg'),
                    _buildRow('Age:', age),
                    _buildRow('Activity:', _activityLabel),
                    _buildRow('Allergy:', allergy.isEmpty ? 'None' : allergy),
                    _buildRow('Body type:', _bodyTypeLabel),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  // TODO: save this data to Firestore once backend is live
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SavedDetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save my avatar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Edit Details',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}