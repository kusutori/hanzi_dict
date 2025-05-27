import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/hanzi_card.dart';
// import 'models/mcp_dict.dart';
import 'models/favorites_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body:
          favorites.isEmpty
              ? const Center(child: Text('No favorites yet.'))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return HanziCard(item: favorites[index]);
                },
              ),
    );
  }
}
