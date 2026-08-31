import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class WaterInformationScreen extends StatelessWidget {
  const WaterInformationScreen({super.key});

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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p(
                        'NaraaCare calculates your daily hydration goal based on your '
                        'personal profile and daily conditions. To ensure accurate '
                        'recommendations, please keep the following information up to date.',
                      ),
                      const SizedBox(height: 16),
                      _p('Why do we ask for these parameters?'),
                      const SizedBox(height: 16),
                      _heading('Temperature'),
                      _p(
                        'Your surrounding temperature influences your daily water '
                        'requirement. Please update it whenever it changes. If no '
                        'temperature is recorded for a day, NaraaCare may pause '
                        'hydration calculations until a new value is entered.',
                      ),
                      const SizedBox(height: 16),
                      _heading('Physical Activity'),
                      _p(
                        'Exercise increases fluid loss through perspiration. Update '
                        'your workout intensity and duration so your hydration goal '
                        'reflects your daily activity.',
                      ),
                      const SizedBox(height: 16),
                      _heading('Logging Your Water Intake'),
                      _p('You can record your water intake in two ways:'),
                      _bullet('Quick Add: Tap the avatar to instantly add 100 ml of water.'),
                      _bullet(
                        'Add Water/Drink: Use the Add Water/Drink button to log custom '
                        'amounts of water or other beverages.',
                      ),
                      const SizedBox(height: 16),
                      _heading('Logging Other Beverages'),
                      _p(
                        'Besides water, you can record beverages such as coconut water, '
                        'buttermilk, milk, tea, coffee, juices, and other drinks. Select '
                        'the beverage and enter the quantity consumed to include it in '
                        'your daily hydration record.',
                      ),
                      const SizedBox(height: 16),
                      _heading('Editing Recent Entries'),
                      _p(
                        'Your two most recent hydration entries can be edited if you '
                        'need to correct the drink type or quantity.',
                      ),
                      const SizedBox(height: 16),
                      _p('For the most reliable hydration recommendations:'),
                      _bullet('Update your body temperature daily.'),
                      _bullet('Record workouts when you exercise.'),
                      _bullet('Log water and beverages as soon as you consume them.'),
                      _bullet('Keep your profile information up to date.'),
                      const SizedBox(height: 16),
                      _p(
                        'These updates help NaraaCare continuously calculate a '
                        "hydration goal that's tailored to your body's daily needs.",
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      );

  Widget _p(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text, style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5)),
      );

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  ', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5)),
            ),
          ],
        ),
      );
}
