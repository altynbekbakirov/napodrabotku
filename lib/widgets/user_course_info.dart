import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/widgets/cicle_button.dart';

class UserCourseInfo extends StatefulWidget {
  List<UserCourse> user_courses;
  UserCv userCv;

  UserCourseInfo({Key key, this.user_courses, this.userCv}) : super(key: key);

  @override
  _UserCourseInfoState createState() => _UserCourseInfoState();
}

class _UserCourseInfoState extends State<UserCourseInfo> {
  final name_controller = TextEditingController();
  final course_organization_name_controller = TextEditingController();
  final duration_controller = TextEditingController();
  final course_end_year_controller = TextEditingController();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final courseUpdateFormKey = GlobalKey<FormState>();

  openCourseDialog(context, UserCourse userCourse) {
    name_controller.text = userCourse.name.toString();
    course_organization_name_controller.text =
        userCourse.organization_name != null
            ? userCourse.organization_name.toString()
            : '';
    duration_controller.text =
        userCourse.duration != null ? userCourse.duration.toString() : '';
    course_end_year_controller.text =
        userCourse.end_year != "null" ? userCourse.end_year.toString() : '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('user_course_info'.tr().toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kColorDarkBlue)),
                      ),
                    ),

                    /// Form
                    Form(
                      key: courseUpdateFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("course_name".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: name_controller,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  validator: (name) {
                                    // Basic validation
                                    if (name.isEmpty) {
                                      return "please_fill_this_field".tr();
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("organization_name".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller:
                                      course_organization_name_controller,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  validator: (name) {
                                    // Basic validation
                                    if (name.isEmpty) {
                                      return "please_fill_this_field".tr();
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("duration".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: duration_controller,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  validator: (name) {
                                    // Basic validation
                                    if (name.isEmpty) {
                                      return "please_fill_this_field".tr();
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("end_year".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: course_end_year_controller,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  validator: (name) {
                                    // Basic validation
                                    if (name.isEmpty) {
                                      return "please_fill_this_field".tr();
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          /// Sign In button
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
                                  color: Colors.grey[200],
                                  textColor: kColorPrimary,
                                  onPressed: () {
                                    userCourse
                                        .delete(userCourse.id)
                                        .then((value) {
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(getUserCv());
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  text: 'delete'.tr(),
                                ),
                                CustomButton(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (courseUpdateFormKey.currentState
                                        .validate()) {
                                      userCourse.name = name_controller.text;
                                      userCourse.organization_name =
                                          course_organization_name_controller
                                              .text;
                                      userCourse.duration =
                                          duration_controller.text;
                                      userCourse.end_year =
                                          course_end_year_controller.text;

                                      userCourse
                                          .update(userCourse.id)
                                          .then((value) {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(getUserCv());
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  text: 'save'.tr(),
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
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (var i in widget.user_courses) {
      list.add(Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 64,
                          height: 64,
                          child: Icon(
                            Boxicons.bx_window_alt,
                            size: 32,
                            color: kColorPrimary,
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xffF2F2F5),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i.name,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: kColorDark,
                                        height: 1.4)),
                                Text(
                                    (i.organization_name != null
                                            ? i.organization_name
                                            : ' ') +
                                        ', ' +
                                        (i.duration != null ? i.duration : ' '),
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        height: 1.4)),
                                Text(i.end_year != "null" ? i.end_year : '',
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      child: CircleButton(
                        bgColor: Colors.transparent,
                        padding: 0,
                        icon: Icon(
                          Boxicons.bx_edit,
                          color: kColorDarkBlue,
                          size: 24,
                        ),
                      ),
                      onTap: () {
                        openCourseDialog(context, i);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return Container(
        child: Column(
      children: list,
    ));
  }
}
