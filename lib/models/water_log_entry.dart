/// What kind of drink a log entry represents.
/// Only [water] counts toward the hydration goal ring on Home for now —
/// see the TODO in home_screen.dart if/when other drinks should also
/// count toward (or against) the hydration goal.
enum DrinkCategory { water, tea, coffee, juice, milk, beer, coconutWater, custom }

class WaterLogEntry {
  final String id;
  final String label; // e.g. 'Water', 'Tea', 'Banana Shake'
  final DrinkCategory category;
  final int amountMl;
  final DateTime time;

  WaterLogEntry({
    required this.id,
    required this.label,
    required this.category,
    required this.amountMl,
    required this.time,
  });

  WaterLogEntry copyWith({String? label, DrinkCategory? category, int? amountMl, DateTime? time}) {
    return WaterLogEntry(
      id: id,
      label: label ?? this.label,
      category: category ?? this.category,
      amountMl: amountMl ?? this.amountMl,
      time: time ?? this.time,
    );
  }
}

/// Preset drinks shown as quick-select chips in the "Other Drinks" tab.
const List<String> kPresetDrinks = [
  'Tea',
  'Coffee',
  'Juice',
  'Milk',
  'Beer',
  'Coconut Water',
];
