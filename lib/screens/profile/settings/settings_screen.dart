import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../home/home_screen.dart';
import '../../onboarding/gender_name_screen.dart';
import '../profile_screen.dart';
import 'edit_profile_screen.dart';
import 'username_screen.dart';
import 'account_screen.dart';
import 'subscription_screens.dart';

class SettingsScreen extends StatelessWidget {
  final String name;
  final Gender gender;

  const SettingsScreen({super.key, required this.name, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  const SizedBox(height: 8),
                  const Center(child: _ProfileIcon()),
                  const SizedBox(height: 10),
                  Center(child: Text(name.isEmpty ? 'Sahil Pardake' : name, style: const TextStyle(fontSize: 24, color: AppColors.textDark))),
                  const SizedBox(height: 2),
                  Center(child: Text('@${_usernameFor(name.isEmpty ? 'sahil.123' : name)}', style: const TextStyle(fontSize: 14, color: Color(0xFF8EA5B2)))),
                  const SizedBox(height: 36),
                  _sectionTitle('PROFILE'),
                  _item(context, Icons.person_outline, 'Edit Profile', () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(name: name, gender: gender)))),
                  _item(context, Icons.alternate_email, 'Username', () => Navigator.push(context, MaterialPageRoute(builder: (_) => UsernameScreen(initialUsername: _usernameFor(name))))),
                  _item(context, Icons.manage_accounts_outlined, 'Account', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()))),
                  _item(context, Icons.notifications_none, 'Notifications & Reminders', () => _placeholder(context, 'Notifications & Reminders')),
                  const SizedBox(height: 36),
                  _sectionTitle('SUBSCRIPTIONS & PAYMENTS'),
                  _item(context, Icons.wallet_outlined, 'My Subscriptions', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionListScreen()))),
                  _item(context, Icons.people_outline, 'Refer a Friend', () => _placeholder(context, 'Refer a Friend')),
                  const SizedBox(height: 36),
                  _sectionTitle('SUPPORT & LEGAL'),
                  _item(context, Icons.description_outlined, 'Terms and Conditions', () => _placeholder(context, 'Terms and Conditions')),
                  _item(context, Icons.lock_outline, 'Privacy policy', () => _placeholder(context, 'Privacy policy')),
                  _item(context, Icons.insert_drive_file_outlined, 'Licenses', () => _placeholder(context, 'Licenses')),
                  _item(context, Icons.help_outline, 'Help & Support', () => _placeholder(context, 'Help & Support')),
                  const SizedBox(height: 40),
                  _logout(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 22, color: Color(0xFF39464E))),
          const Expanded(child: Center(child: Text('Settings', style: TextStyle(fontSize: 26, color: AppColors.textDark)))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(padding: const EdgeInsets.only(left: 3, bottom: 8), child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF8BA6B4))));

  Widget _item(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB7DDF6)),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
        leading: Icon(icon, size: 28, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF79838A), size: 28),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB7DDF6))),
      child: ListTile(
        onTap: () => showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Log Out'), content: const Text('Are you sure you want to log out?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), TextButton(onPressed: () { Navigator.pop(context); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen(name: name, gender: gender)), (_) => false); }, child: const Text('Log Out'))])),
        contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
        leading: const Icon(Icons.logout, color: Color(0xFFD1264D), size: 28),
        title: const Text('Log Out', style: TextStyle(fontSize: 14, color: Color(0xFFD1264D))),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 8, offset: const Offset(0, -2))]),
      child: SafeArea(top: false, child: SizedBox(height: 64, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _nav(context, Icons.home_outlined, 'Home', () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(name: name, gender: gender))), false),
        _nav(context, Icons.groups_outlined, 'Care Circle', () {}, false),
        _nav(context, Icons.auto_awesome_outlined, 'Rin AI', () {}, false),
        _nav(context, Icons.person_outline, 'Profile', () => Navigator.pop(context), true),
      ]))),
    );
  }

  Widget _nav(BuildContext context, IconData icon, String label, VoidCallback onTap, bool selected) {
    final c = selected ? AppColors.primaryBlue : const Color(0xFF4A565C);
    return GestureDetector(onTap: onTap, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 25, color: c), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, color: c, fontWeight: selected ? FontWeight.w600 : FontWeight.w500))]));
  }

  void _placeholder(BuildContext context, String title) => Navigator.push(context, MaterialPageRoute(builder: (_) => SimpleSettingsPage(title: title)));

  String _usernameFor(String value) {
    final normalized = value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_|_$'), '');
    return normalized.isEmpty ? 'sahil.123' : normalized;
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();
  @override
  Widget build(BuildContext context) => Container(width: 96, height: 96, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7E2FF)), child: const Icon(Icons.person_outline, size: 52, color: Color(0xFF91A7B7)));
}

class SimpleSettingsPage extends StatelessWidget {
  final String title;
  const SimpleSettingsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
                  Expanded(child: Center(child: Text(title, style: const TextStyle(fontSize: 24, color: AppColors.textDark)))),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text('$title\n\nScreen ready for backend/content integration.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Color(0xFF71838C))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
