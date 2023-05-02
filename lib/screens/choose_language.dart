import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/constants.dart';

class ChooseLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBlue,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 60,
                        ),
                      ),
                      Align(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Image.asset(
                            'assets/images/logo_white.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Выберите язык приложения',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomButton(
                              height: 50.0,
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              textColor: kColorBlue,
                              onPressed: () {
                                Prefs.setString(Prefs.LANGUAGE, 'ky');
                                EasyLocalization.of(context).locale =
                                    EasyLocalization.of(context)
                                        .supportedLocales[0];
                                Navigator.of(context)
                                    .popAndPushNamed(Routes.select_mode);
                              },
                              text: 'Кыргыз тили',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              height: 50.0,
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              textColor: kColorBlue,
                              onPressed: () {
                                Prefs.setString(Prefs.LANGUAGE, 'ru');
                                EasyLocalization.of(context).locale =
                                    EasyLocalization.of(context)
                                        .supportedLocales[1];
                                Navigator.of(context)
                                    .popAndPushNamed(Routes.select_mode);
                              },
                              text: 'Русский язык',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
