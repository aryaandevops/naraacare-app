import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/meal_entry.dart';

class NutritionSummaryScreen extends StatelessWidget {
  final List<MealFood> items;
  const NutritionSummaryScreen({super.key, required this.items});

  int get calories => items.fold(0, (s, e) => s + e.totalCalories);
  int get protein => items.fold(0, (s, e) => s + e.totalProtein);
  int get carbs => items.fold(0, (s, e) => s + e.totalCarbs);
  int get fat => items.fold(0, (s, e) => s + e.totalFat);
  int get fiber => items.fold(0, (s, e) => s + e.totalFiber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 18), child: Row(children: [
            GestureDetector(onTap: () => Navigator.of(context).pop(), child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.textGrey, width: 2.5)), child: const Icon(Icons.close, color: AppColors.textGrey, size: 28))),
            const Expanded(child: Center(child: Text('Add Meal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Save Meal', style: TextStyle(color: AppColors.primaryBlue))),
          ])),
          Expanded(child: SingleChildScrollView(child: Column(children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 35), child: Align(alignment: Alignment.centerLeft, child: Text('Nutrition Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)))),
            const SizedBox(height: 20),
            _row('🔥 Calories', '$calories kcal'),
            _row('🥜 Protein', '$protein g'),
            _row('🍞 Carbohydrates', '$carbs g'),
            _row('🥑 Fat', '$fat g'),
            _row('🌾 Fiber', '$fiber g'),
            const SizedBox(height: 22),
            Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), color: const Color(0xFFF8F4FF), child: Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17), decoration: BoxDecoration(color: const Color(0xFF6F50AA), borderRadius: BorderRadius.circular(15)), child: const Column(children: [Text('★  Unlock STAR', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)), SizedBox(height: 6), Text('Get detailed insights on 10+ nutrients with STAR plan.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12))]))),
          ]))),
          Padding(padding: const EdgeInsets.fromLTRB(36, 10, 36, 20), child: ElevatedButton(onPressed: () => Navigator.of(context).pop(items.map((e) => e.copy()).toList()), style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 58), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), child: const Text('Update Meal'))),
        ]),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(padding: const EdgeInsets.fromLTRB(35, 0, 35, 26), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textGrey))), Text(value, style: const TextStyle(fontSize: 16, color: AppColors.textGrey, fontWeight: FontWeight.w600))]));
}
