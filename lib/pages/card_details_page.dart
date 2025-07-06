import 'package:flutter/material.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:provider/provider.dart';
import '../models/mcp_dict.dart';
import '../models/favorites_provider.dart';
import '../l10n/app_localizations.dart';

class CardDetailsPage extends StatelessWidget {
  final McpDict item;
  final KanaKit _kanaKit = KanaKit();

  CardDetailsPage({required this.item, super.key});

  String _convertToKana(String? text) {
    if (text == null || text == "N/A") {
      return text ?? "N/A";
    }
    return _kanaKit.toKana(text);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(item);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.hanziDetails),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFavorite(item);
              } else {
                favoritesProvider.addFavorite(item);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部汉字和Unicode信息
            Row(
              children: [
                // 左侧大字号汉字
                SelectableText(
                  String.fromCharCode(
                    int.parse(item.unicode ?? '0', radix: 16),
                  ),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 32),
                // 右侧Unicode信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unicode',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'U+${item.unicode?.toUpperCase() ?? "N/A"}',
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.grey,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // 分隔线
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            // 语言信息列表
            _buildLanguageSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final languageItems = [
      {
        'icon': 'assets/drawable/lang_mc.png',
        'label': '中古汉语',
        'value': item.mc,
      },
      {'icon': 'assets/drawable/lang_pu.png', 'label': '普通话', 'value': item.pu},
      {'icon': 'assets/drawable/lang_ct.png', 'label': '粤语', 'value': item.ct},
      {'icon': 'assets/drawable/lang_sh.png', 'label': '上海话', 'value': item.sh},
      {'icon': 'assets/drawable/lang_mn.png', 'label': '闽南话', 'value': item.mn},
      {'icon': 'assets/drawable/lang_kr.png', 'label': '朝鲜语', 'value': item.kr},
      {'icon': 'assets/drawable/lang_vn.png', 'label': '越南语', 'value': item.vn},
      {
        'icon': 'assets/drawable/lang_jp_go.png',
        'label': '日语呉音',
        'value': _convertToKana(item.jpGo),
      },
      {
        'icon': 'assets/drawable/lang_jp_kan.png',
        'label': '日语漢音',
        'value': _convertToKana(item.jpKan),
      },
      {
        'icon': 'assets/drawable/lang_jp_tou.png',
        'label': '日语唐音',
        'value': _convertToKana(item.jpTou),
      },
      {
        'icon': 'assets/drawable/lang_jp_kwan.png',
        'label': '日语慣用音',
        'value': _convertToKana(item.jpKwan),
      },
      {
        'icon': 'assets/drawable/lang_jp_other.png',
        'label': '日语其他',
        'value': _convertToKana(item.jpOther),
      },
    ];

    return Column(
      children:
          languageItems
              .where((item) => item['value'] != null && item['value'] != "N/A")
              .map(
                (item) => _buildLanguageItem(
                  context,
                  item['icon'] as String,
                  item['label'] as String,
                  item['value'] as String,
                ),
              )
              .toList(),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    String iconPath,
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.0),
      ),
      child: Row(
        children: [
          // 语言图标
          Image.asset(iconPath, width: 32.0, height: 32.0),
          const SizedBox(width: 16.0),
          // 语言标签
          SizedBox(
            width: 80.0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          const SizedBox(width: 16.0), // 语言值
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontFamily: 'LXGWWenKai',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                ),
                children: _parseValue(value),
              ),
            ),
          ),
          // 发音按钮
          IconButton(
            icon: const Icon(Icons.volume_up),
            iconSize: 20.0,
            tooltip: '播放发音',
            onPressed: () {
              // TODO: 实现发音功能
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('发音功能即将推出'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseValue(String value) {
    final regex = RegExp(r'(\*[^*]+\*|\|[^|]+\|)');
    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in regex.allMatches(value)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: value.substring(currentIndex, match.start),
            style: const TextStyle(decoration: TextDecoration.none),
          ),
        );
      }

      final matchedText = match.group(0)!;
      if (matchedText.startsWith('*') && matchedText.endsWith('*')) {
        spans.add(
          TextSpan(
            text: matchedText.substring(1, matchedText.length - 1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        );
      } else if (matchedText.startsWith('|') && matchedText.endsWith('|')) {
        spans.add(
          TextSpan(
            text: matchedText.substring(1, matchedText.length - 1),
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.none,
            ),
          ),
        );
      }

      currentIndex = match.end;
    }

    if (currentIndex < value.length) {
      spans.add(
        TextSpan(
          text: value.substring(currentIndex),
          style: const TextStyle(decoration: TextDecoration.none),
        ),
      );
    }

    return spans;
  }
}
