import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../home/home_screen.dart';
import '../../onboarding/gender_name_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final String name;
  final Gender gender;

  const NotificationsScreen({super.key, required this.name, required this.gender});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Important notifications only. High-volume water/meal/sleep updates are
  // intentionally kept out of Notifications and belong in the Care Circle's
  // Recent Updates feed.
  final List<_NotificationItem> _today = [
    const _NotificationItem(
      icon: Icons.chat_bubble_outline,
      iconColor: AppColors.primaryBlue,
      title: '@aarav.12 mentioned you in\nthe chat.',
      time: '10m ago',
      unread: true,
    ),
    const _NotificationItem(
      icon: Icons.person_add_alt_1_outlined,
      title: '@priya joined the circle.',
      time: '2h ago',
      unread: true,
    ),
    const _NotificationItem(
      emoji: '😴',
      title: '@meera updated sleep.',
      time: '7h ago',
      unread: false,
    ),
    const _NotificationItem(
      icon: Icons.chat_bubble_outline,
      iconColor: AppColors.primaryBlue,
      title: '@rohan.ab mentioned you\nin the chat',
      time: '1d ago',
      unread: false,
    ),
  ];

  final List<_NotificationItem> _earlier = [
    const _NotificationItem(
      emoji: '💧',
      title: '@kavya.37228 completed here\nhydration goal.',
      time: 'Yesterday, 5:45 PM',
      unread: false,
    ),
  ];

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
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                children: [
                  _sectionTitle('TODAY'),
                  ..._today.map((item) => _notificationCard(item)),
                  const SizedBox(height: 68),
                  _sectionTitle('EARLIER'),
                  ..._earlier.map((item) => _notificationCard(item)),
                  const SizedBox(height: 20),
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
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22, color: Color(0xFF35434B)),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(fontSize: 25, color: AppColors.textDark),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 9),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF728794),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _notificationCard(_NotificationItem item) {
    return Container(
      height: 69,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFB7DDF6), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 7, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            SizedBox(
              width: 37,
              child: item.emoji != null
                  ? Text(item.emoji!, style: const TextStyle(fontSize: 28))
                  : Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: item.icon == Icons.chat_bubble_outline
                            ? Border.all(color: AppColors.primaryBlue.withValues(alpha: .25))
                            : null,
                      ),
                      child: Icon(item.icon, size: 30, color: item.iconColor),
                    ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Color(0xFF35434B),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.time,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, color: Color(0xFF73848D)),
            ),
            const SizedBox(width: 11),
            if (item.unread)
              const SizedBox(
                width: 8,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
              const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(context, Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(name: widget.name, gender: widget.gender),
                  ),
                );
              }),
              _navItem(context, Icons.groups_outlined, 'Care Circle', false, () {}),
              _navItem(context, Icons.auto_awesome_outlined, 'Rin AI', false, () {}),
              _navItem(context, Icons.person_outline, 'Profile', true, () => Navigator.pop(context)),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final IconData? icon;
  final String? emoji;
  final String title;
  final String time;
  final bool unread;
  final Color iconColor;

  const _NotificationItem({
    this.icon,
    this.emoji,
    required this.title,
    required this.time,
    this.unread = true,
    this.iconColor = const Color(0xFF39464E),
  });
}
