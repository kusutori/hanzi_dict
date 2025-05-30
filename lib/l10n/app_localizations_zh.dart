// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '汉字字典';

  @override
  String get home => '首页';

  @override
  String get favorites => '收藏';

  @override
  String get settings => '设置';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '输入汉字或读音进行搜索';

  @override
  String get noFavoritesYet => '暂无收藏。';

  @override
  String get hanziDetails => '汉字详情';

  @override
  String get unicode => 'Unicode编码';

  @override
  String get themeMode => '主题模式';

  @override
  String get systemDefault => '跟随系统';

  @override
  String get lightMode => '浅色模式';

  @override
  String get darkMode => '深色模式';

  @override
  String get languageSettings => '语言设置';

  @override
  String get followSystem => '跟随系统';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get middleChinese => '中古汉语';

  @override
  String get mandarin => '普通话';

  @override
  String get cantonese => '粤语';

  @override
  String get shanghainese => '上海话';

  @override
  String get minnan => '闽南话';

  @override
  String get korean => '朝鲜语';

  @override
  String get vietnamese => '越南语';

  @override
  String get japaneseGo => '日语呉音';

  @override
  String get japaneseKan => '日语漢音';

  @override
  String get japaneseTou => '日语唐音';

  @override
  String get japaneseKwan => '日语慣用音';

  @override
  String get japaneseOther => '日语其他';

  @override
  String get playPronunciation => '播放发音';

  @override
  String get pronunciationComingSoon => '发音功能即将推出';

  @override
  String get language => '语言';

  @override
  String get storageSettings => '存储设置';

  @override
  String get exportFavorites => '导出收藏';

  @override
  String get importFavorites => '导入收藏';

  @override
  String get selectStorageLocation => '选择存储位置';

  @override
  String get currentStorageLocation => '当前存储位置';

  @override
  String get defaultLocation => '默认位置';

  @override
  String get exportSuccess => '收藏导出成功';

  @override
  String get importSuccess => '收藏导入成功';

  @override
  String get exportError => '导出失败';

  @override
  String get importError => '导入失败';

  @override
  String get selectFile => '选择文件';

  @override
  String favoritesCount(int count) {
    return '$count 个收藏';
  }
}
