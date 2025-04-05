import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

import 'models/mcp_dict.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initDatabase() async {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

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

  Future<List<McpDict>> search(String query) async {
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

    return maps.map((map) => McpDict.fromJson(map)).toList();
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }
}
