import 'package:flutter/material.dart';
import 'mcp_dict.dart';

class HanziCard extends StatelessWidget {
  final McpDict item;

  const HanziCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.unicode ?? 'Unknown',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Middle Chinese: ${item.mc}'),
            Text('Pinyin: ${item.pu}'),
            Text('Cantonese: ${item.ct}'),
            Text('Shanghainese: ${item.sh}'),
            Text('Minnan: ${item.mn}'),
            Text('Korean: ${item.kr}'),
            Text('Vietnamese: ${item.vn}'),
            Text('Japanese Go-on: ${item.jpGo}'),
            Text('Japanese Kan-on: ${item.jpKan}'),
            Text('Japanese Tou-on: ${item.jpTou}'),
            Text('Japanese Kwan-on: ${item.jpKwan}'),
            Text('Japanese Other: ${item.jpOther}'),
          ],
        ),
      ),
    );
  }
}
