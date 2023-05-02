import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/widgets/cicle_button.dart';

class UserExperienceInfo extends StatefulWidget {
  List<UserExperience> user_experiences;
  UserCv userCv;

  UserExperienceInfo({Key key, this.user_experiences, this.userCv})
      : super(key: key);

  @override
  _UserExperienceInfoState createState() => _UserExperienceInfoState();
}

class _UserExperienceInfoState extends State<UserExperienceInfo> {
  final job_title_controller = TextEditingController();
  final start_date_controller = TextEditingController();
  final end_date_controller = TextEditingController();
  final organization_name_controller = TextEditingController();
  final description_controller = TextEditingController();

  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  final experienceUpdateFormKey = GlobalKey<FormState>();

  openExperienceDialog(context, UserExperience userExperience) {
    job_title_controller.text = userExperience.job_title.toString();
    start_date_controller.text =
        userExperience.start_date != null ? (userExperience.start_date) : '';
    end_date_controller.text =
        userExperience.end_date != null ? (userExperience.end_date) : '';
    organization_name_controller.text = userExperience.organization_name != null
        ? userExperience.organization_name.toString()
        : '';
    description_controller.text = userExperience.description != null
        ? userExperience.description.toString()
        : "";

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
                        child: Text('user_experience_info'.tr().toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kColorDarkBlue)),
                      ),
                    ),

                    /// Form
                    Form(
                      key: experienceUpdateFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("position".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: this.job_title_controller,
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
                                  child: Text("start_date".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                Container(
                                  child: TextFormField(
                                    controller: this.start_date_controller,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                Container(
                                  child: TextFormField(
                                    controller: this.end_date_controller,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                  controller: this.organization_name_controller,
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
                                  child: Text("description".tr(),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          height: 2)),
                                ),
                                TextFormField(
                                  controller: this.description_controller,
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
                                    userExperience
                                        .delete(userExperience.id)
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
                                    if (experienceUpdateFormKey.currentState
                                        .validate()) {
                                      userExperience.job_title =
                                          job_title_controller.text;
                                      userExperience.start_date =
                                          start_date_controller.text;
                                      userExperience.end_date =
                                          (end_date_controller.text);
                                      userExperience.organization_name =
                                          organization_name_controller.text;
                                      userExperience.description =
                                          description_controller.text;

                                      userExperience
                                          .update(userExperience.id)
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

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (var i in widget.user_experiences) {
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
                          decoration: BoxDecoration(
                              color: Color(0xffF2F2F5),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i.job_title,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: kColorDark,
                                        height: 1.4)),
                                Text(
                                    i.organization_name != null
                                        ? i.organization_name
                                        : '',
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        height: 1.4)),
                                Text(
                                    (i.start_date != null ? i.start_date : '') +
                                        ' - ' +
                                        (i.end_date != null ? i.end_date : ''),
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
                    child: Column(
                      children: [
                        GestureDetector(
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
    return Container(
        child: Column(
      children: list,
    ));
  }
}
