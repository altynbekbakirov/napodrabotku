import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/widgets/cicle_button.dart';

class UserEducationInfo extends StatefulWidget {
  List<UserEducation> user_educations;
  UserCv userCv;

  UserEducationInfo({Key key, this.user_educations, this.userCv})
      : super(key: key);

  @override
  _UserEducationInfoState createState() => _UserEducationInfoState();
}

class _UserEducationInfoState extends State<UserEducationInfo> {
  final title_controller = TextEditingController();
  final faculty_controller = TextEditingController();
  final speciality_controller = TextEditingController();
  final type_controller = TextEditingController();
  final end_year_controller = TextEditingController();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final educationUpdateFormKey = GlobalKey<FormState>();

  openEducationDialog(context, UserEducation userEducation) {
    title_controller.text =
        userEducation.title != null ? userEducation.title.toString() : '';
    faculty_controller.text =
        userEducation.faculty != null ? userEducation.faculty.toString() : '';
    speciality_controller.text = userEducation.speciality != null
        ? userEducation.speciality.toString()
        : '';
    type_controller.text =
        userEducation.type != null ? userEducation.type.toString() : '';
    end_year_controller.text = userEducation.end_year != "null"
        ? userEducation.end_year.toString()
        : '';

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
                        child: Text('user_education_info'.tr().toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kColorDarkBlue)),
                      ),
                    ),

                    /// Form
                    Form(
                      key: educationUpdateFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("university".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: title_controller,
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
                                  child: Text("faculty".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: faculty_controller,
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
                                  child: Text("speciality".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: speciality_controller,
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

                          // Container(
                          //   margin: EdgeInsets.only(bottom: 5),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //         child: Text("type".tr(),
                          //             softWrap: true,
                          //             style: TextStyle(
                          //                 fontSize: 16,
                          //                 color: Colors.grey,
                          //                 height: 2)),
                          //       ),
                          //       TextFormField(
                          //         controller: type_controller,
                          //         decoration: InputDecoration(
                          //           contentPadding:
                          //               EdgeInsets.fromLTRB(15, 5, 15, 5),
                          //           border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //               borderSide: BorderSide.none),
                          //           floatingLabelBehavior:
                          //               FloatingLabelBehavior.always,
                          //           filled: true,
                          //           fillColor: Colors.grey[200],
                          //         ),
                          //         validator: (name) {
                          //           // Basic validation
                          //           if (name.isEmpty) {
                          //             return "please_fill_this_field".tr();
                          //           }
                          //           return null;
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),

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
                                  controller: end_year_controller,
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
                                    userEducation
                                        .delete(userEducation.id)
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
                                    if (educationUpdateFormKey.currentState
                                        .validate()) {
                                      userEducation.title =
                                          title_controller.text;
                                      userEducation.faculty =
                                          faculty_controller.text;
                                      userEducation.speciality =
                                          speciality_controller.text;
                                      userEducation.type = type_controller.text;
                                      userEducation.end_year =
                                          end_year_controller.text;

                                      userEducation
                                          .update(userEducation.id)
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
    for (var i in StoreProvider.of<AppState>(context)
        .state
        .user
        .user_cv
        .data
        .user_educations) {
      list.add(Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Boxicons.bx_book,
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
                                Text(i.title,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: kColorDark,
                                        height: 1.4)),
                                Text(
                                    i.faculty != null ? i.faculty : '' + ', ' + i.speciality != null  ? i.speciality  : '',
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
                    margin: EdgeInsets.only(left: 15),
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
                        openEducationDialog(context, i);
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
