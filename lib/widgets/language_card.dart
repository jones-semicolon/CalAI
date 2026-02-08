import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final VoidCallback onClose;

  const LanguageCard({super.key, required this.onClose});

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

  @override
  Widget build(BuildContext context) {
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
                    'Choose language',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
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
                        color: Theme.of(context).colorScheme.primary,
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
                  languages.length * 2 - 1, // include gaps
                  (index) {
                    if (index.isEven) {
                      final lang = languages[index ~/ 2];
                      return LanguageItem(
                        flag: lang['flag']!,
                        language: lang['name']!,
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

  const LanguageItem({super.key, required this.flag, required this.language});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // TODO: handle language selection
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onTertiary,
            border: Border.all(
              color: Theme.of(context).splashColor,
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
