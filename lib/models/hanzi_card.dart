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
            // 右侧内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 第一行单独显示 MC
                  _buildAttributeRow('assets/drawable/lang_mc.png', item.mc),
                  const SizedBox(height: 8.0),
                  // 剩余属性分为两列
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 左列
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAttributeRow(
                              'assets/drawable/lang_pu.png',
                              item.pu,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_ct.png',
                              item.ct,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_sh.png',
                              item.sh,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_mn.png',
                              item.mn,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_kr.png',
                              item.kr,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_vn.png',
                              item.vn,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // 右列
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAttributeRow(
                              'assets/drawable/lang_jp_go.png',
                              item.jpGo,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_jp_kan.png',
                              item.jpKan,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_jp_tou.png',
                              item.jpTou,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_jp_kwan.png',
                              item.jpKwan,
                            ),
                            _buildAttributeRow(
                              'assets/drawable/lang_jp_other.png',
                              item.jpOther,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String imagePath, String? value) {
    return Row(
      children: [
        Image.asset(imagePath, width: 24.0, height: 24.0),
        const SizedBox(width: 8.0),
        Text(value ?? "N/A"),
      ],
    );
  }
}
