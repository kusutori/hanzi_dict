import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'models/hanzi_card.dart';
import 'models/mcp_dict.dart';
import 'settings_page.dart';
import 'theme.dart'; // 引入拆分的主题文件
import 'favorites_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  int _selectedIndex = 0;
  final List<McpDict> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    setState(() {
      _themeMode = ThemeMode.values[themeIndex];
    });
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  void _updateThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(themeMode);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const SearchPage(),
      FavoritesPage(favorites: _favorites),
      SettingsPage(themeMode: _themeMode, onThemeModeChanged: _updateThemeMode),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanzi Dictionary',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 600;

          return Scaffold(
            body: Row(
              children: [
                if (isWideScreen)
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _onItemTapped,
                    labelType: NavigationRailLabelType.all, // 显示图标和文字
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                Expanded(
                  child: IndexedStack(index: _selectedIndex, children: _pages),
                ),
              ],
            ),
            bottomNavigationBar:
                isWideScreen
                    ? null
                    : BottomNavigationBar(
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.favorite),
                          label: 'Favorites',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'Settings',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                    ),
          );
        },
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<McpDict> _results = [];
  final List<McpDict> _favorites = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _dbHelper.initDatabase();
  }

  Future<void> _search(String query) async {
    final results = await _dbHelper.search(query);
    setState(() {
      _results = results;
    });
  }

  void _addToFavorites(McpDict item) {
    setState(() {
      if (!_favorites.contains(item)) {
        _favorites.add(item);
      }
    });
  }

  @override
  void dispose() {
    _dbHelper.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hanzi Dictionary')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_searchController.text),
                ),
              ),
              onSubmitted: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                return HanziCard(
                  item: item,
                  onFavorite: () => _addToFavorites(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
