import 'package:hive/hive.dart';

part 'recipe_adapter.g.dart'; // Auto-generated file for Hive adapter

@HiveType(typeId: 0) // Unique type ID for Hive
class Recipe {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final List<String> ingredients;

  @HiveField(4)
  final String instructions;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      ingredients: (json['extendedIngredients'] as List<dynamic>?)
          ?.map((e) => e['original'] as String)
          .toList() ??
          [],
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }
}
