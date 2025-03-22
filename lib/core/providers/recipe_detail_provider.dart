import '../models/recipe_details.dart';
import '../services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Recipe Details Provider
final recipeDetailsProvider = FutureProvider.family<List<RecipeDetails>, int>((ref, recipeId) async {
  return ref.read(apiServiceProvider).fetchRecipeDetails(recipeId);
});