import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:path/path.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/widgets/basic_user_info.dart';
import 'package:ishtapp/widgets/user_course_info.dart';
import 'package:ishtapp/widgets/user_education_info.dart';
import 'package:ishtapp/widgets/user_experience_info.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/datas/Skill.dart';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:file_picker/file_picker.dart';
import 'package:masked_text/masked_text.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File attachment;
  UserCv user_cv;
  Users user;

  void handleInitialBuild(ProfileScreenProps props) {
    props.getUserCv();
    props.getUser();
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
  UserCv userCv;

  final educationAddFormKey = GlobalKey<FormState>();
  final educationEditFormKey = GlobalKey<FormState>();
  final experienceAddFormKey = GlobalKey<FormState>();
  final experienceEditFormKey = GlobalKey<FormState>();
  final courseAddFormKey = GlobalKey<FormState>();
  final courseEditFormKey = GlobalKey<FormState>();

  List<Widget> categories = [];
  List<Widget> categories2 = [];
  List<Widget> skillsV1 = [];
  List<Skill> skillSets = [];
  List<Skill> userSkills = [];
  List<Skill> userSkills2 = [];
  List<String> tags = [];

  List<String> spheres = [];
  String selectedJobSphere;

  List<String> opportunities = [];
  String selectedOpportunity;

  List<Map<String, dynamic>> SkillsV3 = [];

  openEducationDialog(context) {
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
                      key: educationAddFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'university'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: title_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'faculty'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: faculty_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'speciality'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: speciality_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'end_year'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                MaskedTextField(
                                  maskedTextFieldController: end_year_controller,
                                  mask: "xxxx",
                                  maxLength: 4,
                                  keyboardType: TextInputType.number,
                                  inputDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: CustomButton(
                                        borderSide: BorderSide(
                                            color: kColorPrimary,
                                            width: 2.0
                                        ),
                                        padding: EdgeInsets.all(0),
                                        color: Colors.transparent,
                                        textColor: kColorPrimary,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        text: 'cancel'.tr(),
                                      ),
                                    )
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: CustomButton(
                                      padding: EdgeInsets.all(0),
                                      color: kColorPrimary,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if (educationAddFormKey.currentState.validate()) {
                                          this.userEducation.title = title_controller.text;
                                          this.userEducation.faculty = faculty_controller.text;
                                          this.userEducation.speciality = speciality_controller.text;
                                          this.userEducation.type = type_controller.text;
                                          this.userEducation.end_year = end_year_controller.text;

                                          this
                                              .userEducation
                                              .save(StoreProvider.of<AppState>(context).state.user.user_cv.data.id)
                                              .then((value) {
                                            StoreProvider.of<AppState>(context).dispatch(getUserCv());
                                            Navigator.of(context).pop();
                                            title_controller = TextEditingController();
                                            faculty_controller = TextEditingController();
                                            speciality_controller = TextEditingController();
                                            type_controller = TextEditingController();
                                            end_year_controller = TextEditingController();
                                          });
                                        }
                                      },
                                      text: 'save'.tr(),
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
        });
  }

  openExperienceDialog(context) {
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
                      key: experienceAddFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'position'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: this.job_title_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            margin: EdgeInsets.only(bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'start_date'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                Container(
                                  child: MaskedTextField(
                                    maskedTextFieldController: start_date_controller,
                                    mask: "xx.xxxx",
                                    maxLength: 7,
                                    keyboardType: TextInputType.number,
                                    inputDecoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'end_date'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                Container(
                                  child: MaskedTextField(
                                    maskedTextFieldController: end_date_controller,
                                    mask: "xx.xxxx",
                                    maxLength: 7,
                                    keyboardType: TextInputType.number,
                                    inputDecoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'organization_name'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: this.organization_name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'description'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: this.description_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 5),
                                    child: CustomButton(
                                      borderSide: BorderSide(
                                          color: kColorPrimary,
                                          width: 2.0
                                      ),
                                      padding: EdgeInsets.all(0),
                                      color: Colors.transparent,
                                      textColor: kColorPrimary,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      text: 'cancel'.tr(),
                                    ),
                                  )
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: CustomButton(
                                      padding: EdgeInsets.all(0),
                                      color: kColorPrimary,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if (experienceAddFormKey.currentState.validate()) {
                                          this.userExperience.job_title = job_title_controller.text;
                                          this.userExperience.start_date = (start_date_controller.text);
                                          this.userExperience.end_date = (end_date_controller.text);
                                          this.userExperience.organization_name = organization_name_controller.text;
                                          this.userExperience.description = description_controller.text;

                                          this
                                              .userExperience
                                              .save(StoreProvider.of<AppState>(context).state.user.user_cv.data.id)
                                              .then((value) {
                                            StoreProvider.of<AppState>(context).dispatch(getUserCv());
                                            Navigator.of(context).pop();
                                            job_title_controller = TextEditingController();
                                            start_date_controller = TextEditingController();
                                            end_date_controller = TextEditingController();
                                            organization_name_controller = TextEditingController();
                                            description_controller = TextEditingController();
                                          });
                                        }
                                      },
                                      text: 'save'.tr(),
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
        });
  }

  openCourseDialog(context) {
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
                      key: courseAddFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'course_name'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'organization_name'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: course_organization_name_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'duration'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                TextFormField(
                                  controller: duration_controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
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
                                Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'end_year'.tr().toString().toUpperCase(),
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                    )
                                ),
                                MaskedTextField(
                                  maskedTextFieldController: course_end_year_controller,
                                  mask: "xxxx",
                                  maxLength: 4,
                                  keyboardType: TextInputType.number,
                                  inputDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Sign In button
                          Container(
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: CustomButton(
                                        borderSide: BorderSide(
                                            color: kColorPrimary,
                                            width: 2.0
                                        ),
                                        padding: EdgeInsets.all(0),
                                        color: Colors.transparent,
                                        textColor: kColorPrimary,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        text: 'cancel'.tr(),
                                      ),
                                    )
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: CustomButton(
                                      padding: EdgeInsets.all(0),
                                      color: kColorPrimary,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if (courseAddFormKey.currentState.validate()) {
                                          this.userCourse.name = name_controller.text;
                                          this.userCourse.organization_name = course_organization_name_controller.text;
                                          this.userCourse.duration = duration_controller.text;
                                          this.userCourse.end_year = course_end_year_controller.text;

                                          this
                                              .userCourse
                                              .save(StoreProvider.of<AppState>(context).state.user.user_cv.data.id)
                                              .then((value) {
                                            StoreProvider.of<AppState>(context).dispatch(getUserCv());
                                            Navigator.of(context).pop();

                                            name_controller = TextEditingController();
                                            course_organization_name_controller = TextEditingController();
                                            duration_controller = TextEditingController();
                                            course_end_year_controller = TextEditingController();
                                          });
                                        }
                                      },
                                      text: 'save'.tr(),
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
        });
  }

  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  bool fileUploading = false;

  void _pickAttachment() async {

    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'doc', 'docx'],
    // );

    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    setState(() {
      fileUploading = true;
    });

    if(result != null) {
      File endFile = File(result.paths.first);

      if (endFile != null){
        if(await user_cv.save(attachment: endFile) == 'OK'){
          setState(() {
            fileUploading = false;
            attachment = endFile;
          });
        }
      } else {
        user_cv.save();
      }

      print(endFile);
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
    } else {
      // User canceled the picker
    }

    // if (file != null) {
    //   if (file != null){
    //     user_cv.save(attachment: file);
    //     setState(() {
    //       attachment = file;
    //     });
    //   } else {
    //     user_cv.save();
    //   }
    //
    // } else {
    //   // User canceled the picker
    // }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
      user_cv = StoreProvider.of<AppState>(context).state.user.user_cv.data;
      user = StoreProvider.of<AppState>(context).state.user.user.data;
    }

    return StoreConnector<AppState, ProfileScreenProps>(
        converter: (store) => mapStateToProps(store),
        onInitialBuild: (props) => this.handleInitialBuild(props),
        builder: (context, props) {
          Users data = props.userResponse.data;
          UserCv data_cv = props.userCvResponse.data;
          user_cv = data_cv;
          bool cv_loading = props.userCvResponse.loading;
          bool user_loading = props.userResponse.loading;

          Widget body;
          if (user_loading) {
            body = Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
              ),
            );
          } else {
            body = Scaffold(
              appBar: AppBar(
                title: Text("profile".tr()),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundColor: kColorPrimary,
                          radius: 60,
                          backgroundImage: Prefs.getString(Prefs.PROFILEIMAGE) != null
                              ? NetworkImage(SERVER_IP + Prefs.getString(Prefs.PROFILEIMAGE),
                                  headers: {"Authorization": Prefs.getString(Prefs.TOKEN)})
                              : null,
                        ),
                      ),
                    ),

                    /// Profile details
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Profile bio
                          // Prefs.getString(Prefs.USER_TYPE) == "USER"
                          //     ? Center(
                          //         child: Text('cv'.tr(), style: TextStyle(fontSize: 20, color: kColorDark)),
                          //       )
                          //     : Container(),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                            child: Text('basic_info'.tr().toUpperCase(),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                          ),
                          BasicUserCvInfo(
                              user_cv: StoreProvider.of<AppState>(context).state.user.user_cv.data, user: data),

                          Prefs.getString(Prefs.USER_TYPE) == "USER"
                              ? Column(
                                  children: [
                                    cv_loading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
                                            ),
                                          )
                                        : StoreProvider.of<AppState>(context).state.user.user_cv.data != null
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
                                                        CustomButton(
                                                          height: 40.0,
                                                          width: 100.0,
                                                          padding: EdgeInsets.all(5),
                                                          color: kColorPrimary,
                                                          textColor: Colors.white,
                                                          textSize: 14,
                                                          onPressed: () {
                                                            openEducationDialog(context);
                                                          },
                                                          text: 'add'.tr(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  (StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations.length > 0)
                                                      ? UserEducationInfo(
                                                          user_educations: StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations,
                                                          userCv: StoreProvider.of<AppState>(context).state.user.user_cv.data)
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
                                                        CustomButton(
                                                          height: 40.0,
                                                          width: 100.0,
                                                          padding: EdgeInsets.all(5),
                                                          color: kColorPrimary,
                                                          textColor: Colors.white,
                                                          textSize: 14,
                                                          onPressed: () {
                                                            openExperienceDialog(context);
                                                          },
                                                          text: 'add'.tr(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences.length > 0
                                                      ? UserExperienceInfo(
                                                          user_experiences: StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences,
                                                          userCv: StoreProvider.of<AppState>(context).state.user.user_cv.data)
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
                                                        CustomButton(
                                                          height: 40.0,
                                                          width: 100.0,
                                                          padding: EdgeInsets.all(5),
                                                          color: kColorPrimary,
                                                          textColor: Colors.white,
                                                          textSize: 14,
                                                          onPressed: () {
                                                            openCourseDialog(context);
                                                          },
                                                          text: 'add'.tr(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  StoreProvider.of<AppState>(context).state.user.user_cv.data.user_courses.length > 0
                                                      ? UserCourseInfo(
                                                          user_courses: StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data
                                                              .user_courses,
                                                          userCv: StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data,
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
                                                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                                    child: Text("empty".tr())
                                                ),
                                              ),
                                    SizedBox(height: 30),
                                    data_cv == null
                                        ? Container()
                                        : Align(
                                            widthFactor: 10,
                                            heightFactor: 1.5,
                                            alignment: Alignment.topLeft,
                                            child: Text('attachment'.tr().toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                                          ),
                                    data_cv == null
                                        ? Container()
                                        : Column(
                                            children: [
                                              SizedBox(height: 10),
                                              fileUploading
                                                  ? Container(
                                                    child: new CircularProgressIndicator(
                                                        backgroundColor: kColorPrimary.withOpacity(0.2),
                                                        valueColor:
                                                        new AlwaysStoppedAnimation<Color>(kColorPrimary)
                                                    ),
                                                  )
                                                  : CustomButton(
                                                  text: data_cv.attachment != null
                                                      ? basename(data_cv.attachment).toString()
                                                      : 'file_doesnt_exist'.tr(),
                                                  width: MediaQuery.of(context).size.width * 1,
                                                  color: Colors.grey[200],
                                                  textColor: kColorPrimary,
                                                  onPressed: () {
                                                    _launchURL(SERVER_IP + data_cv.attachment);
                                                    //            doSome1(user_cv.attachment);
                                                  }
                                                  // text: data_cv == null || data_cv.attachment == null
                                                  //     ? attachment != null
                                                  //         ? basename(attachment.path)
                                                  //         : 'upload_file'.tr()
                                                  //     : data_cv.attachment.substring(20),
                                                  // width: MediaQuery.of(context).size.width * 1,
                                                  // borderSide: BorderSide(
                                                  //     color: kColorPrimary,
                                                  //     width: 2.0
                                                  // ),
                                                  // padding: EdgeInsets.all(0),
                                                  // color: Colors.transparent,
                                                  // textColor: kColorPrimary,
                                                  // onPressed: () async {
                                                  //   _pickAttachment();
                                                  // }
                                                ),

                                            ],
                                          ),
                                    data_cv == null ? Container() : SizedBox(height: 30),
                                  ],
                                )
                              : Container(),
                        ],
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
        } else {
          end_date_controller.text = formatter.format(date);
        }
      });
    });
  }

  Widget _rowProfileInfo(BuildContext context, {@required Widget icon, @required String title}) {
    return Row(
      children: [
        icon,
        SizedBox(width: 5),
        Text(title),
      ],
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ProfileScreenProps {
  final Function getUserCv;
  final Function getUser;
  final UserDetailState userResponse;
  final UserCvState userCvResponse;

  ProfileScreenProps({this.getUserCv, this.getUser, this.userResponse, this.userCvResponse});
}

ProfileScreenProps mapStateToProps(Store<AppState> store) {
  return ProfileScreenProps(
    getUserCv: () => store.dispatch(getUserCv()),
    getUser: () => store.dispatch(getUser()),
    userResponse: store.state.user.user,
    userCvResponse: store.state.user.user_cv,
  );
}
