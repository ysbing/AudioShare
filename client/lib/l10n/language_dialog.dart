import 'package:flutter/material.dart';

import '../utils/size.dart';
import 'generated/app_localizations.dart';
import 'supported_languages.dart';

/// Lets the user pick the language the app is displayed in.
///
/// The first entry follows the device language instead of pinning a specific
/// one. The rest can be filtered by either the language's own name or its
/// English name, so searching for "Japanese" also turns up 日本語.
class LanguageDialog extends StatefulWidget {
  const LanguageDialog({
    super.key,
    required this.currentId,
    required this.deviceLanguage,
  });

  /// The id of the entry that is currently selected: a language id, or
  /// [followSystemLanguageId].
  final String currentId;

  /// The language the device reports, shown next to the follow-system entry
  /// so it is clear what that option resolves to.
  final AppLanguage deviceLanguage;

  /// Shows the dialog and returns the id of the entry the user picked, or
  /// null when the dialog was dismissed.
  static Future<String?> show(
    BuildContext context, {
    required String currentId,
    required AppLanguage deviceLanguage,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) =>
          LanguageDialog(currentId: currentId, deviceLanguage: deviceLanguage),
    );
  }

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

/// One row in the language list.
class _LanguageOption {
  const _LanguageOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.searchTerms,
  });

  final String id;
  final String name;
  final String? subtitle;

  /// Everything the search should match, lowercased.
  final List<String> searchTerms;

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return searchTerms.any((term) => term.contains(normalized));
  }
}

class _LanguageDialogState extends State<LanguageDialog> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_LanguageOption> _options(AppLocalizations l10n) {
    return [
      _LanguageOption(
        id: followSystemLanguageId,
        name: l10n.followSystem,
        subtitle: widget.deviceLanguage.name,
        searchTerms: [
          l10n.followSystem.toLowerCase(),
          'follow system',
          'system',
        ],
      ),
      for (final language in supportedLanguages)
        _LanguageOption(
          id: language.id,
          name: language.name,
          subtitle:
              language.englishName == language.name ? null : language.englishName,
          searchTerms: language.searchTerms,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final matches = _options(l10n)
        .where((option) => option.matches(_query))
        .toList(growable: false);
    return AlertDialog(
      title: Text(l10n.language),
      content: SizedBox(
        width: (designSize.width - 80).w,
        height: (designSize.height * 0.5).h,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: matches.isEmpty
                  ? Center(child: Text(l10n.noLanguageMatch))
                  : ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final option = matches[index];
                        final selected = option.id == widget.currentId;
                        return ListTile(
                          dense: true,
                          selected: selected,
                          title: Text(option.name),
                          subtitle:
                              option.subtitle == null ? null : Text(option.subtitle!),
                          trailing: selected ? const Icon(Icons.check) : null,
                          onTap: () => Navigator.of(context).pop(option.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}
