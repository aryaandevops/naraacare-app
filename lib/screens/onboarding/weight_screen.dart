import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'gender_name_screen.dart';
import 'age_activity_screen.dart';

enum WeightGoal { lose, gain, none }

class WeightScreen extends StatefulWidget {
  final Gender gender;
  final String name;
  final double heightCm;
  const WeightScreen({
    super.key,
    required this.gender,
    required this.name,
    required this.heightCm,
  });

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final _weightController = TextEditingController(text: '120');
  bool _isLb = true; // true = lb, false = kg
  WeightGoal _selectedGoal = WeightGoal.none;
  final _allergyController = TextEditingController();

  bool get _isFormValid => _weightController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _weightController.dispose();
    _allergyController.dispose();
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
                  value: 3 / 5,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE3F3FC),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '3/5. Your weight?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.4),
                  children: const [
                    TextSpan(text: "We don't show anyone, not your family, not us.\n"),
                    TextSpan(
                      text: 'Why it matters? ',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
                    ),
                    TextSpan(
                        text:
                            'Your weight helps us estimate hydration needs and personalize your daily targets.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildUnitToggle(),
                ],
              ),
              const SizedBox(height: 28),

              const Text(
                'What is your goal?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildGoalOption('Lose weight', WeightGoal.lose),
              const SizedBox(height: 12),
              _buildGoalOption('Gain weight', WeightGoal.gain),
              const SizedBox(height: 28),

              const Text(
                'Any allergies?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _allergyController,
                decoration: InputDecoration(
                  hintText: 'Search allergies',
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AgeActivityScreen(
                              gender: widget.gender,
                              name: widget.name,
                              heightCm: widget.heightCm,
                              weight: _weightController.text.trim(),
                              isLb: _isLb,
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

  Widget _buildUnitToggle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _unitButton(label: 'kg', selected: !_isLb),
          _unitButton(label: 'lb', selected: _isLb),
        ],
      ),
    );
  }

  Widget _unitButton({required String label, required bool selected}) {
    return GestureDetector(
      onTap: () => setState(() => _isLb = label == 'lb'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalOption(String label, WeightGoal goal) {
    final isSelected = _selectedGoal == goal;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = goal),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}