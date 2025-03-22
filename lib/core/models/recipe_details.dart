class RecipeDetails {
  final String? instructions;
  final String nutritionInfo;
  final List<Ingredient> ingredients;

  RecipeDetails({
    this.instructions,
    required this.nutritionInfo,
    required this.ingredients,
  });

  factory RecipeDetails.fromJson(Map<String, dynamic> json) {
    return RecipeDetails(
      instructions: json["instructions"] ?? "No instructions available",
      nutritionInfo: (json["nutrition"] != null && json["nutrition"]["nutrients"] != null)
          ? (json["nutrition"]["nutrients"] as List<dynamic>)
          .map((n) => "${n["name"]}: ${n["amount"]}${n["unit"]}")
          .join("\n")
          : "No nutrition data available",
      ingredients: (json["extendedIngredients"] as List<dynamic>)
          .map((i) => Ingredient.fromJson(i))
          .toList(),

    );
  }
}

class Ingredient {
  final String name;
  final String image;
  final String amount;

  Ingredient({
    required this.name,
    required this.image,
    required this.amount,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json["name"],
      image: "https://spoonacular.com/cdn/ingredients_100x100/${json["image"]}",
      amount: "${json["amount"]} ${json["unit"]}",
    );
  }
}
