import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_plan.dart';
import '../models/recipe_adapter.dart';

import 'package:hive/hive.dart';

final mealPlanProvider = StateNotifierProvider<MealPlanNotifier, MealPlan>((ref) {
  return MealPlanNotifier();
});

class MealPlanNotifier extends StateNotifier<MealPlan> {
  MealPlanNotifier() : super(MealPlan(weeklyMealPlan: {})) {
    _loadMealPlan();
  }

  Future<void> _loadMealPlan() async {
    var box = await Hive.openBox<MealPlan>('mealPlans');
    if (box.isNotEmpty) {
      final savedMealPlan = box.getAt(0); // Retrieve meal plan saved at index 0
      if (savedMealPlan != null) {
        state = savedMealPlan;
      }
    }
  }

  Future<void> saveMealPlan() async {
    var box = await Hive.openBox<MealPlan>('mealPlans');
    await box.put(0, state); // Store the entire meal plan object at index 0
  }

  void updateMealPlan(int day, Recipe? recipe) {
    // Update the weeklyMealPlan for the specific day
    state = MealPlan(
      weeklyMealPlan: Map<int, Recipe>.from(state.weeklyMealPlan)..[day] = recipe!,
    );

    // Log the updated state
    saveMealPlan(); // Save meal plan whenever it's updated
  }
}


