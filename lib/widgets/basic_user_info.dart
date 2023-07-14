import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/utils/constants.dart';

class BasicUserCvInfo extends StatelessWidget {
  UserCv user_cv;
  Users user;
  Directory _downloadsDirectory;

  BasicUserCvInfo({this.user_cv, this.user});

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  Prefs.getString(Prefs.USER_TYPE) == "USER"
                      ? "name".tr()
                      : "company_name".tr(),
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
              Flexible(
                child: Text(user.surname != null ? '${user.name} ${user.surname}' : user.name,
                    softWrap: true,
                    style: TextStyle(fontSize: 16, color: kColorDark)),
              ),
            ],
          ),
          Divider(),
          Prefs.getString(Prefs.USER_TYPE) == "USER"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("birth_date".tr(),
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey, height: 2)),
                    Text(formatter.format(user.birth_date),
                        softWrap: true,
                        style: TextStyle(fontSize: 16, color: kColorDark)),
                  ],
                )
              : Container(),
          Prefs.getString(Prefs.USER_TYPE) == "USER" ? Divider() : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("email".tr(),
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
              Text(user.email != null ? user.email : '-',
                  softWrap: true,
                  style: TextStyle(fontSize: 16, color: kColorDark)),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("phone_number".tr(),
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
              Text(user?.phone_number,
                  softWrap: true,
                  style: TextStyle(fontSize: 16, color: kColorDark)),
            ],
          ),
          Divider(),
          user_cv != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("job_title".tr(),
                    //         softWrap: true,
                    //         style: TextStyle(
                    //             fontSize: 16, color: Colors.grey, height: 2)),
                    //     SizedBox(
                    //       width: 5,
                    //     ),
                    //     Flexible(
                    //       child: Text(
                    //           (user_cv.job_title == null ||
                    //                   user_cv.job_title == '')
                    //               ? '-'
                    //               : user_cv.job_title.toString(),
                    //           softWrap: true,
                    //           style:
                    //               TextStyle(fontSize: 16, color: kColorDark)),
                    //     ),
                    //   ],
                    // ),
                    // Divider(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("experience_year".tr(),
                    //         softWrap: true,
                    //         style: TextStyle(
                    //             fontSize: 16, color: Colors.grey, height: 2)),
                    //     Text(
                    //         user_cv.experience_year == null
                    //             ? '-'
                    //             : user_cv.experience_year.toString(),
                    //         softWrap: true,
                    //         style: TextStyle(fontSize: 16, color: kColorDark)),
                    //   ],
                    // ),
                    // Divider(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("linkedin_profile".tr(),
                    //         softWrap: true,
                    //         style: TextStyle(
                    //             fontSize: 16, color: Colors.grey, height: 2)),
                    //     Text(
                    //         user.linkedin == null
                    //             ? '-'
                    //             : user.linkedin.toString(),
                    //         softWrap: true,
                    //         style: TextStyle(fontSize: 16, color: kColorDark)),
                    //   ],
                    // ),
                    // Divider(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("are_you_migrant".tr(),
                    //         softWrap: true,
                    //         style: TextStyle(
                    //             fontSize: 16, color: Colors.grey, height: 2)),
                    //     Text(
                    //         user.is_migrant == 0
                    //             ? 'no'.tr()
                    //             : 'yes'.tr(),
                    //         softWrap: true,
                    //         style: TextStyle(fontSize: 16, color: kColorDark)),
                    //   ],
                    // ),
                    // Divider(),
                    // user_cv.attachment == null
                    //     ? Container()
                    //     : Container(
                    //         margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                    //         child: Text('attachment'.tr().toUpperCase(),
                    //             style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w700,
                    //                 color: kColorDarkBlue)),
                    //       ),
                    // user_cv.attachment == null ? Container() :
                    // CustomButton(
                    //   text: user_cv.attachment != null
                    //       ? 'download_file'.tr()
                    //       : 'file_doesnt_exist'.tr(),
                    //   width: MediaQuery.of(context).size.width * 1,
                    //   color: Colors.grey[200],
                    //   textColor: kColorPrimary,
                    //   onPressed: () {
                    //     _launchURL(SERVER_IP + user_cv.attachment);
                    //   }
                    // ),
                  ],
                )
              : SizedBox(),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Text("attachment".tr(),softWrap: true,
//                  style: TextStyle(fontSize: 20, color: Colors.grey)),
//              Text(user_cv.experience_year.toString(),softWrap: true,
//                  style: TextStyle(fontSize: 22,)),
//            ],
//          ),
//          Divider(),
        ],
      ),
    );
  }
}
