import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'report_downloaded_screen.dart';

class ReportPreviewScreen extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  final bool hydration;
  final bool nutrition;
  final bool sleep;

  const ReportPreviewScreen({super.key, required this.from, required this.to, required this.hydration, required this.nutrition, required this.sleep});

  String _fmt(DateTime d) => '${d.day} ${_month(d.month)} ${d.year}';
  String _month(int m) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), children: [
        _header(context),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
          decoration: BoxDecoration(color: const Color(0xFFF6F9FB), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Report Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 5),
            Text('${_fmt(from)} - ${_fmt(to)} (${to.difference(from).inDays + 1} days)', style: const TextStyle(fontSize: 11, color: Color(0xFF7C929D))),
            const SizedBox(height: 14),
            Wrap(spacing: 8, children: [if (hydration) _pill('Hydration', AppColors.primaryBlue), if (nutrition) _pill('Nutrition', const Color(0xFF16AE7B)), if (sleep) _pill('Sleep', const Color(0xFF7452B7))]),
          ]),
        ),
        const SizedBox(height: 38),
        const Text('Overall Summary', style: TextStyle(fontSize: 15, color: AppColors.textDark, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        const Text('See how you performed in this period.', style: TextStyle(fontSize: 12, color: Color(0xFF8EA5AF))),
        const SizedBox(height: 25),
        if (hydration) _metric('💧', 'Hydration', '78%', 'Hydration goal achieved', AppColors.primaryBlue),
        if (nutrition) _metric('🍽️', 'Nutrition', '78%', 'Increase in protein intake', const Color(0xFF16AE7B)),
        if (sleep) _metric('😴', 'Sleep', '78%', 'Improved sleep score', const Color(0xFF7452B7)),
        const SizedBox(height: 26),
        Container(padding: const EdgeInsets.fromLTRB(14, 13, 14, 13), decoration: BoxDecoration(color: const Color(0xFFEFF3FF), borderRadius: BorderRadius.circular(12)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 21), SizedBox(width: 12), Expanded(child: Text('Report will include overall metrics, daily averages, trends and insights.', style: TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.55)))])),
        const SizedBox(height: 64),
        Center(child: SizedBox(width: 212, child: ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportDownloadedScreen())), style: ElevatedButton.styleFrom(minimumSize: const Size(212, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Download Report', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))))),
        Center(child: TextButton(onPressed: () {}, child: const Text('Share report', style: TextStyle(color: AppColors.textDark, decoration: TextDecoration.underline)))),
      ])),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _header(BuildContext context) => Row(children: [GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.textDark)), const Expanded(child: Center(child: Text('Report Preview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)))), const SizedBox(width: 22)]);

  Widget _pill(String label, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 5), Text(label, style: TextStyle(fontSize: 11, color: color))]));
  Widget _metric(String icon, String title, String pct, String sub, Color color) => Padding(padding: const EdgeInsets.only(bottom: 22), child: Row(children: [Text(icon, style: const TextStyle(fontSize: 25)), const SizedBox(width: 10), Expanded(child: Text(title, style: const TextStyle(fontSize: 18, color: AppColors.textDark))), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(pct, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w500)), const SizedBox(height: 2), Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF8397A0)))] )]));
  Widget _bottomNav() => Container(height: 64, decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]), child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_nav(Icons.home_outlined, 'Home', false), _nav(Icons.groups_outlined, 'Care Circle', false), _nav(Icons.auto_awesome_outlined, 'Rin AI', false), _nav(Icons.person_outline, 'Profile', true)])));
  Widget _nav(IconData icon, String label, bool selected) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 25, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)))]);
}
