import 'package:flutter/material.dart';
import 'models/hanzi_card.dart';
import 'models/mcp_dict.dart';

class FavoritesPage extends StatelessWidget {
  final List<McpDict> favorites;

  const FavoritesPage({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body:
          favorites.isEmpty
              ? const Center(child: Text('No favorites yet.'))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return HanziCard(
                    item: favorites[index],
                    onFavorite: () {
                      // 收藏页面的卡片不需要再次收藏，提供一个空回调
                    },
                  );
                },
              ),
    );
  }
}
