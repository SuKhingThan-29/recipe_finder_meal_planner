import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/recipe_adapter.dart';
import '../../core/providers/favorite_recipe_provider.dart';
import '../../core/providers/meal_planner_provider.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteRecipes = ref.watch(favoriteRecipesProvider);
    final mealPlan = ref.watch(mealPlanProvider);

    // Load favorites when the screen loads
    ref.read(favoriteRecipesProvider.notifier).loadFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weekly Meal Planner"),
        backgroundColor: Colors.deepOrangeAccent, // Accent color for the app
        elevation: 0,
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(
        child: Text(
          'There are no favorite recipes. Please add some!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Plan your meals for the week",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 7, // 7 days of the week
                itemBuilder: (context, index) {
                  // Get selected recipe for the day (if any)
                  final selectedRecipe = mealPlan.weeklyMealPlan[index];

                  //Check if the selected recipe is still in the list of favorite recipes
                  final isRecipeAvailable = favoriteRecipes.any((recipe) => recipe.id == selectedRecipe?.id);

                  //If the selected recipe is not available, set it to null
                  final validSelectedRecipe = isRecipeAvailable ? selectedRecipe : null;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        "Day ${index + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 220, // Adjust width for dropdown
                        child: DropdownButton<Recipe>(
                          value: validSelectedRecipe,//use the valid recipe or null
                          hint: const Text("Select a Recipe"),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 28,
                          underline: Container(),
                          items: favoriteRecipes
                              .where((recipe) => recipe != null)
                              .toSet()
                              .toList()
                              .map((recipe) {
                            return DropdownMenuItem<Recipe>(
                              value: recipe,
                              child: Text(
                                recipe.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (onChangedValue) {
                            if (onChangedValue != null) {
                              ref
                                  .read(mealPlanProvider.notifier)
                                  .updateMealPlan(index, onChangedValue);
                            }else{
                              ref.read(mealPlanProvider.notifier).updateMealPlan(index, null);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
