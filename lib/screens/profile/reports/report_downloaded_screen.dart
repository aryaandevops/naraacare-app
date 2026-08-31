import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class ReportDownloadedScreen extends StatelessWidget {
  const ReportDownloadedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0FCF8),
                boxShadow: [BoxShadow(color: const Color(0xFFB6EEDD).withValues(alpha: .45), blurRadius: 0, spreadRadius: 16)],
              ),
              child: Container(
                margin: const EdgeInsets.all(28),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: const Icon(Icons.verified_rounded, color: Color(0xFF16AE7B), size: 42),
              ),
            ),
            const SizedBox(height: 38),
            const Text('Report\nDownloaded', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: AppColors.textDark, height: 1.1)),
            const SizedBox(height: 10),
            const Text('Your report has been saved to\nyour device.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF6C828D), height: 1.4)),
            const SizedBox(height: 34),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6EBEE)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.description_outlined, color: AppColors.textDark, size: 25),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hydration & Nutrition Report', style: TextStyle(fontSize: 17, color: AppColors.textDark)),
                          SizedBox(height: 3),
                          Text('1 May - 31 May 2026', style: TextStyle(fontSize: 12, color: Color(0xFF748A95))),
                          SizedBox(height: 2),
                          Text('Size: 1.2MB', style: TextStyle(fontSize: 12, color: Color(0xFF748A95))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            TextButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('Done', style: TextStyle(color: AppColors.primaryBlue, fontSize: 15))),
            const SizedBox(height: 18),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 8, offset: const Offset(0, -2))]),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _nav(Icons.home_outlined, 'Home', false),
            _nav(Icons.groups_outlined, 'Care Circle', false),
            _nav(Icons.auto_awesome_outlined, 'Rin AI', false),
            _nav(Icons.person_outline, 'Profile', true),
          ],
        ),
      ),
    );
  }

  Widget _nav(IconData icon, String label, bool selected) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 25, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)))]);
}
