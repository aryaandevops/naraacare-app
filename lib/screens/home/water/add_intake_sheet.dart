import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/water_log_entry.dart';

/// Bottom sheet matching the "Add Intake" mockup: a Water tab with quick
/// ml chips, and an Other Drinks tab with preset drinks + a custom name
/// field. Returns the [WaterLogEntry] the user logged, or null if dismissed.
class AddIntakeSheet extends StatefulWidget {
  final List<String> savedCustomDrinks;

  const AddIntakeSheet({super.key, required this.savedCustomDrinks});

  static Future<WaterLogEntry?> show(
    BuildContext context, {
    required List<String> savedCustomDrinks,
  }) {
    return showModalBottomSheet<WaterLogEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: AddIntakeSheet(savedCustomDrinks: savedCustomDrinks),
        );
      },
    );
  }

  @override
  State<AddIntakeSheet> createState() => _AddIntakeSheetState();
}

class _AddIntakeSheetState extends State<AddIntakeSheet> {
  int _tabIndex = 0; // 0 = Water, 1 = Other Drinks

  // --- Water tab state ---
  final _waterAmountController = TextEditingController(text: '350');

  // --- Other Drinks tab state ---
  String? _selectedPresetDrink;
  final _customDrinkController = TextEditingController();
  final _drinkAmountController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _waterAmountController.dispose();
    _customDrinkController.dispose();
    _drinkAmountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int? get _waterAmountMl => int.tryParse(_waterAmountController.text.trim());

  int? get _drinkAmountMl => int.tryParse(_drinkAmountController.text.trim());

  String get _drinkName => _customDrinkController.text.trim();

  List<String> get _allDrinkOptions {
    final combined = <String>{...kPresetDrinks, ...widget.savedCustomDrinks};
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return combined.toList();
    return combined.where((d) => d.toLowerCase().contains(query)).toList();
  }

  DrinkCategory _categoryFor(String name) {
    switch (name) {
      case 'Tea':
        return DrinkCategory.tea;
      case 'Coffee':
        return DrinkCategory.coffee;
      case 'Juice':
        return DrinkCategory.juice;
      case 'Milk':
        return DrinkCategory.milk;
      case 'Beer':
        return DrinkCategory.beer;
      case 'Coconut Water':
        return DrinkCategory.coconutWater;
      default:
        return DrinkCategory.custom;
    }
  }

  void _submitWater() {
    final ml = _waterAmountMl;
    if (ml == null || ml <= 0) return;
    Navigator.of(context).pop(
      WaterLogEntry(
        id: UniqueKey().toString(),
        label: 'Water',
        category: DrinkCategory.water,
        amountMl: ml,
        time: DateTime.now(),
      ),
    );
  }

  void _submitOtherDrink() {
    final ml = _drinkAmountMl;
    final name = _drinkName;
    if (ml == null || ml <= 0 || name.isEmpty) return;
    Navigator.of(context).pop(
      WaterLogEntry(
        id: UniqueKey().toString(),
        label: name,
        category: _categoryFor(name),
        amountMl: ml,
        time: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Add Intake',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 32), // balances the close button
              ],
            ),
            const SizedBox(height: 16),

            // Tabs
            Row(
              children: [
                _buildTab('Water', 0),
                const SizedBox(width: 24),
                _buildTab('Other Drinks', 1),
              ],
            ),
            const Divider(height: 24),

            if (_tabIndex == 0) _buildWaterTab() else _buildOtherDrinksTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: 60,
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTab() {
    const chipValues = [15, 250, 500, 750];
    const chipLabels = ['+1 sip', '+250 ml', '+500 ml', '+750 ml'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter amount of water', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: _waterAmountController,
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(chipValues.length, (i) {
            return ChoiceChip(
              label: Text(chipLabels[i]),
              selected: _waterAmountController.text.trim() == chipValues[i].toString(),
              onSelected: (_) {
                setState(() => _waterAmountController.text = chipValues[i].toString());
              },
              selectedColor: AppColors.lightBlue,
              labelStyle: TextStyle(
                color: _waterAmountController.text.trim() == chipValues[i].toString()
                    ? AppColors.primaryBlue
                    : AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
            );
          }),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: (_waterAmountMl ?? 0) > 0 ? _submitWater : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            disabledBackgroundColor: AppColors.lightBlue,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            'Add ${_waterAmountMl ?? 0} ml of Water',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherDrinksTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a drink', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _allDrinkOptions.map((drink) {
            final isSelected = _selectedPresetDrink == drink;
            return ChoiceChip(
              label: Text(drink),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedPresetDrink = drink;
                  _customDrinkController.text = drink;
                });
              },
              selectedColor: AppColors.lightBlue,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Enter drink name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: _customDrinkController,
          onChanged: (_) => setState(() => _selectedPresetDrink = null),
          decoration: InputDecoration(
            hintText: 'e.g. Banana Shake',
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
        const SizedBox(height: 16),
        const Text('Enter quantity of drink', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: _drinkAmountController,
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
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: ((_drinkAmountMl ?? 0) > 0 && _drinkName.isNotEmpty) ? _submitOtherDrink : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            disabledBackgroundColor: AppColors.lightBlue,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            'Add ${_drinkAmountMl ?? 0} ml of ${_drinkName.isEmpty ? "Drink" : _drinkName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
