import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ishtapp/constants/constants.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/screens/home_screen.dart';
import 'package:ishtapp/screens/sign_up_screen.dart';

// import 'package:ishtapp/widgets/app_logo.dart';
import 'package:ishtapp/widgets/cicle_button.dart';
import 'package:ishtapp/widgets/default_button.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:ishtapp/utils/some_painter.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/pref_manager.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  DateTime currentBackPressTime;
  String mode;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(context, msg: 'click_once_to_exit'.tr());
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    mode = Prefs.getString(Prefs.ROUTE);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: kColorDark,
              image: DecorationImage(
                  image: AssetImage("assets/images/main_bg.jpg"),
                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.28), BlendMode.modulate,),
                  fit: BoxFit.cover
              )
          ),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo_white.png',
                        fit: BoxFit.cover,
                        height: 64.0,
                      ),
                    ],
                  ),
                ),
              ),

              /// Sign in with Phone Number
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: CustomButton(
                                color: kColorWhite,
                                textColor: kColorPrimary,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Routes.signup);
                                },
                                text: 'sign_up'.tr(),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: CustomButton(
                                color: kColorPrimary,
                                textColor: kColorWhite,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Routes.signin);
                                },
                                text: 'sign_in'.tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
