import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'report_customize_screen.dart';

class DownloadReportScreen extends StatefulWidget {
  const DownloadReportScreen({super.key});

  @override
  State<DownloadReportScreen> createState() => _DownloadReportScreenState();
}

class _DownloadReportScreenState extends State<DownloadReportScreen> {
  bool get _isStar => true;

  void _openCustomize() {
    if (!_isStar) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CustomizeReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          children: [
            _header(context, 'Download Report'),
            const SizedBox(height: 20),
            const Text('Create new report', style: TextStyle(color: Color(0xFF8EA5AF), fontSize: 14)),
            const SizedBox(height: 14),
            _reportCard(
              title: 'Monthly Report',
              subtitle: 'Get a summary of your data for any month.',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomizeReportScreen(isMonthly: true)),
              ),
            ),
            const SizedBox(height: 12),
            _reportCard(
              title: 'Custom Report',
              subtitle: 'Get a summary & insights for any date range.',
              premium: !_isStar,
              disabled: !_isStar,
              onTap: _openCustomize,
            ),
            const SizedBox(height: 42),
            const Text("What's included", style: TextStyle(color: Color(0xFF8EA5AF), fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              children: const [
                _IncludedItem(icon: '💧', label: 'Hydration'),
                SizedBox(width: 46),
                _IncludedItem(icon: '🍽️', label: 'Nutrition'),
                SizedBox(width: 46),
                _IncludedItem(icon: '😴', label: 'Sleep'),
                SizedBox(width: 34),
                _IncludedItem(icon: '▧', label: 'Insights'),
              ],
            ),
            const SizedBox(height: 70),
            if (!_isStar)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD7C0FF), style: BorderStyle.solid),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFF7452B7), size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'STAR members can choose custom date range to view data and get advance health insights.',
                        style: TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.45),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(74, 36),
                        side: const BorderSide(color: Color(0xFF7452B7)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      ),
                      child: const Text('Upgrade', style: TextStyle(color: Color(0xFF7452B7), fontSize: 12)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _header(BuildContext context, String title) => Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.textDark),
      ),
      Expanded(
        child: Center(child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.textDark))),
      ),
      const SizedBox(width: 22),
    ],
  );

  Widget _reportCard({required String title, required String subtitle, required VoidCallback onTap, bool disabled = false, bool premium = false}) =>
      InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: disabled ? const Color(0xFFEEEEEE) : const Color(0xFF9EDBFF)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .03), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(title, style: TextStyle(fontSize: 16, color: disabled ? const Color(0xFF9DAEB6) : AppColors.textDark, fontWeight: FontWeight.w500)),
                    if (premium) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF7452B7)), borderRadius: BorderRadius.circular(4)),
                        child: const Text('🔒STAR', style: TextStyle(color: Color(0xFF7452B7), fontSize: 10)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: disabled ? const Color(0xFFBAC6CB) : const Color(0xFF9DAFB9))),
                ]),
              ),
              Icon(Icons.chevron_right, size: 27, color: disabled ? const Color(0xFFBCD0D9) : const Color(0xFF6E7D84)),
            ],
          ),
        ),
      );

  Widget _bottomNav(BuildContext context) => Container(
    height: 64,
    decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]),
    child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _navItem(context, Icons.home_outlined, 'Home', false),
      _navItem(context, Icons.groups_outlined, 'Care Circle', false),
      _navItem(context, Icons.auto_awesome_outlined, 'Rin AI', false),
      _navItem(context, Icons.person_outline, 'Profile', true),
    ])),
  );

  Widget _navItem(BuildContext context, IconData icon, String label, bool selected) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, size: 25, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C))),
    ],
  );
}

class _IncludedItem extends StatelessWidget {
  final String icon;
  final String label;
  const _IncludedItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 62,
    child: Column(children: [
      Text(icon, style: const TextStyle(fontSize: 25)),
      const SizedBox(height: 8),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF728690))),
    ]),
  );
}
