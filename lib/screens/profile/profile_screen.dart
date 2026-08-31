import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../home/home_screen.dart';
import '../onboarding/gender_name_screen.dart';
import 'connections_screen.dart';
import 'active_streak_screen.dart';
import 'care_circles_screen.dart';
import '../rin_ai/rin_ai_screen.dart';
import 'settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final Gender gender;

  const ProfileScreen({super.key, required this.name, required this.gender});

  String get _avatarAsset => gender == Gender.male
      ? 'lib/assets/images/avatar_male.png'
      : 'lib/assets/images/avatar_female.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F8FF),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(fontSize: 26, height: 1.15, color: AppColors.textDark),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          '@${_usernameFor(name)}',
                                          style: const TextStyle(fontSize: 16, color: Color(0xFF71838C)),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF7250A8),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('STAR', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                              SizedBox(width: 3),
                                              Icon(Icons.star, color: Colors.white, size: 12),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              _circleHeaderButton(Icons.notifications_none),
                              const SizedBox(width: 10),
                              GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(name: name, gender: gender))), child: _circleHeaderButton(Icons.settings_outlined)),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Image.asset(
                                  _avatarAsset,
                                  fit: BoxFit.contain,
                                  height: 500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 28,
                      right: 28,
                      bottom: 28,
                      child: Column(
                        children: [
                          _statCard(
                            context,
                            icon: Icons.group_outlined,
                            iconColor: AppColors.primaryBlue,
                            value: '12',
                            label: 'Connections',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectionsScreen())),
                          ),
                          const SizedBox(height: 10),
                          _statCard(
                            context,
                            icon: Icons.local_fire_department_outlined,
                            iconColor: const Color(0xFFF3B818),
                            value: '07',
                            label: 'Active Streak',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveStreakScreen())),
                          ),
                          const SizedBox(height: 10),
                          _statCard(
                            context,
                            icon: Icons.track_changes_outlined,
                            iconColor: const Color(0xFF12A47C),
                            value: '02',
                            label: 'Care Circles',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareCirclesScreen())),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _bottomNav(context),
        ],
      ),
    );
  }

  String _usernameFor(String value) => value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_|_$'), '');

  Widget _circleHeaderButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.textDark, size: 25),
    );
  }

  Widget _statCard(BuildContext context, {required IconData icon, required Color iconColor, required String value, required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 31),
              const SizedBox(width: 18),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF71838C))),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Color(0xFF70818A), size: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(context, Icons.home_outlined, 'Home', false, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(name: name, gender: gender)))),
              _navItem(context, Icons.groups_outlined, 'Care Circle', false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareCirclesScreen()))),
              _navItem(context, Icons.auto_awesome_outlined, 'Rin AI', false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => RinAiScreen(name: name, gender: gender)))),
              _navItem(context, Icons.person_outline, 'Profile', true, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool selected, VoidCallback onTap) {
    final color = selected ? AppColors.primaryBlue : const Color(0xFF4A565C);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: selected ? FontWeight.w600 : FontWeight.w500)),
        ],
      ),
    );
  }
}
