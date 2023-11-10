import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:path/path.dart';

import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/demo_users.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/routes/routes.dart';

import 'package:ishtapp/widgets/basic_user_info.dart';
import 'package:ishtapp/widgets/user_course_info.dart';
import 'package:ishtapp/widgets/user_education_info.dart';
import 'package:ishtapp/widgets/user_experience_info.dart';
import 'package:ishtapp/widgets/cicle_button.dart';

import 'package:ishtapp/components/custom_button.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_screen.dart';

enum Recruited {
  pending,
  accepted,
  rejected
}

class ProfileInfoScreen extends StatefulWidget {
  final int user_id;
  final int recruited;
  final int userVacancyId;

  const ProfileInfoScreen({Key key, this.user_id, this.recruited, this.userVacancyId});

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  void handleInitialBuild(ProfileFullInfoScreenProps props) {
    props.getUserFullInfo(widget.user_id);
  }

  TextEditingController job_title_controller = TextEditingController();
  TextEditingController start_date_controller = TextEditingController();
  TextEditingController end_date_controller = TextEditingController();
  TextEditingController organization_name_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  TextEditingController title_controller = TextEditingController();
  TextEditingController faculty_controller = TextEditingController();
  TextEditingController speciality_controller = TextEditingController();
  TextEditingController type_controller = TextEditingController();
  TextEditingController end_year_controller = TextEditingController();

  TextEditingController name_controller = TextEditingController();
  TextEditingController course_organization_name_controller = TextEditingController();
  TextEditingController duration_controller = TextEditingController();
  TextEditingController course_end_year_controller = TextEditingController();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  UserExperience userExperience = new UserExperience();
  UserEducation userEducation = new UserEducation();
  UserCourse userCourse = new UserCourse();

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openEducationDialog(context, UserEducation userEducation) {
    title_controller.text = userEducation.title.toString();
    faculty_controller.text = userEducation.faculty.toString();
    speciality_controller.text = userEducation.speciality.toString();
    type_controller.text = userEducation.type.toString();
    end_year_controller.text = userEducation.end_year.toString();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
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
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                      ),
                    ),

                    /// Form
                    Form(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("university".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  controller: title_controller,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: faculty_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: speciality_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          //         enabled: false,
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: end_year_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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

  openExperienceDialog(context, UserExperience userExperience) {
    job_title_controller.text = userExperience.job_title.toString();
    start_date_controller.text = userExperience.start_date;
    end_date_controller.text = userExperience.end_date;
    organization_name_controller.text = userExperience.organization_name.toString();
    description_controller.text = userExperience.description.toString();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('user_experience_info'.tr().toUpperCase(),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                      ),
                    ),

                    /// Form
                    Form(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("position".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: this.job_title_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                  child: Text("start_date".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                Container(
                                  child: CustomButton(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      width: MediaQuery.of(context).size.width * 1,
                                      color: Colors.grey[200],
                                      textColor: kColorPrimary,
                                      textSize: 16,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.right,
                                      text: this.start_date_controller.text,
                                      onPressed: () {}),
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
                                  child: Text("end_date".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                Container(
                                  child: CustomButton(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      width: MediaQuery.of(context).size.width * 1,
                                      color: Colors.grey[200],
                                      textColor: kColorPrimary,
                                      textSize: 16,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.right,
                                      text: this.end_date_controller.text,
                                      onPressed: () {}),
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: this.organization_name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                  child: Text("description".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: this.description_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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

  openCourseDialog(context, UserCourse userCourse) {
    name_controller.text = userCourse.name.toString();
    course_organization_name_controller.text = userCourse.organization_name.toString();
    duration_controller.text = userCourse.duration.toString();
    course_end_year_controller.text = userCourse.end_year.toString();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
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
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                      ),
                    ),

                    /// Form
                    Form(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("course_name".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: course_organization_name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: duration_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  controller: course_end_year_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
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

  List<Widget> buildEducationList(user_educations) {
    List<Widget> list = new List<Widget>();
    for (var i in user_educations) {
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
                          decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i.title,
                                    softWrap: true, style: TextStyle(fontSize: 16, color: kColorDark, height: 1.4)),
                                Text(i.faculty + ', ' + i.speciality,
                                    softWrap: true, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
                                Text(i.end_year,
                                    softWrap: true, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
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
                          Boxicons.bx_info_square,
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
    return list;
  }

  List<Widget> buildExperienceList(user_experiences) {
    List<Widget> list = new List<Widget>();
    for (var i in user_experiences) {
      list.add(Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                            Boxicons.bx_briefcase,
                            size: 32,
                            color: kColorPrimary,
                          ),
                          decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i.job_title,
                                    softWrap: true, style: TextStyle(fontSize: 16, color: kColorDark, height: 1.4)),
                                Text(i.organization_name,
                                    softWrap: true, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
                                Text(i.start_date + ' - ' + i.end_date,
                                    softWrap: true, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: CircleButton(
                            bgColor: Colors.transparent,
                            padding: 0,
                            icon: Icon(
                              Boxicons.bx_info_square,
                              color: kColorDarkBlue,
                              size: 24,
                            ),
                          ),
                          onTap: () {
                            openExperienceDialog(context, i);
                            // openFilterDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return list;
  }

  List<Widget> buildCourseList(user_courses) {
    List<Widget> list = new List<Widget>();
    for (var i in user_courses) {
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
                          decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i.name,
                                    softWrap: true, style: TextStyle(fontSize: 16, color: kColorDark, height: 1.4)),
                                Text(i.organization_name + ', ' + i.duration,
                                    softWrap: true, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
                                Text(i.end_year,
                                    softWrap: true, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
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
                          Boxicons.bx_info_square,
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
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileFullInfoScreenProps>(
        converter: (store) => mapStateToProps(store),
        onInitialBuild: (props) => this.handleInitialBuild(props),
        builder: (context, props) {
          UserFullInfo data = props.userResponse.data;
          bool user_loading = props.userResponse.loading;

          Widget body;
          if (user_loading) {
            body = Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
                ),
              ),
            );
          } else {

            body = Scaffold(
              appBar: AppBar(
                title: Text("profile".tr()),
              ),
              body: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: CircleAvatar(
                                  backgroundColor: kColorPrimary,
                                  radius: 60,
                                  backgroundImage: data.avatar != null
                                      ? NetworkImage(SERVER_IP + data.avatar,
                                          headers: {"Authorization": Prefs.getString(Prefs.TOKEN)})
                                      : null,
                                ),
                              ),
                            ),

                            /// Profile details
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Profile bio
                                  Center(
                                    child: Text('cv'.tr(), style: TextStyle(fontSize: 20, color: kColorDark)),
                                  ),

                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                    child: Text('basic_info'.tr().toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("user_surname_name".tr(),
                                                softWrap: true,
                                                style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                            Text(data.name,
                                                softWrap: true, style: TextStyle(fontSize: 16, color: kColorDark)),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("email".tr(),
                                                softWrap: true,
                                                style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                            Text(data.email != null ? data.email : '-',
                                                softWrap: true, style: TextStyle(fontSize: 16, color: kColorDark)),
                                          ],
                                        ),
                                        Prefs.getString(Prefs.ROUTE) != "COMPANY" ? Divider() : Container(),
                                        Prefs.getString(Prefs.ROUTE) != "COMPANY"
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("user_job_title".tr(),
                                                      softWrap: true,
                                                      style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(data?.job_title != null ? data?.job_title : '-',
                                                        softWrap: true,
                                                        style: TextStyle(fontSize: 16, color: kColorDark)),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("user_phone_number".tr(),
                                                softWrap: true,
                                                style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                            Text(data?.phone_number,
                                                softWrap: true, style: TextStyle(fontSize: 16, color: kColorDark)),
                                          ],
                                        ),
                                        // Divider(),
                                        // Column(
                                        //   children: [
                                        //     Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         Text("experience_year".tr(),
                                        //             softWrap: true,
                                        //             style: TextStyle(
                                        //                 fontSize: 16,
                                        //                 color: Colors.grey,
                                        //                 height: 2)),
                                        //         Text(
                                        //             data.experience_year != null
                                        //                 ? data.experience_year
                                        //                     .toString()
                                        //                 : '0',
                                        //             softWrap: true,
                                        //             style: TextStyle(
                                        //                 fontSize: 16,
                                        //                 color: kColorDark)),
                                        //       ],
                                        //     )
                                        //   ],
                                        // ),

                                        // Divider(),
                                        // Column(
                                        //   children: [
                                        //     Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         Text("linkedin_profile".tr(),
                                        //             softWrap: true,
                                        //             style: TextStyle(
                                        //                 fontSize: 16,
                                        //                 color: Colors.grey,
                                        //                 height: 2)),
                                        //         Text(
                                        //             data.linkedin != null
                                        //                 ? data.linkedin
                                        //                     .toString()
                                        //                 : '-',
                                        //             softWrap: true,
                                        //             style: TextStyle(
                                        //                 fontSize: 16,
                                        //                 color: kColorDark)),
                                        //       ],
                                        //     )
                                        //   ],
                                        // ),

                                        // Divider(),
                                        // Column(
                                        //   children: [
                                        //     Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         Text("are_you_migrant".tr(),
                                        //             softWrap: true,
                                        //             style: TextStyle(
                                        //                 fontSize: 16,
                                        //                 color: Colors.grey,
                                        //                 height: 2)),
                                        //         Text(
                                        //             data.is_migrant != 0
                                        //                 ? 'yes'.tr()
                                        //                 : 'no'.tr(),
                                        //             softWrap: true,
                                        //             style: TextStyle(
                                        //                 fontSize: 16,
                                        //                 color: kColorDark)),
                                        //       ],
                                        //     )
                                        //   ],
                                        // ),

                                        Divider(),
                                        data.attachment == null
                                            ? Container()
                                            : Container(
                                                margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                                alignment: Alignment.topLeft,
                                                child: Text('attachment'.tr().toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                        color: kColorDarkBlue)),
                                              ),
                                        data.attachment == null
                                            ? Container()
                                            : CustomButton(
                                                text: data.attachment != null
                                                    ? basename(data.attachment).toString()
                                                    : 'file_doesnt_exist'.tr(),
                                                width: MediaQuery.of(context).size.width * 1,
                                                color: Colors.grey[200],
                                                textColor: kColorPrimary,
                                                onPressed: () {
                                                  _launchURL(SERVER_IP + data.attachment);
                                                  //            doSome1(user_cv.attachment);
                                                }
                                                ),
                                      ],
                                    ),
                                  ),

                                  user_loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
                                          ),
                                        )
                                      : data != null
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text('user_education_info'.tr().toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                              color: kColorDarkBlue)),
                                                    ],
                                                  ),
                                                ),
                                                (data.user_educations.length > 0)
                                                    ? Column(
                                                        children: buildEducationList(data.user_educations),
                                                      )
                                                    : Container(
                                                        child: Container(
                                                            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                                            child: Text("empty".tr())),
                                                      ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text('user_experience_info'.tr().toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                              color: kColorDarkBlue)),
                                                    ],
                                                  ),
                                                ),
                                                data.user_experiences.length > 0
                                                    ? Column(
                                                        children: buildExperienceList(data.user_experiences),
                                                      )
                                                    : Container(
                                                        child: Container(
                                                            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                                            child: Text("empty".tr())),
                                                      ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text('user_course_info'.tr().toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                              color: kColorDarkBlue)),
                                                    ],
                                                  ),
                                                ),
                                                data.user_courses.length > 0
                                                    ? Column(
                                                        children: buildCourseList(data.user_courses),
                                                      )
                                                    : Container(
                                                        child: Container(
                                                            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                                            child: Text("empty".tr())),
                                                      ),

                                              ],
                                            )
                                          : Center(
                                              child: Container(
                                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15), child: Text("empty".tr())),
                                            ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: widget.recruited == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorPrimary,
                                      width: 2.0
                                  ),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  onPressed: () {
                                    Users user = new Users();
                                    user
                                        .setRecruit(widget.user_id, widget.userVacancyId, Recruited.rejected.index)
                                        .then((value) {
                                      StoreProvider.of<AppState>(context).dispatch(getSubmittedUsers());
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  text: 'Отклонить'.tr(),
                                ),
                                CustomButton(
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Users user = new Users();
                                    user
                                        .setRecruit(widget.user_id, widget.userVacancyId, Recruited.accepted.index)
                                        .then((value) {
                                      StoreProvider.of<AppState>(context).dispatch(getSubmittedUsers());
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  text: 'Одобрить'.tr(),
                                ),
                              ],
                            )
                          : widget.recruited == 1
                              ? Container()
                              : Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration:
                                      BoxDecoration(color: Color(0xffC5CAE9), borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                      child: Text("Отказано", style: TextStyle(fontSize: 18, color: Colors.white))),
                                ),
                    ),
                  ],
                ),
              ),
            );
          }

          return body;
        });
  }

  void _showDataPicker(int type, context) {
    DatePicker.showDatePicker(context,
        locale: LocaleType.ru,
        theme: DatePickerTheme(
          headerColor: Theme.of(context).primaryColor,
          cancelStyle: const TextStyle(color: Colors.white, fontSize: 17),
          doneStyle: const TextStyle(color: Colors.white, fontSize: 17),
        ), onConfirm: (date) {
      print(date);
      // Change state
      setState(() {
        if (type == 1) {
          start_date_controller.text = formatter.format(date);
          // StoreProvider
          //     .of<AppState>(context)
          //     .state
          //     .user
          //     .user_cv
          //     .data
          //     .user_experiences[index].start_date = date;
        } else {
          end_date_controller.text = formatter.format(date);
          // StoreProvider
          //     .of<AppState>(context)
          //     .state
          //     .user
          //     .user_cv
          //     .data
          //     .user_experiences[widget.index].end_date = date;
        }
      });
    });
  }
}

class ProfileFullInfoScreenProps {
  final Function getUserFullInfo;
  final UserFullInfoState userResponse;

  ProfileFullInfoScreenProps({
    this.getUserFullInfo,
    this.userResponse,
  });
}

ProfileFullInfoScreenProps mapStateToProps(Store<AppState> store) {
  return ProfileFullInfoScreenProps(
    getUserFullInfo: (user_id) => store.dispatch(getUserFullInfo(user_id)),
    userResponse: store.state.user.user_full_info,
  );
}
