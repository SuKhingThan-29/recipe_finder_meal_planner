import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/recipe_adapter.dart';
import '../../core/providers/recipe_detail_provider.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    final recipeDetails = ref.watch(recipeDetailsProvider(recipe.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrangeAccent, // Customizing AppBar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Consistent padding around the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl:recipe.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(),

              // Fetch Instructions, Ingredients, and Nutrition Data
              recipeDetails.when(
                data: (detailsList) {
                  if (detailsList.isEmpty) {
                    return const Text(
                      "No details available.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    );
                  }

                  final details = detailsList.first;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instructions Section
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Instructions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          details.instructions ?? "No instructions available.",
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      const Divider(),

                      // Ingredients Section with Cards
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      ...details.ingredients.map((ingredient) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl:ingredient.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorWidget: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                                },
                              ),
                            ),
                            title: Text(
                              ingredient.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(ingredient.amount),
                          ),
                        );
                      }),
                      const Divider(),

                      // Nutritional Information Section with Card
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Nutritional Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width:double.infinity,
                          child: Text(
                            details.nutritionInfo,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
