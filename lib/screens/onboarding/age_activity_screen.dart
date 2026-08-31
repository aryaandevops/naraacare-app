import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'gender_name_screen.dart';
import 'body_type_screen.dart';

enum ActivityLevel { sedentary, light, moderate, active }

class AgeActivityScreen extends StatefulWidget {
  final Gender gender;
  final String name;
  final double heightCm;
  final String weight;
  final bool isLb;
  final String allergy;

  const AgeActivityScreen({
    super.key,
    required this.gender,
    required this.name,
    required this.heightCm,
    required this.weight,
    required this.isLb,
    this.allergy = '',
  });

  @override
  State<AgeActivityScreen> createState() => _AgeActivityScreenState();
}

class _AgeActivityScreenState extends State<AgeActivityScreen> {
  final _ageController = TextEditingController(text: '26');
  ActivityLevel? _selectedActivity;

  bool get _isFormValid =>
      _ageController.text.trim().isNotEmpty && _selectedActivity != null;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 4 / 5,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE3F3FC),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '4/5. How old are you?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.4),
                  children: const [
                    TextSpan(
                      text: 'Why it matters? ',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
                    ),
                    TextSpan(
                        text:
                            'Organ function changes with age. Helps personalize hydration & nutrition for you.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                "What's your daily activity level?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildActivityOption(
                icon: Icons.bed_outlined,
                label: 'Little or no exercise',
                level: ActivityLevel.sedentary,
              ),
              const SizedBox(height: 10),
              _buildActivityOption(
                icon: Icons.directions_walk,
                label: 'Walks or light workouts 1-3 days',
                level: ActivityLevel.light,
              ),
              const SizedBox(height: 10),
              _buildActivityOption(
                icon: Icons.directions_run,
                label: 'Exercise 3-5 days/week',
                level: ActivityLevel.moderate,
              ),
              const SizedBox(height: 10),
              _buildActivityOption(
                icon: Icons.fitness_center,
                label: 'Exercise most days/ physical job',
                level: ActivityLevel.active,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BodyTypeScreen(
                              gender: widget.gender,
                              name: widget.name,
                              heightCm: widget.heightCm,
                              weight: widget.weight,
                              isLb: widget.isLb,
                              age: _ageController.text.trim(),
                              activity: _selectedActivity!,
                              // FIX: forward the allergy value received from
                              // WeightScreen instead of letting it dead-end here.
                              allergy: widget.allergy,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: AppColors.lightBlue,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
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

  Widget _buildActivityOption({
    required IconData icon,
    required String label,
    required ActivityLevel level,
  }) {
    final isSelected = _selectedActivity == level;
    return GestureDetector(
      onTap: () => setState(() => _selectedActivity = level),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : AppColors.textGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
