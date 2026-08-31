import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/water_log_entry.dart';

/// Shows the last 2 logged entries and lets the user edit their amount.
/// The mockup is explicit that only the last 2 entries can be updated —
/// anything older is history, not editable.
class WaterRecentUpdatesScreen extends StatefulWidget {
  final List<WaterLogEntry> recentEntries; // most recent first, max 2
  final void Function(String id, int newAmountMl) onUpdate;

  const WaterRecentUpdatesScreen({
    super.key,
    required this.recentEntries,
    required this.onUpdate,
  });

  @override
  State<WaterRecentUpdatesScreen> createState() => _WaterRecentUpdatesScreenState();
}

class _WaterRecentUpdatesScreenState extends State<WaterRecentUpdatesScreen> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final entry in widget.recentEntries)
        entry.id: TextEditingController(text: entry.amountMl.toString()),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _timeLabel(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Recent Updates',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: widget.recentEntries.isEmpty
            ? Center(
                child: Text(
                  'No entries logged yet today.',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (final entry in widget.recentEntries) ...[
                    _buildEntryEditor(entry),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Only last 2 entries can be updated',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEntryEditor(WaterLogEntry entry) {
    final controller = _controllers[entry.id]!;
    const quickAmounts = [0, 100, 250, 500];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${entry.label} · ${_timeLabel(entry.time)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              suffixText: 'ml',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickAmounts.map((ml) {
              final isSelected = controller.text.trim() == ml.toString();
              return ChoiceChip(
                label: Text('$ml ml'),
                selected: isSelected,
                onSelected: (_) => setState(() => controller.text = ml.toString()),
                selectedColor: AppColors.lightBlue,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final newAmount = int.tryParse(controller.text.trim());
                if (newAmount == null || newAmount < 0) return;
                widget.onUpdate(entry.id, newAmount);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Entry updated'), duration: Duration(seconds: 1)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Update Entry', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
