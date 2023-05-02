//import 'package:flutter/cupertino.dart';
//import 'package:easy_localization/easy_localization.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:ishtapp/components/custom_button.dart';
//import 'package:flutter_redux/flutter_redux.dart';
//
//import 'package:ishtapp/datas/user_model.dart';
//import 'package:ishtapp/utils/constants.dart';
//import 'package:ishtapp/datas/app_state.dart';
//
//typedef OnDelete();
//
//class UserExperienceForm extends StatefulWidget {
//  final UserExperience experience;
//  final state = _UserExperienceFormState();
//  final OnDelete onDelete;
//  int index;
//
//  UserExperienceForm({Key key, this.experience, this.onDelete, this.index}):super(key: key);
//
//  bool isValid()=>state.validate();
//
//  @override
//  _UserExperienceFormState createState() => state;
//}
//
//class _UserExperienceFormState extends State<UserExperienceForm> {
//
//  final form = GlobalKey<FormState>();
//
//  final job_title_controller = TextEditingController();
//  final start_date_controller = TextEditingController();
//  final end_date_controller = TextEditingController();
//  final organization_name_controller = TextEditingController();
//  final description_controller = TextEditingController();
//  final DateFormat formatter = DateFormat('yyyy-MM-dd');
//
//  bool validate(){
//    var valid = form.currentState.validate();
//    if(valid) form.currentState.save();
//    return valid;
//  }
//  @override
//  void initState() {
////    if(StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences.length>widget.index){
////      UserExperience userExperience = new UserExperience();
////      StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences.add(userExperience);
////    }
//    if(widget.experience != null){
////      job_title_controller.text = StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].job_title;
////      start_date_controller.text = formatter.format(StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].start_date);
////      end_date_controller.text = formatter.format(StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].end_date);
////      organization_name_controller.text = StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].organization_name;
////      description_controller.text = StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].description;
//    }
//  }
//
//  /*void _showDataPicker(int type) {
//    DatePicker.showDatePicker(context,
//        locale: LocaleType.ru,
//        theme: DatePickerTheme(
//          headerColor: Theme.of(context).primaryColor,
//          cancelStyle: const TextStyle(color: Colors.white, fontSize: 17),
//          doneStyle: const TextStyle(color: Colors.white, fontSize: 17),
//        ), onConfirm: (date) {
//          print(date);
//          // Change state
//          setState(() {
//            if(type ==1) {
//              start_date_controller.text = date;
//              StoreProvider
//                  .of<AppState>(context)
//                  .state
//                  .user
//                  .user_cv
//                  .data
//                  .user_experiences[widget.index].start_date = date;
//            }
//            else {
//              end_date_controller.text = date.toString().split(" ")[0];
//              StoreProvider
//                  .of<AppState>(context)
//                  .state
//                  .user
//                  .user_cv
//                  .data
//                  .user_experiences[widget.index].end_date = date;
//            }
//          });
//        });
//  }*/
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//        padding: EdgeInsets.all(10),
//      child: Card(
//        elevation: 0.6,
//        borderOnForeground: true,
//        color: Colors.white,
//        child: Form(
//          key: form,
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: [
//              AppBar(
//                leading: Container(),
//                title: Text("experience".tr()),
//                actions: [
//                  IconButton(icon: Icon(Icons.delete), onPressed: (){
//                    widget.onDelete();
//                  })
//                ],
//              ),
//              SizedBox(height: 10,),
//              Align(
//                  heightFactor: 1.5,
//                  alignment: Alignment.topLeft,
//                  child: Text('position'.tr(), style: TextStyle(fontSize: 16, color: Colors.black),)),
//              Padding(
//                padding: EdgeInsets.all(10),
//                child: TextFormField(
//                  controller: job_title_controller,
//                  decoration: InputDecoration(
//                    border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10),
//                        borderSide: BorderSide.none
//                    ),
//                    floatingLabelBehavior: FloatingLabelBehavior.always,
//                    filled: true,
//                    fillColor: Colors.grey[200],
//                  ),
//                  validator: (name) {
//                    // Basic validation
//                    if (name.isEmpty) {
//                      return "please_fill_this_field".tr();
//                    }
//                    return null;
//                  },
//                  onChanged: (value){
//                    StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].job_title = value;
//                  },
//                ),
//              ),
//              SizedBox(height: 10,),
//              Align(
////                      widthFactor: 10,
//                  heightFactor: 1.5,
//                  alignment: Alignment.topLeft,
//                  child: Text('start_date'.tr(), style: TextStyle(fontSize: 16, color: Colors.black),)),
//              Padding(
//                padding: EdgeInsets.all(10),
//                child: CustomButton(
//                    width: MediaQuery.of(context).size.width * 1,
//                    color: Colors.grey[200],
//                    textColor: kColorPrimary,
//                    text: start_date_controller.text,
//                    onPressed: (){_showDataPicker(1);}),
//              ),
//              SizedBox(height: 10,),
//              Align(
//                  heightFactor: 1.5,
//                  alignment: Alignment.topLeft,
//                  child: Text('end_date'.tr(), style: TextStyle(fontSize: 16, color: Colors.black),)),
//              Padding(
//                padding: EdgeInsets.all(10),
//                child: CustomButton(
//                    width: MediaQuery.of(context).size.width * 1,
//                    color: Colors.grey[200],
//                    textColor: kColorPrimary,
//                    text: end_date_controller.text,
//                    onPressed: (){_showDataPicker(2);}),
//              ),
//              SizedBox(height: 10,),
//              Align(
////                      widthFactor: 10,
//                  heightFactor: 1.5,
//                  alignment: Alignment.topLeft,
//                  child: Text('organization_name'.tr(), style: TextStyle(fontSize: 16, color: Colors.black),)),
//              Padding(
//                padding: EdgeInsets.all(10),
//                child: TextFormField(
//                  controller: organization_name_controller,
//                  decoration: InputDecoration(
//                    border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10),
//                        borderSide: BorderSide.none
//                    ),
//                    floatingLabelBehavior: FloatingLabelBehavior.always,
//                    filled: true,
//                    fillColor: Colors.grey[200],
//                  ),
//                  validator: (name) {
//                    // Basic validation
//                    if (name.isEmpty) {
//                      return "please_fill_this_field".tr();
//                    }
//                    return null;
//                  },
//                  onChanged: (value){
//                    StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].organization_name = value;
//                  },
//                ),
//              ),
//              SizedBox(height: 10,),
//              Align(
////                      widthFactor: 10,
//                  heightFactor: 1.5,
//                  alignment: Alignment.topLeft,
//                  child: Text('description'.tr(), style: TextStyle(fontSize: 16, color: Colors.black),)),
//              Padding(
//                padding: EdgeInsets.all(10),
//                child: TextFormField(
//                  controller: description_controller,
//                  decoration: InputDecoration(
//                    border: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(10),
//                        borderSide: BorderSide.none
//                    ),
//                    floatingLabelBehavior: FloatingLabelBehavior.always,
//                    filled: true,
//                    fillColor: Colors.grey[200],
//                  ),
//                  validator: (name) {
//                    // Basic validation
//                    if (name.isEmpty) {
//                      return "please_fill_this_field".tr();
//                    }
//                    return null;
//                  },
//                  onChanged: (value){
//                    StoreProvider.of<AppState>(context).state.user.user_cv.data.user_experiences[widget.index].description = value;
//                  },
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
