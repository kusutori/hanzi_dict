import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mcp_dict.dart';

// Platform detection helper for web compatibility
bool get _isWeb => kIsWeb;
bool get _isMobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);
bool get _isDesktop =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS);

class FavoritesStorageService {
  static const String _storageLocationKey = 'favorites_storage_location';
  static const String _favoritesFileName = 'hanzi_favorites.json';
  static const String _webFavoritesKey = 'web_favorites_data';

  String? _customStoragePath;

  // Initialize the storage service by loading saved storage location
  Future<void> initialize() async {
    if (!_isWeb) {
      final prefs = await SharedPreferences.getInstance();
      _customStoragePath = prefs.getString(_storageLocationKey);
    }
  }

  // Set custom storage location (not applicable for web)
  Future<void> setStorageLocation(String? path) async {
    if (_isWeb) {
      debugPrint('Custom storage location not supported on web platform');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    _customStoragePath = path;

    if (path != null && path.isNotEmpty) {
      await prefs.setString(_storageLocationKey, path);
    } else {
      await prefs.remove(_storageLocationKey);
    }
  }

  // Get current storage location (for display purposes)
  Future<String> getCurrentStorageLocation() async {
    if (_isWeb) {
      return 'Browser Local Storage';
    }

    try {
      final directory = await _getStorageDirectory();
      return directory.path;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Get the current storage directory (only for non-web platforms)
  Future<Directory> _getStorageDirectory() async {
    if (_isWeb) {
      throw UnsupportedError('File system not available on web platform');
    }

    if (_customStoragePath != null && _customStoragePath!.isNotEmpty) {
      return Directory(_customStoragePath!);
    }

    // Use default application documents directory based on platform
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      debugPrint('Error getting documents directory: $e');
      // Create a temporary directory as fallback
      return await getTemporaryDirectory();
    }
  }

  // Get the full path to the favorites file (only for non-web platforms)
  Future<String> _getFavoritesFilePath() async {
    if (_isWeb) {
      throw UnsupportedError('File paths not available on web platform');
    }

    final directory = await _getStorageDirectory();
    final separator = Platform.pathSeparator;
    return '${directory.path}$separator$_favoritesFileName';
  }

  // Save favorites - platform specific implementation
  Future<bool> saveFavorites(List<McpDict> favorites) async {
    try {
      if (_isWeb) {
        return await _saveFavoritesWeb(favorites);
      } else {
        return await _saveFavoritesFile(favorites);
      }
    } catch (e) {
      debugPrint('Error saving favorites: $e');
      return false;
    }
  }

  // Web-specific save using SharedPreferences
  Future<bool> _saveFavoritesWeb(List<McpDict> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = favorites.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonData);

      final success = await prefs.setString(_webFavoritesKey, jsonString);
      debugPrint('Favorites saved to web storage: ${favorites.length} items');
      return success;
    } catch (e) {
      debugPrint('Error saving favorites to web storage: $e');
      return false;
    }
  }

  // File-based save for non-web platforms
  Future<bool> _saveFavoritesFile(List<McpDict> favorites) async {
    try {
      final filePath = await _getFavoritesFilePath();
      final file = File(filePath);

      // Ensure directory exists
      await file.parent.create(recursive: true);

      // Convert favorites to JSON
      final jsonData = favorites.map((item) => item.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Write to file
      await file.writeAsString(jsonString);

      debugPrint('Favorites saved to: $filePath');
      return true;
    } catch (e) {
      debugPrint('Error saving favorites to file: $e');
      return false;
    }
  }

  // Load favorites - platform specific implementation
  Future<List<McpDict>> loadFavorites() async {
    try {
      if (_isWeb) {
        return await _loadFavoritesWeb();
      } else {
        return await _loadFavoritesFile();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      return [];
    }
  }

  // Web-specific load using SharedPreferences
  Future<List<McpDict>> _loadFavoritesWeb() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_webFavoritesKey);

      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('No favorites found in web storage');
        return [];
      }

      final List<dynamic> jsonData = json.decode(jsonString);
      final favorites = jsonData.map((item) => McpDict.fromJson(item)).toList();

      debugPrint('Loaded ${favorites.length} favorites from web storage');
      return favorites;
    } catch (e) {
      debugPrint('Error loading favorites from web storage: $e');
      return [];
    }
  }

  // File-based load for non-web platforms
  Future<List<McpDict>> _loadFavoritesFile() async {
    try {
      final filePath = await _getFavoritesFilePath();
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Favorites file does not exist: $filePath');
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      final favorites = jsonData.map((item) => McpDict.fromJson(item)).toList();

      debugPrint('Loaded ${favorites.length} favorites from: $filePath');
      return favorites;
    } catch (e) {
      debugPrint('Error loading favorites from file: $e');
      return [];
    }
  }

  // Export favorites to a specific location (only for non-web platforms)
  Future<bool> exportFavorites(
    List<McpDict> favorites,
    String exportPath,
  ) async {
    if (_isWeb) {
      debugPrint('Export not supported on web platform');
      return false;
    }

    try {
      final file = File(exportPath);

      // Ensure directory exists
      await file.parent.create(recursive: true);

      // Create export data with metadata
      final exportData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'count': favorites.length,
        'favorites': favorites.map((item) => item.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      // Write to file
      await file.writeAsString(jsonString);

      debugPrint('Favorites exported to: $exportPath');
      return true;
    } catch (e) {
      debugPrint('Error exporting favorites: $e');
      return false;
    }
  }

  // Import favorites from a specific file (only for non-web platforms)
  Future<List<McpDict>?> importFavorites(String importPath) async {
    if (_isWeb) {
      debugPrint('Import not supported on web platform');
      return null;
    }

    try {
      final file = File(importPath);

      if (!await file.exists()) {
        debugPrint('Import file does not exist: $importPath');
        return null;
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Check if it's an export file with metadata
      List<dynamic> favoritesData;
      if (jsonData.containsKey('favorites')) {
        favoritesData = jsonData['favorites'];
      } else {
        // Assume it's a direct array of favorites
        favoritesData = jsonData as List<dynamic>;
      }

      final favorites =
          favoritesData.map((item) => McpDict.fromJson(item)).toList();

      debugPrint('Imported ${favorites.length} favorites from: $importPath');
      return favorites;
    } catch (e) {
      debugPrint('Error importing favorites: $e');
      return null;
    }
  }

  // Check if favorites file exists
  Future<bool> favoritesFileExists() async {
    try {
      if (_isWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.containsKey(_webFavoritesKey);
      } else {
        final filePath = await _getFavoritesFilePath();
        final file = File(filePath);
        return await file.exists();
      }
    } catch (e) {
      return false;
    }
  }

  // Get file size of favorites file (returns data size for web)
  Future<int> getFavoritesFileSize() async {
    try {
      if (_isWeb) {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_webFavoritesKey);
        return jsonString?.length ?? 0;
      } else {
        final filePath = await _getFavoritesFilePath();
        final file = File(filePath);
        if (await file.exists()) {
          return await file.length();
        }
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
}
