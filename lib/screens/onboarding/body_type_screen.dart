import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'gender_name_screen.dart';
import 'age_activity_screen.dart';
import 'avatar_ready_screen.dart';

enum BodyType { slim, average, heavy }

class BodyTypeScreen extends StatefulWidget {
  final Gender gender;
  final String name;
  final double heightCm;
  final String weight;
  final bool isLb;
  final String age;
  final ActivityLevel activity;
  final String allergy;

  const BodyTypeScreen({
    super.key,
    required this.gender,
    required this.name,
    required this.heightCm,
    required this.weight,
    required this.isLb,
    required this.age,
    required this.activity,
    this.allergy = '',
  });

  @override
  State<BodyTypeScreen> createState() => _BodyTypeScreenState();
}

class _BodyTypeScreenState extends State<BodyTypeScreen> {
  BodyType _selectedType = BodyType.average;

  String get _avatarAsset => widget.gender == Gender.male
      ? 'lib/assets/images/avatar_male.png'
      : 'lib/assets/images/avatar_female.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 5 / 5,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE3F3FC),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '5/5. Your body type',
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
                            'It gives us a better understanding of your metabolic needs. Select what best represents you from the 3 types.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBodyOption(BodyType.slim, 'Slim'),
                    _buildBodyOption(BodyType.average, 'Average'),
                    _buildBodyOption(BodyType.heavy, 'Heavy'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AvatarReadyScreen(
                        gender: widget.gender,
                        name: widget.name,
                        heightCm: widget.heightCm,
                        weight: widget.weight,
                        isLb: widget.isLb,
                        age: widget.age,
                        activity: widget.activity,
                        bodyType: _selectedType,
                        // FIX: forward the allergy value all the way through
                        // instead of dropping it here.
                        allergy: widget.allergy,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
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

  // NOTE: there are no dedicated ectomorph/mesomorph/endomorph art assets in
  // the project yet (only one avatar_male.png / avatar_female.png). Until
  // those exist, we visually differentiate the three options by horizontally
  // scaling the same avatar image (narrower for slim, wider for heavy) so the
  // selection at least *looks* different and the choice carries through to
  // the "avatar ready" screen. Swap the `Image.asset` below for real
  // per-body-type art as soon as it's available.
  Widget _buildBodyOption(BodyType type, String label) {
    final isSelected = _selectedType == type;
    final scale = isSelected ? 1.15 : 0.85;
    final widthScale = switch (type) {
      BodyType.slim => 0.8,
      BodyType.average => 1.0,
      BodyType.heavy => 1.25,
    };

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSelected ? 1.0 : 0.4,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: scale,
              child: Container(
                width: 90,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Transform.scale(
                    scaleX: widthScale,
                    child: Image.asset(
                      _avatarAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
