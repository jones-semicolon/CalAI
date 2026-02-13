import 'package:calai/l10n/app_localizations.dart';
import 'package:calai/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCard extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<String>? onLanguageChanged;

  const LanguageCard({
    super.key,
    required this.onClose,
    this.onLanguageChanged,
  });

  static const String languageStorageKey = 'language_code';

  // Static list of languages
  static const List<Map<String, String>> languages = [
    {'flag': '🇺🇸', 'name': 'English'},
    {'flag': '🇪🇸', 'name': 'Español'},
    {'flag': '🇵🇹', 'name': 'Português'},
    {'flag': '🇫🇷', 'name': 'Français'},
    {'flag': '🇩🇪', 'name': 'Deutsch'},
    {'flag': '🇮🇹', 'name': 'Italiano'},
    {'flag': '🇮🇳', 'name': 'Hindi'},
  ];

  static const List<String> languageCodes = [
    'us',
    'es',
    'pt',
    'fr',
    'de',
    'it',
    'hi',
  ];

  static const Map<String, String> languageLabels = {
    'us': 'EN',
    'es': 'ES',
    'pt': 'PT',
    'fr': 'FR',
    'de': 'DE',
    'it': 'IT',
    'hi': 'HI',
  };

  static String labelForCode(String code) =>
      languageLabels[code] ?? code.toUpperCase();

  static String flagForCode(String code) {
    final index = languageCodes.indexOf(code);
    if (index < 0) {
      return languages.first['flag'] ?? '';
    }
    return languages[index]['flag'] ?? '';
  }

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  String _selectedLanguageCode = 'us';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(LanguageCard.languageStorageKey);
    final selected = saved ?? 'us';
    final normalized = LanguageCard.languageCodes.contains(selected)
        ? selected
        : 'us';
    if (saved == null || normalized != selected) {
      await prefs.setString(LanguageCard.languageStorageKey, normalized);
    }
    if (!mounted) return;
    setState(() => _selectedLanguageCode = normalized);
  }

  Future<void> _selectLanguage(String code) async {
    if (_selectedLanguageCode == code) return;
    setState(() => _selectedLanguageCode = code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LanguageCard.languageStorageKey, code);
    MyApp.of(context)?.setLocale(MyApp.localeFromCode(code));
    widget.onLanguageChanged?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink to content
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.chooseLanguage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // LANGUAGE LIST
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  LanguageCard.languages.length * 2 - 1, // include gaps
                  (index) {
                    if (index.isEven) {
                      final langIndex = index ~/ 2;
                      final lang = LanguageCard.languages[langIndex];
                      final code = LanguageCard.languageCodes[langIndex];
                      return LanguageItem(
                        flag: lang['flag']!,
                        language: lang['name']!,
                        isSelected: _selectedLanguageCode == code,
                        onTap: () => _selectLanguage(code),
                      );
                    } else {
                      return const SizedBox(height: 10); // gap
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  final String flag;
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageItem({
    super.key,
    required this.flag,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).dialogTheme.surfaceTintColor,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(flag, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 12),
              Text(
                language,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
