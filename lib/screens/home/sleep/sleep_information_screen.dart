import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class SleepInformationScreen extends StatelessWidget {
  const SleepInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onClose: () => Navigator.pop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 15.5, height: 1.55, color: AppColors.textDark),
                    children: const [
                      TextSpan(text: 'The Sleep section helps you maintain a consistent sleep routine by tracking the total time you spend sleeping each day.\n\n'),
                      TextSpan(text: 'Unlike wearable-based sleep trackers, NaraaCare does not measure sleep stages such as REM, Deep Sleep, or Light Sleep. Instead, it calculates sleep duration using the bedtime and wake-up time you provide.\n\n'),
                      TextSpan(text: 'How Sleep is Calculated\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: '\nSleep Duration = Wake-up − Sleep Time\n\n', style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: 'Once both times are entered, NaraaCare automatically calculates:\n'),
                      TextSpan(text: '•   Total Sleep Duration\n•   Progress toward your daily sleep goal\n•   Sleep Score\n\n'),
                      TextSpan(text: 'Sleep Score\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: 'Your Sleep Score reflects how closely your sleep duration matches your daily goal. It is based on sleep duration only and does not evaluate sleep quality or sleep stages.\nExample:\n•   Goal: 8 hours\n•   Slept: 7 hours 45 minutes\n•   Sleep Score: 97%\n\nMaintaining a consistent sleep schedule generally leads to a higher Sleep Score over time.\n\n'),
                      TextSpan(text: 'Updating Sleep\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: 'Tap Update Sleep to record your sleep for the day.\nEnter:\n•   Sleep Start Time\n•   Wake-up Time\nThe app will automatically calculate your total sleep duration.\nIf your sleep schedule changes, you can edit the recorded times at any time.\n\n'),
                      TextSpan(text: 'Viewing Today’s Sleep\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: 'Tap your Sleep Avatar to view today’s sleep summary, including:\n•   Sleep Start Time\n•   Wake-up Time\n•   Total Sleep Duration\n•   Daily Goal\n•   Sleep Score\n\n'),
                      TextSpan(text: 'Daily Sleep Goal\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: 'Your sleep goal is determined during onboarding based on your age. You can change your preferred sleep goal at any time from your profile or sleep settings.\n\n'),
                      TextSpan(text: 'Important Note\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: 'The accuracy of your sleep summary depends on the accuracy of the information you provide.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
    child: Row(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF71838C), width: 3)),
            child: const Icon(Icons.close, color: Color(0xFF71838C), size: 28),
          ),
        ),
        const Expanded(child: Center(child: Text('Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
        const SizedBox(width: 44),
      ],
    ),
  );
}
