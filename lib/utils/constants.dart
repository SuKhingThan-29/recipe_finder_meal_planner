class Constants {
  static const String apiKey = "afacc85eeb3845a7a1bbae8ae6f30d5b"; // Replace with your actual API key
  static const String baseUrl = "https://api.spoonacular.com";

  //Find By Ingredient for Search Screen
  static const String findByIngredient = "/recipes/findByIngredients";
  static const String recipeDetail="/recipes/informationBulk?ids=";
  static const Duration cacheDuration = Duration(minutes: 30);
}
