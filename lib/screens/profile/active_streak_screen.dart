import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'reports/download_report_screen.dart';

class ActiveStreakScreen extends StatefulWidget {
  const ActiveStreakScreen({super.key});

  @override
  State<ActiveStreakScreen> createState() => _ActiveStreakScreenState();
}

class _ActiveStreakScreenState extends State<ActiveStreakScreen> {
  bool _calendar = false;
  bool _broken = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: _calendar ? _calendarView() : _summaryView(),
    ),
    bottomNavigationBar: _bottomNav(),
  );

  Widget _summaryView() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _header(),
      const SizedBox(height: 34),
      Center(child: Container(width: 96, height: 96, decoration: const BoxDecoration(color: Color(0xFFFFF0E8), shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Color(0xFFF15B29)))), child: const Icon(Icons.local_fire_department_rounded, size: 64, color: Color(0xFFF15B29)))),
      const SizedBox(height: 18),
      Center(child: Text(_broken ? '00' : '07', style: const TextStyle(fontSize: 33, fontWeight: FontWeight.w600, color: AppColors.textDark))),
      const Center(child: Text('Active Streak', style: TextStyle(fontSize: 20, color: Color(0xFF748A95)))),
      const SizedBox(height: 40),
      _weekStrip(),
      const SizedBox(height: 10),
      _broken ? _brokenBanner() : _healthyBanner(),
      const SizedBox(height: 68),
      _reportButton(),
      const SizedBox(height: 18),
      Center(child: TextButton(onPressed: () => setState(() => _calendar = true), child: const Text('View calendar', style: TextStyle(color: AppColors.primaryBlue, fontSize: 14)))),
    ]),
  );

  Widget _calendarView() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _header(calendarBack: true),
      const SizedBox(height: 18),
      const Divider(height: 1, color: Color(0xFFE8ECEE)),
      const SizedBox(height: 18),
      const Row(children: [Text('April 2026', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), SizedBox(width: 4), Icon(Icons.chevron_right, color: AppColors.primaryBlue, size: 20)],),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ['SUN','MON','TUE','WED','THU','FRI','SAT'].map((d) => SizedBox(width: 36, child: Center(child: Text(d, style: const TextStyle(fontSize: 11, color: Color(0xFFB1B1B1), fontWeight: FontWeight.w600))))).toList()),
      const SizedBox(height: 12),
      _monthGrid(),
      const SizedBox(height: 30),
      Row(children: [
        Expanded(child: _summaryMetric('07 days', 'Active Streak')),
        const SizedBox(width: 12),
        Expanded(child: _summaryMetric('18 days', 'Longest Streak')),
      ]),
      const SizedBox(height: 48),
      const Row(children: [CircleAvatar(radius: 12, backgroundColor: Color(0xFF16AE7B)), SizedBox(width: 12), Text('Active day', style: TextStyle(color: Color(0xFF8EA5AF), fontSize: 14))]),
      const SizedBox(height: 24),
      const Row(children: [CircleAvatar(radius: 12, backgroundColor: Colors.white, child: null), SizedBox(width: 12), Text('No Data', style: TextStyle(color: Color(0xFF8EA5AF), fontSize: 14))]),
    ]),
  );

  Widget _monthGrid() {
    final cells = List<int?>.filled(35, null);
    for (var d = 1; d <= 30; d++) cells[d + 3] = d;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.0),
      itemCount: cells.length,
      itemBuilder: (_, i) {
        final d = cells[i];
        if (d == null) return const SizedBox.shrink();
        final active = d >= 13 && d <= 19;
        final current = d == 20;
        final broken = _broken && d == 19;
        return Center(
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: broken ? const Color(0xFFC9304A) : active ? const Color(0xFF16AE7B) : current ? const Color(0xFF83CCF0) : null,
            ),
            child: Center(child: Text('$d', style: TextStyle(fontSize: 17, color: (active || current) ? Colors.white : Colors.black, fontWeight: FontWeight.w500))),
          ),
        );
      },
    );
  }

  Widget _header({bool calendarBack = false}) => Row(children: [
    GestureDetector(onTap: () => calendarBack ? setState(() => _calendar = false) : Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new, size: 23, color: AppColors.textDark)),
    const Expanded(child: Center(child: Text('Active Streak', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)))),
    const SizedBox(width: 23),
  ]);

  Widget _weekStrip() => Container(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFECEFF2)), borderRadius: BorderRadius.circular(16)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(7, (i) => Column(children: [Text(['M','T','W','T','F','S','S'][i], style: const TextStyle(fontSize: 11, color: Color(0xFF9FAFB6))), const SizedBox(height: 12), Container(width: 33, height: 33, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: (i < 6 ? const Color(0xFF16AE7B) : const Color(0xFFE8ECEE)), width: 2)), child: Icon(i < 6 ? Icons.verified_outlined : Icons.circle_outlined, color: i < 6 ? const Color(0xFF16AE7B) : const Color(0xFFE8ECEE), size: 23))]))),
  );

  Widget _healthyBanner() => Container(padding: const EdgeInsets.fromLTRB(14, 12, 14, 12), decoration: BoxDecoration(color: const Color(0xFFEFF3FF), borderRadius: BorderRadius.circular(12)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline, size: 20, color: AppColors.primaryBlue), const SizedBox(width: 12), Expanded(child: Text('Your streak increases when you log any data (hydration, nutrition, sleep) in a day.', style: TextStyle(fontSize: 15, color: AppColors.textGrey, height: 1.55)))]));

  Widget _brokenBanner() => Container(padding: const EdgeInsets.fromLTRB(14, 12, 14, 12), decoration: BoxDecoration(color: const Color(0xFFFFECEF), borderRadius: BorderRadius.circular(12)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline, size: 20, color: Color(0xFFC9304A)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Oh no! Streak Broken.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4B4648))), const SizedBox(height: 3), Text('You didn’t log any data yesterday.\nDon’t worry, you can start again and keep your momentum going.', style: TextStyle(fontSize: 15, color: AppColors.textGrey, height: 1.5))]))]));

  Widget _reportButton() => OutlinedButton(
    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DownloadReportScreen())),
    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryBlue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
    child: const Row(children: [Icon(Icons.description_outlined, color: AppColors.primaryBlue, size: 28), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Download report', style: TextStyle(color: AppColors.primaryBlue, fontSize: 18)), SizedBox(height: 2), Text('View & analyse your activity summary.', style: TextStyle(color: Color(0xFF7E919A), fontSize: 13))])), Icon(Icons.chevron_right, color: Color(0xFF7E919A))]),
  );

  Widget _summaryMetric(String value, String label) => Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]), child: Column(children: [Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF8197A3)))]));

  Widget _bottomNav() => Container(height: 64, decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]), child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    _navItem(Icons.home_outlined, 'Home', false), _navItem(Icons.groups_outlined, 'Care Circle', false), _navItem(Icons.auto_awesome_outlined, 'Rin AI', false), _navItem(Icons.person_outline, 'Profile', true),
  ])));
  Widget _navItem(IconData icon, String label, bool selected) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 25, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)))]);
}
