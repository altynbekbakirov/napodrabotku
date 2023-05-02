import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ishtapp/datas/pref_manager.dart';

enum Language { russian, kyrgyz }

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  var _language;
  @override
  void initState() {
    super.initState();
    switch (Prefs.getString('language', def: null)) {
      case 'ky':
        _language = Language.kyrgyz;
        break;

      case 'ru':
        _language = Language.russian;
        break;

      default:
        break;
    }
  }

  _changeLanguage(int index) {
    switch (index) {
      case 0:
        _language = Language.kyrgyz;
        Prefs.setString(Prefs.LANGUAGE, 'ky');
        break;

      case 1:
        _language = Language.russian;
        Prefs.setString(Prefs.LANGUAGE, 'ru');
        break;
    }
    EasyLocalization.of(context).locale =
        EasyLocalization.of(context).supportedLocales[index];

    print("language" + _language.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'language_settings'.tr(),
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RadioListTile(
              value: Language.kyrgyz,
              onChanged: (value) => _changeLanguage(0),
              groupValue: _language,
              title: Text('kyrgyz'.tr()),
            ),
            Divider(
              height: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            RadioListTile(
              value: Language.russian,
              onChanged: (value) => _changeLanguage(1),
              groupValue: _language,
              title: Text('russian'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
