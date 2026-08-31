import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'report_preview_screen.dart';

class CustomizeReportScreen extends StatefulWidget {
  final bool isMonthly;
  const CustomizeReportScreen({super.key, this.isMonthly = false});

  @override
  State<CustomizeReportScreen> createState() => _CustomizeReportScreenState();
}

class _CustomizeReportScreenState extends State<CustomizeReportScreen> {
  String _range = 'Last 30 days';
  DateTime? _from;
  DateTime? _to;
  bool _hydration = true;
  bool _nutrition = true;
  bool _sleep = false;

  Future<void> _pickDate({required bool from}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: from ? (_from ?? DateTime.now()) : (_to ?? DateTime.now()),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (from) {
        _from = picked;
      } else {
        _to = picked;
      }
      _range = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
          children: [
            _header(context, 'Customize Report'),
            const SizedBox(height: 22),
            const Text('Select Date Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 10, children: ['Last 7 days', 'Last 30 days', 'Last 3 months', 'Last 6 months', 'This Year'].map(_chip).toList()),
            const SizedBox(height: 34),
            _dateField('From', _from, () => _pickDate(from: true)),
            const SizedBox(height: 12),
            _dateField('To', _to, () => _pickDate(from: false)),
            const SizedBox(height: 48),
            const Text('What do you want to include?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 20),
            _checkRow('💧', 'Hydration', _hydration, (v) => setState(() => _hydration = v)),
            const SizedBox(height: 14),
            _checkRow('🍽️', 'Nutrition', _nutrition, (v) => setState(() => _nutrition = v)),
            const SizedBox(height: 14),
            _checkRow('😴', 'Sleep', _sleep, (v) => setState(() => _sleep = v)),
            const SizedBox(height: 54),
            ElevatedButton(
              onPressed: (_hydration || _nutrition || _sleep) ? _openPreview : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(212, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(horizontal: 20)).copyWith(backgroundColor: WidgetStateProperty.all(AppColors.primaryBlue)),
              child: const Text('Generate Report', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }


  void _openPreview() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReportPreviewScreen(
      from: _from ?? DateTime.now().subtract(const Duration(days: 31)),
      to: _to ?? DateTime.now(),
      hydration: _hydration,
      nutrition: _nutrition,
      sleep: _sleep,
    )));
  }

  Widget _chip(String text) => ChoiceChip(
    label: Text(text),
    selected: _range == text,
    onSelected: (_) => setState(() => _range = text),
    showCheckmark: false,
    side: const BorderSide(color: Color(0xFF9EDBFF)),
    backgroundColor: Colors.white,
    selectedColor: const Color(0xFFEAF8FF),
    labelStyle: const TextStyle(color: AppColors.primaryBlue, fontSize: 13),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
  );

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) {
    String text = value == null ? 'Enter ${label.toLowerCase()} date' : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Color(0xFF8EA5AF), fontSize: 14)),
      const SizedBox(height: 6),
      InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF9FB0B8)), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [Expanded(child: Text(text, style: TextStyle(fontSize: 16, color: value == null ? const Color(0xFF7E919A) : AppColors.textDark))), const Icon(Icons.calendar_month_outlined, color: Color(0xFF627680))]),
      )),
    ]);
  }

  Widget _checkRow(String icon, String label, bool checked, ValueChanged<bool> onChanged) => Row(children: [Text(icon, style: const TextStyle(fontSize: 24)), const SizedBox(width: 14), Expanded(child: Text(label, style: const TextStyle(fontSize: 18, color: AppColors.textDark))), Checkbox(value: checked, onChanged: (v) => onChanged(v ?? false), activeColor: AppColors.primaryBlue, side: const BorderSide(color: AppColors.primaryBlue))]);

  Widget _header(BuildContext context, String title) => Row(children: [GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.textDark)), Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),), const SizedBox(width: 22)]);

  Widget _bottomNav() => Container(height: 64, decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]), child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    _nav(Icons.home_outlined, 'Home', false), _nav(Icons.groups_outlined, 'Care Circle', false), _nav(Icons.auto_awesome_outlined, 'Rin AI', false), _nav(Icons.person_outline, 'Profile', true),
  ])));
  Widget _nav(IconData icon, String label, bool selected) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 25, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)))]);
}
