import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Hanzi Dictionary'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Favorites tab label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Search field label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Hint text for search field
  ///
  /// In en, this message translates to:
  /// **'Enter characters or pronunciation to search'**
  String get searchHint;

  /// Message when favorites list is empty
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavoritesYet;

  /// Title for character details page
  ///
  /// In en, this message translates to:
  /// **'Character Details'**
  String get hanziDetails;

  /// Unicode label
  ///
  /// In en, this message translates to:
  /// **'Unicode'**
  String get unicode;

  /// Theme mode setting label
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Language settings section title
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Follow system language option
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get followSystem;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Middle Chinese language label
  ///
  /// In en, this message translates to:
  /// **'Middle Chinese'**
  String get middleChinese;

  /// Mandarin Chinese language label
  ///
  /// In en, this message translates to:
  /// **'Mandarin'**
  String get mandarin;

  /// Cantonese language label
  ///
  /// In en, this message translates to:
  /// **'Cantonese'**
  String get cantonese;

  /// Shanghainese language label
  ///
  /// In en, this message translates to:
  /// **'Shanghainese'**
  String get shanghainese;

  /// Min Nan language label
  ///
  /// In en, this message translates to:
  /// **'Min Nan'**
  String get minnan;

  /// Korean language label
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// Vietnamese language label
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// Japanese Go-on reading label
  ///
  /// In en, this message translates to:
  /// **'Japanese Go-on'**
  String get japaneseGo;

  /// Japanese Kan-on reading label
  ///
  /// In en, this message translates to:
  /// **'Japanese Kan-on'**
  String get japaneseKan;

  /// Japanese Tō-on reading label
  ///
  /// In en, this message translates to:
  /// **'Japanese Tō-on'**
  String get japaneseTou;

  /// Japanese Kwan-on reading label
  ///
  /// In en, this message translates to:
  /// **'Japanese Kwan-on'**
  String get japaneseKwan;

  /// Japanese other reading label
  ///
  /// In en, this message translates to:
  /// **'Japanese Other'**
  String get japaneseOther;

  /// Tooltip for pronunciation button
  ///
  /// In en, this message translates to:
  /// **'Play Pronunciation'**
  String get playPronunciation;

  /// Message for upcoming pronunciation feature
  ///
  /// In en, this message translates to:
  /// **'Pronunciation feature coming soon'**
  String get pronunciationComingSoon;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Storage settings section title
  ///
  /// In en, this message translates to:
  /// **'Storage Settings'**
  String get storageSettings;

  /// Export favorites button text
  ///
  /// In en, this message translates to:
  /// **'Export Favorites'**
  String get exportFavorites;

  /// Import favorites button text
  ///
  /// In en, this message translates to:
  /// **'Import Favorites'**
  String get importFavorites;

  /// Select storage location button text
  ///
  /// In en, this message translates to:
  /// **'Select Storage Location'**
  String get selectStorageLocation;

  /// Current storage location label
  ///
  /// In en, this message translates to:
  /// **'Current Storage Location'**
  String get currentStorageLocation;

  /// Default storage location label
  ///
  /// In en, this message translates to:
  /// **'Default Location'**
  String get defaultLocation;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Favorites exported successfully'**
  String get exportSuccess;

  /// Import success message
  ///
  /// In en, this message translates to:
  /// **'Favorites imported successfully'**
  String get importSuccess;

  /// Export error message
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportError;

  /// Import error message
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importError;

  /// Select file dialog title
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// Count of favorites
  ///
  /// In en, this message translates to:
  /// **'{count} favorites'**
  String favoritesCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
