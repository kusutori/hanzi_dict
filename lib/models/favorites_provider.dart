import 'package:flutter/material.dart';
import 'mcp_dict.dart';
import '../services/favorites_storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<McpDict> _favorites = [];
  final FavoritesStorageService _storageService = FavoritesStorageService();
  bool _isInitialized = false;

  List<McpDict> get favorites => List.unmodifiable(_favorites);
  bool get isInitialized => _isInitialized;

  // Initialize the provider by loading stored favorites
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _storageService.initialize();
    final storedFavorites = await _storageService.loadFavorites();
    _favorites.clear();
    _favorites.addAll(storedFavorites);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addFavorite(McpDict item) async {
    if (!_favorites.contains(item)) {
      _favorites.add(item);
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(McpDict item) async {
    if (_favorites.contains(item)) {
      _favorites.remove(item);
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  bool isFavorite(McpDict item) {
    return _favorites.contains(item);
  }

  // Storage management methods
  Future<String> getCurrentStorageLocation() async {
    return await _storageService.getCurrentStorageLocation();
  }

  Future<void> setCustomStorageLocation(String? path) async {
    await _storageService.setStorageLocation(path);
    // Reload favorites from new location
    final storedFavorites = await _storageService.loadFavorites();
    _favorites.clear();
    _favorites.addAll(storedFavorites);
    notifyListeners();
  }

  // Export/Import methods
  Future<bool> exportFavorites(String exportPath) async {
    return await _storageService.exportFavorites(_favorites, exportPath);
  }

  Future<bool> importFavorites(String importPath) async {
    final importedFavorites = await _storageService.importFavorites(importPath);
    if (importedFavorites != null) {
      // Merge with existing favorites (avoid duplicates)
      for (final item in importedFavorites) {
        if (!_favorites.contains(item)) {
          _favorites.add(item);
        }
      }
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Get favorites count
  int get favoritesCount => _favorites.length;
}
