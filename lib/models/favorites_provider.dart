import 'package:flutter/material.dart';
import 'mcp_dict.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<McpDict> _favorites = [];

  List<McpDict> get favorites => List.unmodifiable(_favorites);

  void addFavorite(McpDict item) {
    if (!_favorites.contains(item)) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void removeFavorite(McpDict item) {
    if (_favorites.contains(item)) {
      _favorites.remove(item);
      notifyListeners();
    }
  }

  bool isFavorite(McpDict item) {
    return _favorites.contains(item);
  }
}
