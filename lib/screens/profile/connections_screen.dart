import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  int _tab = 0;
  final _searchController = TextEditingController();
  String _query = '';
  final List<_Person> _connections = [
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
  ];
  final List<_Person> _suggestions = [
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
    const _Person('Araa Sharma', '@aara_sharma'),
  ];
  final List<_Person> _invites = [const _Person('Ria Sharma', '@ria_sharma')];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Person> get _filteredConnections => _connections.where(_matches).toList();
  List<_Person> get _filteredSuggestions => _suggestions.where(_matches).toList();

  bool _matches(_Person p) {
    if (_query.trim().isEmpty) return true;
    final q = _query.toLowerCase();
    return p.name.toLowerCase().contains(q) || p.username.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            _tabs(),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 42, 29, 0),
              child: _searchField(),
            ),
            const SizedBox(height: 26),
            Expanded(child: _tab == 0 ? _myConnections() : _findPeople()),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _appBar(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
    child: Row(children: [
      GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new, size: 23, color: AppColors.textDark)),
      const Expanded(child: Center(child: Text('Connections', style: TextStyle(fontSize: 25, color: AppColors.textDark, fontWeight: FontWeight.w500)))),
      const SizedBox(width: 23),
    ]),
  );

  Widget _tabs() => SizedBox(
    height: 60,
    child: Row(
      children: [
        _tabButton('My Connections', 0),
        _tabButton('Find People', 1),
      ],
    ),
  );

  Widget _tabButton(String label, int index) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: _tab == index ? AppColors.primaryBlue : const Color(0xFF6C7E87))),
          const SizedBox(height: 15),
          Container(height: 2, color: _tab == index ? AppColors.primaryBlue : const Color(0xFFD8E0E4)),
        ],
      ),
    ),
  );

  Widget _searchField() => TextField(
    controller: _searchController,
    onChanged: (v) => setState(() => _query = v),
    decoration: InputDecoration(
      hintText: 'Search by username',
      hintStyle: const TextStyle(color: Color(0xFF7E919A), fontSize: 16),
      prefixIcon: const Icon(Icons.search, color: Color(0xFF627680), size: 28),
      filled: false,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFF9FB0B8))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: AppColors.primaryBlue)),
    ),
  );

  Widget _myConnections() => ListView(
    padding: const EdgeInsets.fromLTRB(28, 0, 20, 20),
    children: [
      const Text('CONNECTED ON NARAACARE', style: TextStyle(fontSize: 13, color: Color(0xFF586A73), fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ..._filteredConnections.map((p) => _connectionRow(p)),
      const SizedBox(height: 14),
      const Text('INVITES', style: TextStyle(fontSize: 13, color: Color(0xFF586A73), fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ..._invites.map((p) => _inviteRow(p)),
    ],
  );

  Widget _findPeople() => ListView(
    padding: const EdgeInsets.fromLTRB(28, 0, 20, 20),
    children: [
      const Text('SUGGESTED FOR YOU', style: TextStyle(fontSize: 13, color: Color(0xFF586A73), fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ..._filteredSuggestions.map((p) => _suggestionRow(p)),
    ],
  );

  Widget _connectionRow(_Person p) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      _avatarPlaceholder(),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontSize: 16, color: AppColors.textDark)), const SizedBox(height: 2), Text(p.username, style: const TextStyle(fontSize: 12, color: Color(0xFF7C8D95)))])),
    ]),
  );

  Widget _inviteRow(_Person p) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      _avatarPlaceholder(),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontSize: 16, color: AppColors.textDark)), const SizedBox(height: 2), Text(p.username, style: const TextStyle(fontSize: 12, color: Color(0xFF7C8D95)))])),
      OutlinedButton(onPressed: () => setState(() => _invites.remove(p)), style: _smallButtonStyle(), child: const Text('Decline', style: TextStyle(fontSize: 11, color: Color(0xFF58707C)))),
      const SizedBox(width: 10),
      OutlinedButton(onPressed: () => setState(() { _invites.remove(p); _connections.add(p); }), style: _smallButtonStyle(primary: true), child: const Text('Connect', style: TextStyle(fontSize: 11, color: AppColors.primaryBlue))),
    ]),
  );

  Widget _suggestionRow(_Person p) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(children: [
      _avatarPlaceholder(),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontSize: 16, color: AppColors.textDark)), const SizedBox(height: 2), Text(p.username, style: const TextStyle(fontSize: 12, color: Color(0xFF7C8D95)))])),
      OutlinedButton(onPressed: () {}, style: _smallButtonStyle(primary: true), child: const Text('Connect', style: TextStyle(fontSize: 11, color: AppColors.primaryBlue))),
    ]),
  );

  Widget _avatarPlaceholder() => const CircleAvatar(radius: 22, backgroundColor: Color(0xFFE6EAEE));

  ButtonStyle _smallButtonStyle({bool primary = false}) => OutlinedButton.styleFrom(
    minimumSize: const Size(58, 34),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    side: BorderSide(color: primary ? const Color(0xFF9FD8FF) : const Color(0xFFBFD1D8)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    backgroundColor: Colors.white,
  );

  Widget _bottomNav() => Container(
    height: 64,
    decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]),
    child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _navItem(Icons.home_outlined, 'Home', false),
      _navItem(Icons.groups_outlined, 'Care Circle', false),
      _navItem(Icons.auto_awesome_outlined, 'Rin AI', false),
      _navItem(Icons.person_outline, 'Profile', true),
    ])),
  );

  Widget _navItem(IconData icon, String label, bool selected) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 25, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primaryBlue : const Color(0xFF4A565C)))]);
}

class _Person {
  final String name;
  final String username;
  const _Person(this.name, this.username);
}
