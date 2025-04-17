# hanzi_dict

一个使用 Flutter+AI 制作的汉字字典应用，数据集来源于知乎[王赟大佬](https://www.zhihu.com/people/maigo)的漢字古今中外讀音查詢。

## 功能概述

- **汉字搜索**：支持搜索汉字、中古汉语、普通话等，提供详细的属性信息。

## 目前功能

- **界面优化**：
  - 添加了设置界面，支持深色模式切换。
  - 提供底部导航栏和左侧导航栏，支持响应式布局。
- **显示效果**：
  - 卡片布局优化，左侧以大字号显示汉字，右侧显示属性。
  - 支持日语文本中罗马字到假名的转换。
- **主题与字体**：
  - 应用主题更改为 Catppuccin。
  - 使用了 LXGW 字体系列。
- **收藏功能**：
  - 提供收藏界面和收藏按钮，支持收藏逻辑。

## 安装与运行

1. 确保已安装 Flutter 开发环境。
2. 克隆此项目：
   ```bash
   git clone <repository-url>
   ```
3. 安装依赖：
   ```bash
   flutter pub get
   ```
4. 运行项目：
   ```bash
   flutter run
   ```

## 文件结构

- `lib/`：主要的 Dart 源代码，包括：
  - `main.dart`：应用入口。
  - `database_helper.dart`：数据库操作。
  - `favorites_page.dart`：收藏页面。
  - `settings_page.dart`：设置页面。
  - `theme.dart`：主题相关代码。
- `assets/`：资源文件，包括图标、字体等。
- `test/`：测试代码。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进此项目。

## 许可证

此项目使用 MIT 许可证。

## 第三方许可证
- [MCPDict] 的许可证见 [LICENSE/LICENSE](./LICENSES/LICENSE)。