class MealFood {
  final String id;
  final String name;
  final String serving;
  final String imageAsset;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  int quantity;

  MealFood({
    required this.id,
    required this.name,
    required this.serving,
    required this.imageAsset,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    this.quantity = 1,
  });

  MealFood copy() => MealFood(
        id: id,
        name: name,
        serving: serving,
        imageAsset: imageAsset,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        fiber: fiber,
        quantity: quantity,
      );

  int get totalCalories => calories * quantity;
  int get totalProtein => protein * quantity;
  int get totalCarbs => carbs * quantity;
  int get totalFat => fat * quantity;
  int get totalFiber => fiber * quantity;
}
