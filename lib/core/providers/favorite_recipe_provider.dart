import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe_adapter.dart';
import '../services/local_storage_service.dart';

// final favoriteRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
//   return LocalStorageService().getFavoriteRecipes();
// });


final favoriteRecipesProvider = StateNotifierProvider<FavoriteRecipesNotifier, List<Recipe>>((ref) {
  return FavoriteRecipesNotifier();
});

class FavoriteRecipesNotifier extends StateNotifier<List<Recipe>> {
  FavoriteRecipesNotifier() : super([]);

  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> loadFavorites() async {
    final favoriteRecipes = await _localStorageService.getFavoriteRecipes();
    state = favoriteRecipes; // Update the state with the list of favorite recipes
  }

  Future<void> addFavorite(Recipe recipe) async {
    await _localStorageService.saveFavoriteRecipe(recipe);
    await loadFavorites(); // Reload favorites after adding
  }

  Future<void> removeFavorite(Recipe recipe) async {
    await _localStorageService.removeFavoriteRecipe(recipe.id);
    await loadFavorites(); // Reload favorites after removing
  }
}

