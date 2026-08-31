import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/meal_entry.dart';
import 'nutrition_summary_screen.dart';
import 'recent_meals_screen.dart';

class AddMealScreen extends StatefulWidget {
  final List<MealFood>? initialItems;

  const AddMealScreen({super.key, this.initialItems});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<MealFood> _selected;

  final List<MealFood> _foods = [
    MealFood(
      id: 'moong-cooked', name: 'Moong Dal (Cooked)', serving: '1 katori (150 g)',
      imageAsset: 'lib/assets/images/food/moong_dal_cooked.png', calories: 62,
      protein: 5, carbs: 10, fat: 1, fiber: 2,
    ),
    MealFood(
      id: 'moong-tadka', name: 'Moong Dal (Tadka)', serving: '1 katori (150 g)',
      imageAsset: 'lib/assets/images/food/moong_dal_tadka.png', calories: 120,
      protein: 6, carbs: 14, fat: 5, fiber: 3,
    ),
    MealFood(
      id: 'moong-chilla', name: 'Moong Dal Chilla', serving: '1 piece (50 g)',
      imageAsset: 'lib/assets/images/food/moong_dal_chilla.png', calories: 90,
      protein: 4, carbs: 13, fat: 2, fiber: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialItems?.map((e) => e.copy()).toList() ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MealFood> get _results {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _foods;
    return _foods.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  void _addFood(MealFood food) {
    setState(() {
      final existing = _selected.indexWhere((e) => e.id == food.id);
      if (existing >= 0) {
        _selected[existing].quantity++;
      } else {
        final item = food.copy()..quantity = 1;
        _selected.add(item);
      }
    });
  }

  Future<void> _openSummary() async {
    if (_selected.isEmpty) return;
    final updated = await Navigator.of(context).push<List<MealFood>>(
      MaterialPageRoute(
        builder: (_) => NutritionSummaryScreen(
          items: _selected.map((e) => e.copy()).toList(),
        ),
      ),
    );
    if (updated != null && mounted) {
      setState(() {
        _selected = updated.map((e) => e.copy()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchField(),
                    const SizedBox(height: 14),
                    if (_searchController.text.isEmpty) _recentStrip(),
                    if (_selected.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _sectionHeader('Add Items(${_selected.length})', action: 'Save Meal', onAction: () => Navigator.of(context).pop(_selected.map((e) => e.copy()).toList())),
                      const SizedBox(height: 8),
                      ..._selected.asMap().entries.map((entry) => _selectedCard(entry.value, entry.key)),
                    ] else ...[
                      const SizedBox(height: 12),
                      Text('Search results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    ],
                    const SizedBox(height: 8),
                    ..._results.map(_resultCard),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(35, 10, 35, 20),
        child: ElevatedButton(
          onPressed: _selected.isEmpty ? null : _openSummary,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            disabledBackgroundColor: AppColors.lightBlue,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('View Nutrition Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              SizedBox(width: 10),
              Icon(Icons.chevron_right, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.textGrey, width: 2.5)),
                child: const Icon(Icons.close, color: AppColors.textGrey, size: 28),
              ),
            ),
            const Expanded(child: Center(child: Text('Add Meal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
            const SizedBox(width: 44),
          ],
        ),
      );

  Widget _searchField() => TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search food',
          prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(onPressed: () { _searchController.clear(); setState(() {}); }, icon: const Icon(Icons.close))
              : null,
          filled: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: Color(0xFFB5C1C9))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: Color(0xFFB5C1C9))),
        ),
      );

  Widget _recentStrip() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Recent Updates', action: 'View All', onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecentMealsScreen()))),
          const SizedBox(height: 10),
          SizedBox(
            height: 92,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _recentFood('Roti', 'lib/assets/images/food/roti.png'),
                _recentFood('Moong Dal', 'lib/assets/images/food/moong_dal_cooked.png'),
                _recentFood('Rice', 'lib/assets/images/food/rice.png'),
                _recentFood('Curd', 'lib/assets/images/food/curd.png'),
                _recentFood('Aloo Sabz', 'lib/assets/images/food/aloo_sabz.png'),
              ],
            ),
          ),
        ],
      );

  Widget _recentFood(String label, String asset) => Container(
        width: 78,
        margin: const EdgeInsets.only(right: 4),
        child: Column(
          children: [
            Container(width: 58, height: 58, padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFBAC8D1))), child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover))),
            const SizedBox(height: 5),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
          ],
        ),
      );

  Widget _sectionHeader(String title, {String? action, VoidCallback? onAction}) => Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const Spacer(),
          if (action != null) TextButton(onPressed: onAction, child: Text(action, style: const TextStyle(color: AppColors.primaryBlue))),
        ],
      );

  Widget _resultCard(MealFood food) => Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(width: 58, height: 58, padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD0D8DE))), child: ClipOval(child: Image.asset(food.imageAsset, fit: BoxFit.cover))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(food.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)), const SizedBox(height: 2), Text(food.serving, style: const TextStyle(fontSize: 13, color: AppColors.textGrey))])),
            IconButton(onPressed: () => _addFood(food), icon: const Icon(Icons.add, color: AppColors.primaryBlue, size: 28)),
          ],
        ),
      );

  Widget _selectedCard(MealFood food, int index) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFBCD4E2)), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.name.replaceAll(' (Cooked)', ''), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(children: [
              _quantityControl(food, index),
              const SizedBox(width: 28),
              Container(height: 42, padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF9DB6C6)), borderRadius: BorderRadius.circular(8)), child: Row(children: [Text(food.serving.split(' ').take(2).join(' '), style: const TextStyle(fontSize: 15)), const SizedBox(width: 10), const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey)])),
              const Spacer(),
              IconButton(onPressed: () => setState(() => _selected.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
            ]),
          ],
        ),
      );

  Widget _quantityControl(MealFood food, int index) => Container(
        height: 42,
        width: 140,
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF9DB6C6)), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(onTap: () => setState(() { if (food.quantity > 1) food.quantity--; }), child: const Text('−', style: TextStyle(color: AppColors.primaryBlue, fontSize: 22))),
          Text('${food.quantity}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          GestureDetector(onTap: () => setState(() => food.quantity++), child: const Text('+', style: TextStyle(color: AppColors.primaryBlue, fontSize: 20))),
        ]),
      );
}
