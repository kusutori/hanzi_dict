import 'package:flutter/material.dart';
import 'mcp_dict.dart';

class HanziCard extends StatelessWidget {
  final McpDict item;

  const HanziCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧显示汉字，使用更大的字体
            Text(
              String.fromCharCode(int.parse(item.unicode ?? '0', radix: 16)),
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            // 右侧显示所有属性
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MC: ${item.mc ?? "N/A"}'),
                  Text('PU: ${item.pu ?? "N/A"}'),
                  Text('CT: ${item.ct ?? "N/A"}'),
                  Text('SH: ${item.sh ?? "N/A"}'),
                  Text('MN: ${item.mn ?? "N/A"}'),
                  Text('KR: ${item.kr ?? "N/A"}'),
                  Text('VN: ${item.vn ?? "N/A"}'),
                  Text('JP Go: ${item.jpGo ?? "N/A"}'),
                  Text('JP Kan: ${item.jpKan ?? "N/A"}'),
                  Text('JP Tou: ${item.jpTou ?? "N/A"}'),
                  Text('JP Kwan: ${item.jpKwan ?? "N/A"}'),
                  Text('JP Other: ${item.jpOther ?? "N/A"}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
