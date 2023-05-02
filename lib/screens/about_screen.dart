import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'about_app'.tr(),
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Prefs.getString(Prefs.ROUTE) != 'PRODUCT_LAB'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'about_app'.tr(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kColorPrimary),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'ishtapp - ' + 'about_paragraph_1'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_2'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- ' + 'partner_1'.tr(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                          ),
                          Text(
                            '- ' + 'partner_2'.tr(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                          ),
                          Text(
                            '- ' + 'partner_3'.tr(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_3'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  height: 70,
                                  child: Image.asset('assets/images/partners/japan.png'),
                                ),
                              ),
                              Container(
                                child: SizedBox(
                                  height: 70,
                                  child: Image.asset('assets/images/partners/giz.gif'),
                                ),
                              ),
                              Container(
                                child: SizedBox(
                                  height: 70,
                                  child: Image.asset('assets/images/partners/undp.png'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'about_app'.tr(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kColorPrimary),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'ishtapp - ' + 'about_paragraph_PL-1'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'about_paragraph_PL-Commercial'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'about_paragraph_PL-Digital'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'about_paragraph_PL-Social'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_PL-Ecological'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_PL-2'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_PL-Earn'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_PL-3'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'about_paragraph_PL-4'.tr(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: kColorDark),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 20,
                                  child: Image.asset('assets/images/partners/techaim.png'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 60,
                                  child: Image.asset('assets/images/partners/htpkr.png'),
                                ),
                              ),
                              Container(
                                child: SizedBox(
                                  height: 50,
                                  child: Image.asset('assets/images/partners/unicef.png'),
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
      ),
    );
  }
}
