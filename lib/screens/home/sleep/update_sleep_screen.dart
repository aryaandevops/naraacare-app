import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/sleep_entry.dart';

class UpdateSleepScreen extends StatefulWidget {
  final SleepEntry initial;
  const UpdateSleepScreen({super.key, required this.initial});

  @override
  State<UpdateSleepScreen> createState() => _UpdateSleepScreenState();
}

class _UpdateSleepScreenState extends State<UpdateSleepScreen> {
  late int _sleepHour, _sleepMinute, _wakeHour, _wakeMinute;
  late bool _sleepPm, _wakePm;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _sleepHour = s.sleepHour; _sleepMinute = s.sleepMinute; _sleepPm = s.sleepPm;
    _wakeHour = s.wakeHour; _wakeMinute = s.wakeMinute; _wakePm = s.wakePm;
  }

  Future<void> _pickTime({required bool sleep}) async {
    final current = TimeOfDay(
      hour: ((sleep ? _sleepHour : _wakeHour) % 12) + ((sleep ? _sleepPm : _wakePm) ? 12 : 0),
      minute: sleep ? _sleepMinute : _wakeMinute,
    );
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked == null) return;
    setState(() {
      final pm = picked.period == DayPeriod.pm;
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      if (sleep) { _sleepHour = hour; _sleepMinute = picked.minute; _sleepPm = pm; }
      else { _wakeHour = hour; _wakeMinute = picked.minute; _wakePm = pm; }
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = SleepEntry(sleepHour: _sleepHour, sleepMinute: _sleepMinute, sleepPm: _sleepPm, wakeHour: _wakeHour, wakeMinute: _wakeMinute, wakePm: _wakePm);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 48, height: 5, decoration: BoxDecoration(color: const Color(0xFFDDE8F0), borderRadius: BorderRadius.circular(10))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(children: [
                _close(context),
                const Expanded(child: Center(child: Text('Update Sleep', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)))),
                const SizedBox(width: 44),
              ]),
            ),
            const SizedBox(height: 22),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                _timeCard(
                  icon: Icons.nightlight_round, iconColor: const Color(0xFF8A86C9), title: 'Sleep Time',
                  value: draft.sleepTimeLabel, onTap: () => _pickTime(sleep: true),
                ),
                const SizedBox(height: 24),
                _timeCard(
                  icon: Icons.wb_sunny_outlined, iconColor: const Color(0xFFB8C84D), title: 'Wake Up Time',
                  value: draft.wakeTimeLabel, onTap: () => _pickTime(sleep: false),
                ),
                const SizedBox(height: 28),
                _statRow(Icons.track_changes_outlined, 'Goal', '08h 00m'),
                const SizedBox(height: 22),
                _statRow(Icons.emoji_events_outlined, 'Achieved', draft.durationLabel),
              ]),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
              child: SizedBox(width: 212, height: 56, child: ElevatedButton(
                onPressed: () => Navigator.pop(context, draft),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Update Sleep', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)), SizedBox(width: 10), Icon(Icons.add_circle_outline, size: 21)]),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _close(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF71838C), width: 3)), child: const Icon(Icons.close, color: Color(0xFF71838C), size: 28)),
  );

  Widget _timeCard({required IconData icon, required Color iconColor, required String title, required String value, required VoidCallback onTap}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: 255,
        width: double.infinity,
        decoration: BoxDecoration(color: const Color(0xFFEAF7FE), border: Border.all(color: const Color(0xFFB7D8E9)), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.only(top: 14),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: iconColor, size: 22), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 20, color: Color(0xFF617684))), const SizedBox(width: 12), Container(width: 1, height: 28, color: const Color(0xFFD9E7EF))]),
          const SizedBox(height: 14),
          Expanded(child: _WheelPreview(value: value, onChanged: (hour, minute, pm) {
            // The wheel is the editable source of truth for this time card.
            // UpdateSleepScreen receives the selected 12-hour time immediately.
            if (title == 'Sleep Time') {
              setState(() { _sleepHour = hour; _sleepMinute = minute; _sleepPm = pm; });
            } else {
              setState(() { _wakeHour = hour; _wakeMinute = minute; _wakePm = pm; });
            }
          })),
        ]),
      ),
    );

  Widget _statRow(IconData icon, String label, String value) => Row(children: [Icon(icon, size: 22, color: const Color(0xFF45544A)), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 16)), const Spacer(), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]);
}

class _WheelPreview extends StatefulWidget {
  final String value;
  final void Function(int hour, int minute, bool pm) onChanged;
  const _WheelPreview({required this.value, required this.onChanged});
  @override State<_WheelPreview> createState() => _WheelPreviewState();
}

class _WheelPreviewState extends State<_WheelPreview> {
  late FixedExtentScrollController _hour;
  late FixedExtentScrollController _minute;
  late FixedExtentScrollController _period;

  @override
  void initState() {
    super.initState();
    final parts = widget.value.split(' ');
    final hm = parts.first.split(':');
    final h = int.tryParse(hm.first) ?? 7;
    final m = int.tryParse(hm.last) ?? 0;
    final pm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
    _hour = FixedExtentScrollController(initialItem: (h - 1).clamp(0, 11).toInt());
    _minute = FixedExtentScrollController(initialItem: (m ~/ 5).clamp(0, 11).toInt());
    _period = FixedExtentScrollController(initialItem: pm ? 1 : 0);
  }

  @override
  void dispose() {
    _hour.dispose(); _minute.dispose(); _period.dispose(); super.dispose();
  }

  Widget _wheel(FixedExtentScrollController controller, List<String> values, {double width = 42}) {
    return SizedBox(
      width: width,
      height: 150,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 28,
        perspective: 0.002,
        diameterRatio: 2.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (_) {
          setState(() {});
          final hour = (_hour.selectedItem % 12) + 1;
          final minute = (_minute.selectedItem % 12) * 5;
          final pm = (_period.selectedItem % 2) == 1;
          widget.onChanged(hour, minute, pm);
        },
        childDelegate: ListWheelChildLoopingListDelegate(children: [
          for (final value in values)
            Center(child: Text(value, style: TextStyle(fontSize: (controller.selectedItem % values.length) == values.indexOf(value) ? 22 : 17, color: (controller.selectedItem % values.length) == values.indexOf(value) ? AppColors.textDark : const Color(0xFFAAB7BF), fontWeight: FontWeight.w500))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final periods = ['am', 'pm'];
    final hours = List.generate(12, (i) => '${i + 1}');
    final minutes = List.generate(12, (i) => (i * 5).toString().padLeft(2, '0'));
    return Container(
      height: 155,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 0, right: 0, child: Container(height: 36, decoration: BoxDecoration(color: const Color(0xFFDDECF5), borderRadius: BorderRadius.circular(9)))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _wheel(_hour, hours),
            const SizedBox(width: 10),
            _wheel(_minute, minutes),
            const SizedBox(width: 10),
            _wheel(_period, periods, width: 48),
          ]),
        ],
      ),
    );
  }
}
