import 'package:hive/hive.dart';

import '../models/meal_plan.dart';
import '../models/recipe_adapter.dart';


class LocalStorageService {
  static const String _favoritesBox = "favorites";
  static const String _mealplanBox="mealPlans";

  Future<void> saveFavoriteRecipe(Recipe recipe) async {
    final box = await Hive.openBox<Recipe>(_favoritesBox);
    box.put(recipe.id, recipe);
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final box = await Hive.openBox<Recipe>(_favoritesBox);
    return box.values.toList();
  }

  Future<void> removeFavoriteRecipe(int id) async {
    final box = await Hive.openBox<Recipe>(_favoritesBox);
    box.delete(id);
  }

}
