import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/app_state.dart';

typedef OnDelete();

class UserEducationForm extends StatefulWidget {
  final UserEducation education;
  final state = _UserEducationFormState();
  final OnDelete onDelete;
  int index;

  UserEducationForm({Key key, this.education, this.onDelete, this.index})
      : super(key: key);

  bool isValid() => state.validate();

  @override
  _UserEducationFormState createState() => state;
}

class _UserEducationFormState extends State<UserEducationForm> {
  final form = GlobalKey<FormState>();

  final title_controller = TextEditingController();
  final faculty_controller = TextEditingController();
  final speciality_controller = TextEditingController();
  final end_year_controller = TextEditingController();

  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }

  @override
  void initState() {
//    if(StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations.length>widget.index){
//      UserEducation userExperience = new UserEducation();
//      StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations.add(userExperience);
//    }
    if (widget.education != null) {
//      job_title_controller.text = StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations[widget.index].job_title;
//      start_date_controller.text = formatter.format(StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations[widget.index].start_date);
//      end_date_controller.text = formatter.format(StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations[widget.index].end_date);
//      organization_name_controller.text = StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations[widget.index].organization_name;
//      description_controller.text = StoreProvider.of<AppState>(context).state.user.user_cv.data.user_educations[widget.index].description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 0.6,
        borderOnForeground: true,
        color: Colors.white,
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                leading: Container(),
                title: Text("education".tr()),
                actions: [
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        widget.onDelete();
                      })
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                  heightFactor: 1.5,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'university'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: title_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
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
                  onChanged: (value) {
                    StoreProvider.of<AppState>(context)
                        .state
                        .user
                        .user_cv
                        .data
                        .user_educations[widget.index]
                        .title = value;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
//                      widthFactor: 10,
                  heightFactor: 1.5,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'faculty'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: faculty_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
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
                  onChanged: (value) {
                    StoreProvider.of<AppState>(context)
                        .state
                        .user
                        .user_cv
                        .data
                        .user_educations[widget.index]
                        .faculty = value;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                  heightFactor: 1.5,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'speciality'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: title_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
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
                  onChanged: (value) {
                    StoreProvider.of<AppState>(context)
                        .state
                        .user
                        .user_cv
                        .data
                        .user_educations[widget.index]
                        .speciality = value;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
//                      widthFactor: 10,
                  heightFactor: 1.5,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'organization_name'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: end_year_controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
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
                  onChanged: (value) {
                    StoreProvider.of<AppState>(context)
                        .state
                        .user
                        .user_cv
                        .data
                        .user_educations[widget.index]
                        .end_year = value;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
