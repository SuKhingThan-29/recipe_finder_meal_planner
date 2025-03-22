import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe_adapter.dart';
import '../services/api_service.dart';
import 'search_query_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Default Recipes Provider (Loads when screen opens)
final defaultRecipeProvider = FutureProvider.autoDispose<List<Recipe>>((ref) async {
  return ref.read(apiServiceProvider).fetchRecipes("tomato,cheese");
});


// Recipe Provider (Fetches recipes only when search button is clicked)
final recipeProvider = FutureProvider.autoDispose<List<Recipe>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  if (searchQuery.isEmpty) {
    return ref.watch(defaultRecipeProvider.future); // Show default recipes
  }
  return ref.read(apiServiceProvider).fetchRecipes(searchQuery);
});
