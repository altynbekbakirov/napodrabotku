import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtapp/datas/pref_manager.dart';

class SelectMode extends StatefulWidget {
  const SelectMode({Key key}) : super(key: key);

  @override
  _SelectModeState createState() => _SelectModeState();
}

class _SelectModeState extends State<SelectMode> {
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
      backgroundColor: kColorBlue,
      body: WillPopScope(
        child: LayoutBuilder(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(height: 60),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "select_mode".tr(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomButton(
                                color: kColorWhite,
                                textColor: kColorPrimary,
                                textAlign: TextAlign.center,
                                onPressed: () {
                                  Prefs.setString(Prefs.ROUTE, "USER");
                                  Navigator.of(context).pushNamed(Routes.start);
                                },
                                text: 'looking_for_a_job'.tr(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                color: kColorWhite,
                                textColor: kColorPrimary,
                                onPressed: () {
                                  Prefs.setString(Prefs.ROUTE, "COMPANY");
                                  Navigator.of(context).pushNamed(Routes.start);
                                },
                                text: 'company_login'.tr(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        onWillPop: onWillPop,
      ),
    );
  }
}
