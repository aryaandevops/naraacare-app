import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'gender_name_screen.dart';
import '../home/home_screen.dart';

class SavedDetailsScreen extends StatefulWidget {
  final String name;
  final Gender gender;

  const SavedDetailsScreen({
    super.key,
    required this.name,
    required this.gender,
  });

  @override
  State<SavedDetailsScreen> createState() => _SavedDetailsScreenState();
}

class _SavedDetailsScreenState extends State<SavedDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // FIX: previously did `popUntil isFirst`, which just sent the user
      // back to the splash screen instead of into the app. Now routes into
      // the real Home screen and clears the onboarding stack behind it.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            name: widget.name,
            gender: widget.gender,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, color: Colors.green, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Saved Details',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Redirecting in a moment...',
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
