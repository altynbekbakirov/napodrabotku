import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/app_themes.dart';
import 'package:ishtapp/utils/themebloc/theme_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => {_loadScreen()});
  }

  _loadScreen() async {
    await Prefs.load();
    context.bloc<ThemeBloc>().add(ThemeChanged(
        theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
            ? AppTheme.DarkTheme
            : AppTheme.LightTheme));

    if (Prefs.getString('language') == null)
      Navigator.of(context).pushReplacementNamed(Routes.chooseLanguage);
    else if (Prefs.getString(Prefs.TOKEN) != null) {
      Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
        ? Navigator.of(context).pushReplacementNamed(Routes.product_lab_home)
        : Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.select_mode);
    }
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(context, msg: 'click_once_to_exit'.tr());
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: Container(
            width: double.infinity,
            color: Theme.of(context).splashColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Text(
                          //   'ishtapp',
                          //   style: TextStyle(
                          //       fontSize: 40,
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w700,
                          //       fontStyle: FontStyle.italic),
                          // ),
                          Align(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Image.asset(
                                'assets/images/logo_white.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onWillPop: onWillPop),
    );
  }
}
