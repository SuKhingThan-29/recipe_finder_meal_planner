import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/recipe_adapter.dart';
import '../../core/providers/favorite_recipe_provider.dart';
import '../../core/providers/recipe_provider.dart';
import '../../core/providers/search_query_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load favorites when the screen is initialized
    ref.read(favoriteRecipesProvider.notifier).loadFavorites();
  }

  // Toggle the favorite status of a recipe
  Future<void> _toggleFavorite(Recipe recipe) async {
    final isFav = ref.read(favoriteRecipesProvider).contains(recipe);
    if (isFav) {
      ref.read(favoriteRecipesProvider.notifier).removeFavorite(recipe);
    } else {
      ref.read(favoriteRecipesProvider.notifier).addFavorite(recipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = ref.watch(favoriteRecipesProvider);
    final recipes = ref.watch(recipeProvider);

    // Get screen width to adjust layout
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine if the screen is large (tablet or web)
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Search"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen size
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter ingredients",
                hintText: 'e.g. tomato, cheese',
                hintStyle: const TextStyle(color: Colors.grey),
                labelStyle: const TextStyle(color: Colors.deepOrange),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: screenWidth * 0.05), // Dynamic padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).state = _controller.text.trim();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: recipes.when(
              data: (recipeList) => recipeList.isEmpty
                  ? const Center(child: Text('No recipes found'))
                  : GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding dynamically
                itemCount: recipeList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLargeScreen ? 4 : 2, // 4 columns for large screens (tablet/web)
                  childAspectRatio: isLargeScreen ? 0.7 : 0.75, // Adjust aspect ratio based on screen
                  crossAxisSpacing: screenWidth * 0.05, // Dynamic spacing
                  mainAxisSpacing: screenWidth * 0.05, // Dynamic spacing
                ),
                itemBuilder: (context, index) {
                  final recipe = recipeList[index];

                  // Check if the current recipe is in the favorites
                  final isFav = favoriteRecipes.any((favRecipe) => favRecipe.id == recipe.id);
                  print("RecipeImage: ${recipe.imageUrl}");
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/details', arguments: recipe);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: CachedNetworkImage(
                               imageUrl:  recipe.imageUrl,
                               // Test for web: "https://res.cloudinary.com/dqvdxkelc/image/upload/v1742604493/categoryImages/yd37g0gqcptqx1e3tzna.png",
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorWidget: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
                            child: Text(
                              recipe.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(recipe),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text("Error: $err"),
            ),
          ),
        ],
      ),
    );
  }
}
