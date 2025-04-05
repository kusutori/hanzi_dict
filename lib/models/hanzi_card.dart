import 'package:flutter/material.dart';
// import 'models/hanzi_card.dart';
import 'mcp_dict.dart';

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
