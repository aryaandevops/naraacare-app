import 'package:flutter/material.dart';
import '../../core/theme.dart';

enum _UsernameStatus { idle, checking, available, taken }

class UsernameSetupSheet extends StatefulWidget {
  const UsernameSetupSheet({super.key});

  @override
  State<UsernameSetupSheet> createState() => _UsernameSetupSheetState();

  /// Call this to show the sheet over the current screen
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UsernameSetupSheet(),
    );
  }
}

class _UsernameSetupSheetState extends State<UsernameSetupSheet> {
  final _usernameController = TextEditingController();
  _UsernameStatus _status = _UsernameStatus.idle;
  int _requestToken = 0;

  // TEMPORARY: usernames treated as already taken until real backend check exists
  static const _takenUsernames = ['admin', 'test', 'naaracare', 'sahil'];

  bool get _isFormValid =>
      _usernameController.text.trim().isNotEmpty && _status == _UsernameStatus.available;

  void _onChanged(String value) {
    final trimmed = value.trim();
    _requestToken++;
    final currentToken = _requestToken;

    if (trimmed.isEmpty) {
      setState(() => _status = _UsernameStatus.idle);
      return;
    }

    setState(() => _status = _UsernameStatus.checking);

    // Simulate an async availability check with a short debounce
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted || currentToken != _requestToken) return;
      final isTaken = _takenUsernames.contains(trimmed.toLowerCase());
      setState(() => _status = isTaken ? _UsernameStatus.taken : _UsernameStatus.available);
    });
  }

  Color get _borderColor {
    switch (_status) {
      case _UsernameStatus.taken:
        return Colors.red;
      case _UsernameStatus.available:
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),

            // Header row with close button
            Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Profile Username',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F2F4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              'Create your NaraaCare username',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              'Your username helps people find and connect with you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _usernameController,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Enter username',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: _status == _UsernameStatus.checking
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : _status == _UsernameStatus.available
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : _status == _UsernameStatus.taken
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _borderColor, width: 1.5),
                ),
              ),
            ),
            if (_status == _UsernameStatus.taken) ...[
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username is already taken',
                  style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
            ] else if (_status == _UsernameStatus.available) ...[
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username available',
                  style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Choose carefully. You can change it only once every 3 months.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                      // TODO: save username to Firestore once backend is live
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.lightBlue,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Set up later',
                style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}