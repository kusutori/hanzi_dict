import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'database_helper.dart';
import 'components/hanzi_card.dart';
import 'models/mcp_dict.dart';
import 'settings_page.dart';
import 'favorites_page.dart';
import 'models/favorites_provider.dart';
import 'models/language_provider.dart';
import 'models/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'custom_title_bar.dart';
import 'components/theme_selector_dialog.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const AppInitializer(),
    ),
  );

  // Initialize bitsdojo_window for Windows only
  if (defaultTargetPlatform == TargetPlatform.windows) {
    doWhenWindowReady(() {
      const initialSize = Size(1280, 720);
      appWindow.minSize = const Size(400, 300); // 降低最小尺寸限制
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = 'Hanzi Dictionary';
      // 添加短暂延迟确保Flutter完全准备好
      Future.delayed(const Duration(milliseconds: 100), () {
        appWindow.show();
      });
    });
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await favoritesProvider.initialize();
    await themeProvider.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return const MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
        final List<Widget> pages = [
          const SearchPage(),
          const FavoritesPage(),
          const SettingsPage(),
        ];

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hanzi Dictionary',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: languageProvider.currentLocale,
          home: Scaffold(
            body: Column(
              children: [
                // Custom title bar - 仅在Windows平台显示
                if (defaultTargetPlatform == TargetPlatform.windows)
                  const CustomTitleBar(title: 'Hanzi Dictionary'),

                // Main content
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWideScreen = constraints.maxWidth >= 600;
                      final localizations = AppLocalizations.of(context)!;

                      return Scaffold(
                        body: Row(
                          children: [
                            if (isWideScreen)
                              NavigationRail(
                                selectedIndex: _selectedIndex,
                                onDestinationSelected: _onItemTapped,
                                labelType: NavigationRailLabelType.all,
                                destinations: [
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.home),
                                    label: Text(localizations.home),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.favorite),
                                    label: Text(localizations.favorites),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.settings),
                                    label: Text(localizations.settings),
                                  ),
                                ],
                              ),
                            Expanded(
                              child: IndexedStack(
                                index: _selectedIndex,
                                children: pages,
                              ),
                            ),
                          ],
                        ),
                        bottomNavigationBar:
                            isWideScreen
                                ? null
                                : BottomNavigationBar(
                                  items: [
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.home),
                                      label: localizations.home,
                                    ),
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.favorite),
                                      label: localizations.favorites,
                                    ),
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.settings),
                                      label: localizations.settings,
                                    ),
                                  ],
                                  currentIndex: _selectedIndex,
                                  onTap: _onItemTapped,
                                ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  @override
  void dispose() {
    _dbHelper.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isMobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions:
            isMobile
                ? [
                  // 暗模式切换按钮
                  IconButton(
                    icon: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : themeProvider.themeMode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.brightness_auto,
                    ),
                    onPressed: () {
                      // 循环切换主题模式
                      final currentMode = themeProvider.themeMode;
                      if (currentMode == ThemeMode.light) {
                        themeProvider.setThemeMode(ThemeMode.dark);
                      } else if (currentMode == ThemeMode.dark) {
                        themeProvider.setThemeMode(ThemeMode.system);
                      } else {
                        themeProvider.setThemeMode(ThemeMode.light);
                      }
                    },
                    tooltip:
                        themeProvider.themeMode == ThemeMode.dark
                            ? '深色模式'
                            : themeProvider.themeMode == ThemeMode.light
                            ? '浅色模式'
                            : '跟随系统',
                  ),
                  // 主题选择器按钮
                  IconButton(
                    icon: const Icon(Icons.palette),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ThemeSelectorDialog(),
                      );
                    },
                    tooltip: '主题颜色',
                  ),
                ]
                : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: localizations.search,
                hintText: localizations.searchHint,
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
                return HanziCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
