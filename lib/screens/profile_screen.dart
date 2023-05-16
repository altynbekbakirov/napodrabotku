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
// import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:file_picker/file_picker.dart';
// import 'package:ishtapp/file/file_service.dart';
// import 'package:ishtapp/file/util.dart';

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

  getS() async {
    var list = await Vacancy.getLists('skillset', null);
    list.forEach((item) {
      SkillsV3.add({"id": item["id"].toString(), "name": item["name"], "categoryId": item["category_id"].toString()});
    });
  }

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
                                  keyboardType: TextInputType.number,
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

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
                                  color: Colors.grey[200],
                                  textColor: kColorPrimary,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'cancel'.tr(),
                                ),
                                CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
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
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("position".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
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
                                  child: TextFormField(
                                    controller: this.start_date_controller,
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
                                  child: TextFormField(
                                    controller: this.end_date_controller,
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

                          /// Sign In button
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
                                  color: Colors.grey[200],
                                  textColor: kColorPrimary,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'cancel'.tr(),
                                ),
                                CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
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
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("course_name".tr(),
                                      softWrap: true, style: TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
                                ),
                                TextFormField(
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

                          /// Sign In button
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
                                  color: Colors.grey[200],
                                  textColor: kColorPrimary,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'cancel'.tr(),
                                ),
                                CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.33,
                                  padding: EdgeInsets.all(10),
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

  /// Skills
  openSkillDialogCategory(context, List<String> options, List<String> listTag, String categoryName) {
    // List<String> listTag = [];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(categoryName.toUpperCase(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child:

                        /// Form
                        Column(
                      children: <Widget>[
                        ChipsChoice<String>.multiple(
                          choiceStyle: C2ChoiceStyle(
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            showCheckmark: false,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          choiceActiveStyle: C2ChoiceStyle(
                            color: kColorPrimary,
                          ),
                          padding: EdgeInsets.zero,
                          value: listTag,
                          onChanged: (val) {
                            return setState(() => listTag = val);
                          },
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: options,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          wrapped: true,
                          choiceLabelBuilder: (item) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 60,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  softWrap: true,
                                  maxLines: 4,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            );
                          },
                        ),

                        /// Sign In button
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                width: MediaQuery.of(context).size.width * 0.33,
                                padding: EdgeInsets.all(10),
                                color: Colors.grey[200],
                                textColor: kColorPrimary,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: 'cancel'.tr(),
                              ),
                              CustomButton(
                                width: MediaQuery.of(context).size.width * 0.33,
                                padding: EdgeInsets.all(10),
                                color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                                textColor: Colors.white,
                                onPressed: () {
                                  SkillCategory skillCategory = new SkillCategory();
                                  skillCategory.saveUserSkills(listTag, 1);
                                  Navigator.of(context).pop();
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
              );
            },
          );
        });
  }

  openSkillDialogCategory2(context, List<String> options, List<String> listTag, String categoryName) {
    // List<String> listTag = [];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(categoryName.toUpperCase(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child:

                        /// Form
                        Column(
                      children: <Widget>[
                        ChipsChoice<String>.multiple(
                          choiceStyle: C2ChoiceStyle(
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            showCheckmark: false,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          choiceActiveStyle: C2ChoiceStyle(
                            color: kColorPrimary,
                          ),
                          padding: EdgeInsets.zero,
                          value: listTag,
                          onChanged: (val) {
                            return setState(() => listTag = val);
                          },
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: options,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          wrapped: true,
                          choiceLabelBuilder: (item) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 60,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  softWrap: true,
                                  maxLines: 4,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            );
                          },
                        ),

                        /// Sign In button
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                width: MediaQuery.of(context).size.width * 0.33,
                                padding: EdgeInsets.all(10),
                                color: Colors.grey[200],
                                textColor: kColorPrimary,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: 'cancel'.tr(),
                              ),
                              CustomButton(
                                width: MediaQuery.of(context).size.width * 0.33,
                                padding: EdgeInsets.all(10),
                                color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                                textColor: Colors.white,
                                onPressed: () {
                                  SkillCategory skillCategory = new SkillCategory();
                                  skillCategory.saveUserSkills(listTag, 2);
                                  Navigator.of(context).pop();
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
              );
            },
          );
        });
  }

  int selectedCategoryIdFromVersion1;

  int selectedTest;

  getSkillSetCategories() async {
    var list = await Vacancy.getLists('skillset_category', null);

    list.forEach((item) {
      List<String> skills = [];

      item["skills"].forEach((skill) {
        skills.add(skill);
      });

      categories.add(
        StatefulBuilder(builder: (context, setState) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Boxicons.bx_atom,
                      size: 25,
                      color: kColorPrimary,
                    ),
                    decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        item['name'].toString(),
                        style: _textStyle,
                        textAlign: TextAlign.left,
                      )),
                ),
                Flexible(
                  flex: 3,
                  child: CustomButton(
                    height: 40.0,
                    width: 100.0,
                    padding: EdgeInsets.all(5),
                    color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                    textColor: Colors.white,
                    textSize: 14,
                    onPressed: () {
                      List<String> list = [];
                      List<String> listTag = [];
                      int id = item["id"];
                      skillSets.forEach((item) {
                        if (item.categoryId == id) {
                          list.add(item.name);
                        }
                      });
                      userSkills.forEach((item) {
                        if (item.categoryId == id) {
                          listTag.add(item.name);
                        }
                      });
                      openSkillDialogCategory(context, list, listTag, item["name"].toString());
                    },
                    text: 'add'.tr(),
                  ),
                ),
              ],
            ),
          );
        }),
      );

      categories2.add(
        StatefulBuilder(builder: (context, setState) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Boxicons.bx_atom,
                      size: 25,
                      color: kColorPrimary,
                    ),
                    decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        item['name'].toString(),
                        style: _textStyle,
                        textAlign: TextAlign.left,
                      )),
                ),
                Flexible(
                  flex: 3,
                  child: CustomButton(
                    height: 40.0,
                    width: 100.0,
                    padding: EdgeInsets.all(5),
                    color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                    textColor: Colors.white,
                    textSize: 14,
                    onPressed: () {
                      List<String> list = [];
                      List<String> listTag = [];
                      int id = item["id"];
                      skillSets.forEach((item) {
                        if (item.categoryId == id) {
                          list.add(item.name);
                        }
                      });
                      userSkills2.forEach((item) {
                        if (item.categoryId == id) {
                          listTag.add(item.name);
                        }
                      });
                      openSkillDialogCategory2(context, list, listTag, item["name"].toString());
                    },
                    text: 'add'.tr(),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  getSkillSets() async {
    var list = await Vacancy.getLists('skillset', null);
    list.forEach((item) {
      skillSets.add(Skill(id: item["id"], name: item["name"], categoryId: item["category_id"]));
    });
  }

  getUserSkills() async {
    var list = await Users.getSkills(Prefs.getString(Prefs.EMAIL), 1);
    list.forEach((item) {
      userSkills.add(Skill(id: item["id"], name: item["name"], categoryId: item["category_id"]));
    });

    var list2 = await Users.getSkills(Prefs.getString(Prefs.EMAIL), 2);
    list2.forEach((item) {
      userSkills2.add(Skill(id: item["id"], name: item["name"], categoryId: item["category_id"]));
    });
  }

  getUserSkills2() async {
    var list = await Users.getSkills(Prefs.getString(Prefs.EMAIL), 2);
    list.forEach((item) {
      userSkills2.add(Skill(id: item["id"], name: item["name"], categoryId: item["category_id"]));
    });
  }

  getJobSphere() async {
    var list = await Vacancy.getLists('job_sphere', null);
    list.forEach((sphere) {
      setState(() {
        spheres.add(sphere['name']);
      });
    });
  }

  getOpportunities() async {
    var list = await Vacancy.getLists('opportunity', null);
    list.forEach((opportunity) {
      setState(() {
        opportunities.add(opportunity['name']);
      });
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

  // double _progressValue = 0;
  // int _progressPercentValue = 0;
  //
  // final _scaffoldKey = GlobalKey<ScaffoldState>();


  // _showSnackBar(String text) {
  //   final snackBar = SnackBar(content: Text(text));
  //
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }
  //
  // void _uploadFile(File file) async {
  //   if (file == null) {
  //     _showSnackBar("Select file first");
  //     return;
  //   }
  //
  //   _setUploadProgress(0, 0);
  //
  //   try {
  //     // var httpResponse = await FileService.fileUpload(
  //     //     file: file, onUploadProgress: _setUploadProgress);
  //
  //     user_cv.save(attachment: file);
  //     await FileService.fileUploadMultipart(file: file, onUploadProgress: _setUploadProgress);
  //
  //     _showSnackBar("File uploaded - ${fileUtil.basename(file.path)}");
  //   } catch (e) {
  //     _showSnackBar(e.toString());
  //   }
  // }
  //
  // void _setUploadProgress(int sentBytes, int totalBytes) {
  //   double __progressValue = Util.remap(sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);
  //
  //   __progressValue = double.parse(__progressValue.toStringAsFixed(2));
  //
  //   if (__progressValue != _progressValue)
  //     setState(() {
  //       _progressValue = __progressValue;
  //       _progressPercentValue = (_progressValue * 100.0).toInt();
  //     });
  // }

  @override
  void initState() {
    getSkillSets();
    getUserSkills();
    getS();
    getSkillSetCategories();
    getJobSphere();
    getOpportunities();
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
                          backgroundColor:
                              Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
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
                                                          color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                              ? kColorProductLab
                                                              : kColorPrimary,
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
                                                  (StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data
                                                              .user_educations
                                                              .length >
                                                          0)
                                                      ? UserEducationInfo(
                                                          user_educations: StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data
                                                              .user_educations,
                                                          userCv: StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data)
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
                                                          color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                              ? kColorProductLab
                                                              : kColorPrimary,
                                                          textColor: Colors.white,
                                                          textSize: 14,
                                                          onPressed: () {
                                                            openExperienceDialog(context);
                                                          },
                                                          text: 'add'.tr(),
                                                        ),
                                                      ],
                                                    ),
                                                    // child: Text('user_experience_info'.tr().toUpperCase(),
                                                    //     style: TextStyle(
                                                    //         fontSize: 14,
                                                    //         fontWeight: FontWeight.w700,
                                                    //         color: kColorDarkBlue)),
                                                  ),
                                                  StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data
                                                              .user_experiences
                                                              .length >
                                                          0
                                                      ? UserExperienceInfo(
                                                          user_experiences: StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data
                                                              .user_experiences,
                                                          userCv: StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data)
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
                                                          color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                              ? kColorProductLab
                                                              : kColorPrimary,
                                                          textColor: Colors.white,
                                                          textSize: 14,
                                                          onPressed: () {
                                                            openCourseDialog(context);
                                                          },
                                                          text: 'add'.tr(),
                                                        ),
                                                      ],
                                                    ),
                                                    // child: Text('user_course_info'.tr().toUpperCase(),
                                                    //     style: TextStyle(
                                                    //         fontSize: 14,
                                                    //         fontWeight: FontWeight.w700,
                                                    //         color: kColorDarkBlue)),
                                                  ),
                                                  StoreProvider.of<AppState>(context)
                                                              .state
                                                              .user
                                                              .user_cv
                                                              .data
                                                              .user_courses
                                                              .length >
                                                          0
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

                                                  /// Навыки (Я умею)
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Container(
                                                          margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                                          child: Column(
                                                            children: [
                                                              Flex(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                direction: Axis.horizontal,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        'Навыки'.tr().toUpperCase() + ' (Я умею)',
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: kColorDarkBlue)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Column(
                                                          children: categories,
                                                        )
                                                      : Container(),

                                                  /// Навыки (Я хочу развить)
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Container(
                                                          margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                                          child: Column(
                                                            children: [
                                                              Flex(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                direction: Axis.horizontal,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        'Навыки'.tr().toUpperCase() +
                                                                            ' (Я хочу развить)',
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: kColorDarkBlue)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Column(
                                                          children: categories2,
                                                        )
                                                      : Container(),

                                                  /// Отрасль
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Container(
                                                          margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                                          child: Column(
                                                            children: [
                                                              Flex(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                direction: Axis.horizontal,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text('Отрасль'.tr().toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: kColorDarkBlue)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Container(
                                                          child: DropdownSearch<String>(
                                                              showSelectedItem: true,
                                                              items: spheres,
                                                              onChanged: (value) {
                                                                // setState(() {
                                                                //   selectedJobSphere = user.job_sphere;
                                                                // });

                                                                data.saveJobSphere(value);
                                                              },
                                                              dropdownSearchDecoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    borderSide: BorderSide.none,
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: Colors.grey[200],
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical: 5, horizontal: 12)),
                                                              selectedItem: data.job_sphere),
                                                        )
                                                      : Container(),

                                                  /// Возможность
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Container(
                                                          margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                                          child: Column(
                                                            children: [
                                                              Flex(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                direction: Axis.horizontal,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text('Возможность'.tr().toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: kColorDarkBlue)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                  Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                      ? Container(
                                                          child: DropdownSearch<String>(
                                                              showSelectedItem: true,
                                                              items: opportunities,
                                                              onChanged: (value) {
                                                                // setState(() {
                                                                //   selectedOpportunity = value;
                                                                // });
                                                                data.saveOpportunity(value);
                                                              },
                                                              dropdownSearchDecoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    borderSide: BorderSide.none,
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: Colors.grey[200],
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical: 5, horizontal: 12)),
                                                              selectedItem: data.opportunity),
                                                        )
                                                      : Container(),
                                                ],
                                              )
                                            : Center(
                                                child: Container(
                                                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                                    child: Text("empty".tr())),
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
                                              // user_cv.attachment == null
                                              //     ? Container()
                                              //     : CustomButton(
                                              //         text: user_cv.attachment != null
                                              //             ? 'download_file'.tr()
                                              //             : 'file_doesnt_exist'.tr(),
                                              //         width: MediaQuery.of(context).size.width * 1,
                                              //         color: Colors.grey[200],
                                              //         textColor: kColorPrimary,
                                              //         onPressed: () {
                                              //           _launchURL(SERVER_IP + user_cv.attachment);
                                              //         }),
                                              // SizedBox(height: 20),
                                              fileUploading
                                                  ? Container(
                                                    child: new CircularProgressIndicator(
                                                        backgroundColor: kColorPrimary.withOpacity(0.2),
                                                        valueColor:
                                                        new AlwaysStoppedAnimation<Color>(kColorPrimary)
                                                    ),
                                                  )
                                                  : CustomButton(
                                                  text: data_cv == null || data_cv.attachment == null
                                                      ? attachment != null
                                                          ? basename(attachment.path)
                                                          : 'upload_file'.tr()
                                                      : data_cv.attachment.substring(20),
                                                  width: MediaQuery.of(context).size.width * 1,
                                                  color: Colors.grey[200],
                                                  textColor: kColorPrimary,
                                                  onPressed: () async {
                                                    _pickAttachment();

                                                    // FilePickerResult result = await FilePicker.platform.pickFiles();
                                                    //
                                                    // if(result != null) {
                                                    //   PlatformFile file = result.files.first;
                                                    //
                                                    //   print(file.name);
                                                    //   print(file.bytes);
                                                    //   print(file.size);
                                                    //   print(file.extension);
                                                    //   print(file.path);
                                                    // } else {
                                                    //   // User canceled the picker
                                                    // }
                                                  }
                                                ),
                                              // Container(
                                              //     padding: EdgeInsets.only(top: 10),
                                              //     child: new Column(children: <Widget>[
                                              //       Text(
                                              //         '20 %',
                                              //         style: Theme.of(context).textTheme.display1,
                                              //       ),
                                              //     ])),
                                              // Container(
                                              //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                              //     child: LinearProgressIndicator(value: 10)
                                              // ),


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

  Widget _rowProfileInfo(BuildContext context, {@required Widget icon, @required String title}) {
    return Row(
      children: [
        icon,
        SizedBox(width: 5),
        Text(title),
      ],
    );
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
