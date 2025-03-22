import 'package:dio/dio.dart';
import '../../utils/cache_manager.dart';
import '../../utils/constants.dart';
import '../models/recipe_adapter.dart';
import '../models/recipe_details.dart';
class ApiService {
  final Dio _dio = Dio();

  Future<List<Recipe>> fetchRecipes(String ingredients) async {
    final String cacheKey = "recipes_$ingredients";
    final cachedData = await CacheManager.getCache(cacheKey, Constants.cacheDuration);

    if (cachedData != null) {
      return (cachedData as List).map((json) => Recipe.fromJson(json)).toList();
    }

    try {
      final response = await _dio.get("${Constants.baseUrl}${Constants.findByIngredient}", queryParameters: {
        "ingredients": ingredients,
        "number": 30,
        "apiKey": Constants.apiKey,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        await CacheManager.saveCache(cacheKey, data);
        return data.map((recipe) => Recipe.fromJson(recipe)).toList();
      }
    } catch (e) {
      throw Exception("Failed to fetch recipes: $e");
    }

    return [];
  }

  // Fetch recipe details by ID
  Future<List<RecipeDetails>> fetchRecipeDetails(int recipeId) async {
    try {
      final response = await _dio.get(
        "https://api.spoonacular.com/recipes/informationBulk",
        queryParameters: {
          "ids": recipeId,
          "includeNutrition": true,
          "apiKey": Constants.apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((recipe) => RecipeDetails.fromJson(recipe)).toList();
      } else {
        throw Exception("Failed to load recipe details");
      }
    } catch (e) {
      throw Exception("Error fetching recipe details: $e");
    }
  }
}
