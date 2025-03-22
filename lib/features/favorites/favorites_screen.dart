import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/recipe_adapter.dart';
import '../../core/providers/favorite_recipe_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites when the screen is initialized
    ref.read(favoriteRecipesProvider.notifier).loadFavorites();
  }

  Future<void> _removeFavorite(Recipe recipe) async {
    await ref.read(favoriteRecipesProvider.notifier).removeFavorite(recipe);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = ref.watch(favoriteRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Recipes"),
        backgroundColor: Colors.deepOrangeAccent, // Customizing AppBar color
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(
        child: Text(
          "No favorite recipes yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for cleaner UI
        child: ListView.builder(
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = favoriteRecipes[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners for card
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12.0), // Add padding inside the ListTile
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                   imageUrl:  recipe.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  ),
                ),
                title: Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                subtitle: const Text(
                  "Tap to view details",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeFavorite(recipe),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/details', arguments: recipe);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
