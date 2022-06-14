import 'package:flutter/material.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/providers/language_provider.dart';
import 'package:provider/provider.dart';

enum LanguagesActions { english }

class SettingLanguageActions extends StatelessWidget {
  const SettingLanguageActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of(context);
    Locale _appCurrentLocale = languageProvider.appLocale;

    return PopupMenuButton<LanguagesActions>(
      icon: const Icon(Icons.language),
      onSelected: (LanguagesActions result) {
        switch (result) {
          case LanguagesActions.english:
            languageProvider.updateLanguage("en");
            break;
          // case LanguagesActions.chinese:
          //   languageProvider.updateLanguage("zh");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<LanguagesActions>>[
        PopupMenuItem<LanguagesActions>(
          value: LanguagesActions.english,
          enabled: _appCurrentLocale == const Locale("en") ? false : true,
          child: Text(AppLocalizations.of(context)
              .translate("settingPopUpToggleEnglish")),
        ),
        // PopupMenuItem<LanguagesActions>(
        //   value: LanguagesActions.chinese,
        //   enabled: _appCurrentLocale == Locale("zh") ? false : true,
        //   child: Text(AppLocalizations.of(context)
        //       .translate("settingPopUpToggleChinese")),
        // ),
      ],
    );
  }
}