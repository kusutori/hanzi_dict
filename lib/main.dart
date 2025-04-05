import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/mcp_dict.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hanzi Dictionary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchPage(),
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
  List<McpDict> _results = [];
  late Database _database;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mcpdict.db');

    // 确保目标目录存在
    final directory = Directory(dbPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // 检查数据库文件是否存在
    final file = File(path);
    if (!await file.exists()) {
      // 从 assets 文件夹复制数据库
      final byteData = await rootBundle.load('assets/mcpdict.db');
      final buffer = byteData.buffer;
      await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }

    _database = await openDatabase(path, readOnly: true);
  }

  Future<void> _search(String query) async {
    String searchQuery;

    // 检查输入是否为汉字
    if (query.codeUnits.every((unit) => unit >= 0x4E00 && unit <= 0x9FFF)) {
      // 将汉字转换为 Unicode
      searchQuery =
          query.codeUnits
              .map((unit) => unit.toRadixString(16).toUpperCase())
              .join();
    } else {
      searchQuery = query;
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      'mcpdict',
      where: 'unicode LIKE ? OR mc LIKE ? OR pu LIKE ?',
      whereArgs: ['%$searchQuery%', '%$searchQuery%', '%$searchQuery%'],
    );

    setState(() {
      _results = maps.map((map) => McpDict.fromJson(map)).toList();
    });
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hanzi Dictionary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
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
            const SizedBox(height: 16),
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
      ),
    );
  }
}

class HanziCard extends StatelessWidget {
  final McpDict item;

  const HanziCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // 将 title 从 Unicode 转换为对应的汉字
        title: Text(
          String.fromCharCode(int.parse(item.unicode ?? '0', radix: 16)),
        ),
        subtitle: Text('MC: ${item.mc}, PU: ${item.pu}'),
      ),
    );
  }
}
