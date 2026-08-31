import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/sleep_entry.dart';
import 'update_sleep_screen.dart';

class TodaysSleepScreen extends StatefulWidget {
  final SleepEntry initial;
  const TodaysSleepScreen({super.key, required this.initial});
  @override State<TodaysSleepScreen> createState() => _TodaysSleepScreenState();
}

class _TodaysSleepScreenState extends State<TodaysSleepScreen> {
  late SleepEntry _sleep;
  @override void initState() { super.initState(); _sleep = widget.initial; }

  Future<void> _edit() async {
    final result = await Navigator.push<SleepEntry>(context, MaterialPageRoute(builder: (_) => UpdateSleepScreen(initial: _sleep)));
    if (result != null) setState(() => _sleep = result);
  }

  @override
  Widget build(BuildContext context) {
    final score = _sleep.score;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(children: [
        const SizedBox(height: 10),
        Container(width: 48, height: 5, decoration: BoxDecoration(color: const Color(0xFFDDE8F0), borderRadius: BorderRadius.circular(10))),
        Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 0), child: Row(children: [
          _close(context), const Expanded(child: Center(child: Text("Today’s Sleep", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)))), const SizedBox(width: 44),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 30), child: Column(children: [
          Container(height: 109, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFEAF7FE), border: Border.all(color: const Color(0xFFB7D8E9)), borderRadius: BorderRadius.circular(12)), child: Row(children: [
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Sleep Time', style: TextStyle(fontSize: 15, color: Color(0xFF50645C))), const SizedBox(height: 4), Text(_sleep.durationLabel, style: const TextStyle(fontSize: 21, color: Color(0xFF4D55D7)))])),
            Container(width: 1, height: 48, color: const Color(0xFFD9E7EF)),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Sleep Score', style: TextStyle(fontSize: 15, color: Color(0xFF50645C))), const SizedBox(height: 4), Text('$score%', style: const TextStyle(fontSize: 21, color: Color(0xFF4D55D7))), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFD8F5E4), borderRadius: BorderRadius.circular(10)), child: const Text('Good', style: TextStyle(fontSize: 12, color: Color(0xFF00874A))))]))
          ])),
          const SizedBox(height: 24),
          _timeRow(Icons.nightlight_round, const Color(0xFF8A86C9), 'Sleep Start', _sleep.sleepTimeLabel),
          const SizedBox(height: 16),
          _timeRow(Icons.wb_sunny_outlined, const Color(0xFFB8C84D), 'Wake Up', _sleep.wakeTimeLabel, bold: true),
          const SizedBox(height: 24),
          Container(height: 1, color: const Color(0xFFD2C6DD), margin: const EdgeInsets.symmetric(horizontal: 30)),
          const SizedBox(height: 28),
          _statRow(Icons.track_changes_outlined, 'Goal', '08h 00m'), const SizedBox(height: 22), _statRow(Icons.emoji_events_outlined, 'Achieved', _sleep.durationLabel),
          const SizedBox(height: 28),
          Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(16, 14, 16, 14), decoration: BoxDecoration(color: const Color(0xFFEFF3FF), borderRadius: BorderRadius.circular(12)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline, color: Color(0xFF4D55D7), size: 20), const SizedBox(width: 12), Expanded(child: Text('Your sleep score is based on the time you slept compared to your goal.\nConsistent sleep cycles improve health.', style: TextStyle(fontSize: 15, height: 1.55, color: AppColors.textGrey)))])),
        ]))),
      ])),
    );
  }

  Widget _close(BuildContext context) => GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF71838C), width: 3)), child: const Icon(Icons.close, color: Color(0xFF71838C), size: 28)));
  Widget _timeRow(IconData icon, Color color, String title, String value, {bool bold = false}) => Container(height: 82, width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE8ECEE)), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, color: color, size: 30), const SizedBox(width: 18), Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF50605C))), Text(value, style: TextStyle(fontSize: 15, fontWeight: bold ? FontWeight.w700 : FontWeight.w500))]), const Spacer(), GestureDetector(onTap: _edit, child: const Icon(Icons.edit_outlined, size: 23, color: AppColors.textDark))]));
  Widget _statRow(IconData icon, String label, String value) => Row(children: [Icon(icon, size: 22, color: const Color(0xFF45544A)), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 16)), const Spacer(), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]);
}
