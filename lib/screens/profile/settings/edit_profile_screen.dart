import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../onboarding/gender_name_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final Gender gender;
  const EditProfileScreen({super.key, required this.name, required this.gender});
  @override State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl, ageCtrl, heightCtrl, weightCtrl, allergyCtrl;
  String gender = 'Male';
  String goal = 'Lose Weight';
  String activity = 'Little or no exercise';
  String body = 'Mesomorph (Fit)';
  bool metric = true;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.name.isEmpty ? 'Sahil Pardake' : widget.name);
    ageCtrl = TextEditingController(text: '26');
    heightCtrl = TextEditingController(text: '148');
    weightCtrl = TextEditingController(text: '110');
    allergyCtrl = TextEditingController(text: 'Peanuts, Berries');
  }

  @override
  void dispose() {
    nameCtrl.dispose(); ageCtrl.dispose(); heightCtrl.dispose(); weightCtrl.dispose(); allergyCtrl.dispose(); super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _nav(context),
      body: SafeArea(
        child: Column(
          children: [
            _bar(context, 'Edit Profile'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  const Center(child: _ProfileIcon()),
                  const SizedBox(height: 28),
                  _field('Full Name', nameCtrl),
                  _select('Gender', gender, (v) => setState(() => gender = v), const ['Male', 'Female', 'Other']),
                  _field('Age', ageCtrl),
                  _unitField('Height', heightCtrl, 'cm', 'ft/in'),
                  _unitField('Weight', weightCtrl, 'kg', 'lb'),
                  _select('Goal', goal, (v) => setState(() => goal = v), const ['Lose Weight', 'Maintain Weight', 'Gain Weight']),
                  _select('Allergy', allergyCtrl.text, (v) => setState(() => allergyCtrl.text = v), const ['Peanuts, Berries', 'None', 'Dairy', 'Gluten']),
                  _select('Activity Level', activity, (v) => setState(() => activity = v), const ['Little or no exercise', 'Light exercise', 'Moderate exercise', 'Very active']),
                  _select('Body Type', body, (v) => setState(() => body = v), const ['Mesomorph (Fit)', 'Ectomorph (Lean)', 'Endomorph (Broad)']),
                  const SizedBox(height: 72),
                  Center(child: SizedBox(width: 210, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save Changes')))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c) => Padding(padding: const EdgeInsets.only(bottom: 18), child: TextField(controller: c, decoration: InputDecoration(labelText: label)));

  Widget _select(String label, String value, ValueChanged<String> onChanged, List<String> values) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: DropdownButtonFormField<String>(value: value, items: values.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) { if (v != null) onChanged(v); }, decoration: InputDecoration(labelText: label)),
      );

  Widget _unitField(String label, TextEditingController c, String metricLabel, String imperialLabel) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Stack(
          children: [
            TextField(controller: c, decoration: InputDecoration(labelText: label, suffixText: metric ? metricLabel : imperialLabel)),
            Positioned(right: 2, top: 2, bottom: 2, child: Row(children: [_toggle(metricLabel, metric), _toggle(imperialLabel, !metric)])),
          ],
        ),
      );

  Widget _toggle(String text, bool active) => GestureDetector(onTap: () => setState(() => metric = active), child: Container(width: 72, alignment: Alignment.center, decoration: BoxDecoration(color: active ? AppColors.primaryBlue : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Text(text, style: TextStyle(color: active ? Colors.white : const Color(0xFF71838C)))));

  Widget _bar(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)), Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, color: AppColors.textDark)))), const SizedBox(width: 48)]),
      );

  Widget _nav(BuildContext context) => Container(
        height: 64,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 8, offset: const Offset(0, -2))]),
        child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_n(Icons.home_outlined, 'Home'), _n(Icons.groups_outlined, 'Care Circle'), _n(Icons.auto_awesome_outlined, 'Rin AI'), _n(Icons.person_outline, 'Profile', true)])),
      );

  Widget _n(IconData i, String t, [bool selected = false]) {
    final c = selected ? AppColors.primaryBlue : const Color(0xFF4A565C);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: c), Text(t, style: TextStyle(fontSize: 10, color: c))]);
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();
  @override Widget build(BuildContext context) => Container(width: 96, height: 96, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7E2FF)), child: const Icon(Icons.person_outline, size: 52, color: Color(0xFF91A7B7)));
}
