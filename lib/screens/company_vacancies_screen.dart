import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/utils/textFormatter/lengthLimitingTextInputFormatter.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:ishtapp/widgets/vacancy_card.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

class CompanyVacanciesScreen extends StatefulWidget {

  @override
  _CompanyVacanciesScreenState createState() => _CompanyVacanciesScreenState();
}

class _CompanyVacanciesScreenState extends State<CompanyVacanciesScreen> {

  final _vacancyAddFormKey = GlobalKey<FormState>();

  TextEditingController _vacancy_name_controller = TextEditingController();
  TextEditingController _vacancy_salary_controller = TextEditingController();
  TextEditingController _vacancy_salary_from_controller = TextEditingController();
  TextEditingController _vacancy_salary_to_controller = TextEditingController();
  TextEditingController _vacancy_description_controller = TextEditingController();
  TextEditingController _vacancyStreetController = TextEditingController();
  TextEditingController _vacancyHouseNumberController = TextEditingController();

  int _jobTypeId;
  int _vacancyTypeId;
  int _busynessId;
  int _scheduleId;
  int _regionId;
  int _districtId;
  int _currencyId;
  int _salaryPeriodId;
  int _experienceId;
  int _payPeriodId;
  String _latitude;
  String _longitude;

  List<dynamic> jobTypeList = [];
  List<dynamic> vacancyTypeList = [];
  List<dynamic> busynessList = [];
  List<dynamic> scheduleList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<dynamic> currencyList = [];

  bool loading = false;

  TextEditingController _vacancyTypeAheadController = TextEditingController();
  List<dynamic> _suggestionsAddress = [];
  String selectedRegion;
  String selectedDistrict;
  String _selectedCity;
  List<String> regions = [];
  List<String> districts = [];

  void handleInitialBuildOfCompanyVacancy(CompanyVacanciesScreenProps props) {
    props.getCompanyVacancies();
  }

  getLists() async {
    regionList = await Vacancy.getLists('region', null);
    jobTypeList = await Vacancy.getLists('job_type', null);
    vacancyTypeList = await Vacancy.getLists('vacancy_type', null);
    busynessList = await Vacancy.getLists('busyness', null);
    scheduleList = await Vacancy.getLists('schedule', null);
    districtList = await Vacancy.getLists('districts', null);
    await Vacancy.getLists('region', null).then((value) {
      value.forEach((region) {
        regions.add(region["name"]);
      });
    });
    currencyList = await Vacancy.getLists('currencies', null);
  }

  Future<void> openVacancyForm(context) async {
    _jobTypeId = null;
    _vacancyTypeId = null;
    _busynessId = null;
    _scheduleId = null;
    _regionId = null;
    _districtId = null;
    _currencyId = null;
    _suggestionsAddress = [];

    if(Prefs.getString(Prefs.LANGUAGE) == 'ru'){
      _currencyId = 3;
    }

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return loading ?
            Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ) :
            Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9, maxWidth: MediaQuery.of(context).size.width * 0.9),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'add'.tr(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'fill_all_fields'.tr(),
                              style: TextStyle(fontSize: 14, color: kColorPrimary),
                            )
                        ),
                      ),

                      /// Form
                      Form(
                        key: _vacancyAddFormKey,
                        child: Column(
                          children: <Widget>[
                            /// Название вакансии
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'vacancy_name'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  TextFormField(
                                    controller: _vacancy_name_controller,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    focusNode: FocusNode(canRequestFocus: false),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    validator: (name) {
                                      if (name.isEmpty) {
                                        return "please_fill_this_field".tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            /// Salary
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      children: [
                                        Align(
                                            widthFactor: 10,
                                            heightFactor: 1.5,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'vacancy_salary'.tr().toString().toUpperCase() + '*',
                                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                            )
                                        ),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                // optional flex property if flex is 1 because the default flex is 1
                                                flex: 1,
                                                child: TextFormField(
                                                  controller: _vacancy_salary_from_controller,
                                                  focusNode: FocusNode(canRequestFocus: false),
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    filled: true,
                                                    fillColor: kColorWhite,
                                                  ),
                                                  inputFormatters: [Utf8LengthLimitingTextInputFormatter(20)],
                                                  validator: (name) {
                                                    if (name.isEmpty) {
                                                      return "please_fill_this_field".tr();
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                child: Text('__'),
                                              ),
                                              Expanded(
                                                // optional flex property if flex is 1 because the default flex is 1
                                                flex: 1,
                                                child: TextFormField(
                                                  controller: _vacancy_salary_to_controller,
                                                  focusNode: FocusNode(canRequestFocus: false),
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    filled: true,
                                                    fillColor: kColorWhite,
                                                  ),
                                                  inputFormatters: [Utf8LengthLimitingTextInputFormatter(20)],
                                                  validator: (name) {
                                                    // if (name.isEmpty) {
                                                    //   return "please_fill_this_field".tr();
                                                    // }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      children: [
                                        Align(
                                            widthFactor: 10,
                                            heightFactor: 1.5,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'currency'.tr().toString().toUpperCase() + '*',
                                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                            )
                                        ),
                                        DropdownButtonFormField<int>(
                                          hint: Text(
                                            "select".tr(),
                                            style: TextStyle(
                                                fontSize: 14
                                            ),
                                          ),
                                          value: _currencyId,
                                          onChanged: (int newValue) async {
                                            setState(() {
                                              _currencyId = newValue;
                                            });
                                          },
                                          focusNode: FocusNode(canRequestFocus: false),
                                          validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            filled: true,
                                            fillColor: kColorWhite,
                                          ),
                                          items: currencyList.map<DropdownMenuItem<int>>((dynamic value) {
                                            var jj = new JobType(id: value['id'], name: value['name']);
                                            return DropdownMenuItem<int>(
                                              value: jj.id,
                                              child: Text(value['name']),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      children: [
                                        Align(
                                            widthFactor: 10,
                                            heightFactor: 1.5,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'period'.tr().toString().toUpperCase() + '*',
                                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                            )
                                        ),
                                        DropdownButtonFormField<int>(
                                          hint: Text(
                                            "select".tr(),
                                            style: TextStyle(
                                                fontSize: 14
                                            ),
                                          ),
                                          value: _salaryPeriodId,
                                          onChanged: (int newValue) async {
                                            setState(() {
                                              _salaryPeriodId = newValue;
                                            });
                                          },
                                          focusNode: FocusNode(canRequestFocus: false),
                                          validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            filled: true,
                                            fillColor: kColorWhite,
                                          ),
                                          items: [
                                            DropdownMenuItem<int>(
                                              value: 0,
                                              child: Text('Ставка за час'),
                                            ),
                                            DropdownMenuItem<int>(
                                              value: 1,
                                              child: Text('Ставка за смену'),
                                            ),
                                            DropdownMenuItem<int>(
                                              value: 2,
                                              child: Text('В неделю'),
                                            ),
                                            DropdownMenuItem<int>(
                                              value: 3,
                                              child: Text('В месяц'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///Description
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'vacancy_description'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  TextFormField(
                                    controller: _vacancy_description_controller,
                                    maxLines: 5,
                                    focusNode: FocusNode(canRequestFocus: false),
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
                                      if (name.isEmpty) {
                                        return "please_fill_this_field".tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            /// Адрес
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'address'.tr().toString().toUpperCase(),
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  TypeAheadFormField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: _vacancyTypeAheadController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                        errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor: kColorWhite,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      print(pattern);
                                      if(pattern.length > 3) {
                                        _suggestionsAddress = await _fetchAddressSuggestions(pattern);
                                      }
                                      return _suggestionsAddress;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion['value']),
                                      );
                                    },
                                    noItemsFoundBuilder: (context) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Text(
                                          'address_not_found'.tr(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54
                                          ),
                                        ),
                                      );
                                    },
                                    transitionBuilder: (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected: (suggestion) async {
                                      _vacancyTypeAheadController.text = suggestion['value'];

                                      String region = suggestion['data']['region_with_type'];
                                      String district = suggestion['data']['city'];
                                      String street = suggestion['data']['street_with_type'];
                                      String houseNumber = suggestion['data']['house'];

                                      if(region != '' && region != null){
                                        selectedRegion = region;
                                        districtList = await Vacancy.getLists('districts', region);
                                        districtList.forEach((district) {
                                          setState(() {
                                            districts.add(district['name']);
                                            _latitude = suggestion['data']['geo_lat'];
                                            _longitude = suggestion['data']['geo_lon'];
                                          });
                                        });
                                      }

                                      if(district != '' && district != null){
                                        selectedDistrict = district;
                                      }

                                      if(street != '' && street != null){
                                        _vacancyStreetController.text = street;
                                      }

                                      if(houseNumber != '' && houseNumber != null){
                                        _vacancyHouseNumberController.text = houseNumber;
                                      }

                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Введите адрес';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _selectedCity = value,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'job_types'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("select".tr()),
                                    value: _jobTypeId,
                                    onChanged: (int newValue) {
                                      setState(() {
                                        _jobTypeId = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    items: jobTypeList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'vacancy_types'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("select".tr()),
                                    value: _vacancyTypeId,
                                    onChanged: (int newValue) {
                                      setState(() {
                                        _vacancyTypeId = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    items: vacancyTypeList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'businesses'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("select".tr()),
                                    value: _busynessId,
                                    onChanged: (int newValue) {
                                      setState(() {
                                        _busynessId = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    items: busynessList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'schedules'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("select".tr()),
                                    value: _scheduleId,
                                    onChanged: (int newValue) {
                                      setState(() {
                                        _scheduleId = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    items: scheduleList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'required_experience'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("select".tr()),
                                    value: _experienceId,
                                    onChanged: (int newValue) {
                                      setState(() {
                                        _experienceId = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    items: [
                                      DropdownMenuItem<int>(
                                        value: 0,
                                        child: Text('Без опыта'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 1,
                                        child: Text('Полгода'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 2,
                                        child: Text('Более года'),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Column(
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'payment_frequency'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("select".tr()),
                                    value: _payPeriodId,
                                    onChanged: (int newValue) {
                                      setState(() {
                                        _payPeriodId = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    items: [
                                      DropdownMenuItem<int>(
                                        value: 0,
                                        child: Text('Ежедневная'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 1,
                                        child: Text('Еженедельная'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 2,
                                        child: Text('Ежемесячная'),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.maxFinite,
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  CustomButton(
                                    borderSide: BorderSide(
                                        color: kColorPrimary,
                                        width: 2.0
                                    ),
                                    color: Colors.transparent,
                                    textColor: kColorPrimary,
                                    onPressed: () {
                                      _vacancy_name_controller = TextEditingController();
                                      _vacancy_salary_controller = TextEditingController();
                                      _vacancy_salary_from_controller = TextEditingController();
                                      _vacancy_salary_to_controller = TextEditingController();
                                      _vacancy_description_controller = TextEditingController();
                                      _vacancyTypeAheadController = TextEditingController();
                                      _vacancyStreetController = TextEditingController();
                                      _vacancyHouseNumberController = TextEditingController();

                                      setState(() {
                                        _scheduleId = null;
                                        _busynessId = null;
                                        _jobTypeId = null;
                                        _vacancyTypeId = null;
                                        _regionId = null;
                                        _districtId = null;
                                        _currencyId = null;
                                        _salaryPeriodId = null;
                                        _experienceId = null;
                                        _payPeriodId = null;
                                        _latitude = null;
                                        _longitude = null;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    text: 'cancel'.tr(),
                                  ),
                                  CustomButton(
                                    color: kColorPrimary,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (_vacancyAddFormKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                        });

                                        Vacancy company_vacancy = new Vacancy(
                                          name: _vacancy_name_controller.text,
                                          salary: _vacancy_salary_controller.text,
                                          salary_from: _vacancy_salary_from_controller.text,
                                          salary_to: _vacancy_salary_to_controller.text,
                                          currency: _currencyId != null ? _currencyId.toString() : null,
                                          period: _salaryPeriodId != null ? _salaryPeriodId.toString() : null,
                                          description: _vacancy_description_controller.text,
                                          type: _vacancyTypeId != null ? _vacancyTypeId.toString() : null,
                                          busyness: _busynessId != null ? _busynessId.toString() : null,
                                          schedule: _scheduleId != null ? _scheduleId.toString() : null,
                                          job_type: _jobTypeId != null ? _jobTypeId.toString() : null,
                                          experience: _experienceId != null ? _experienceId.toString() : null,
                                          payPeriod: _payPeriodId != null ? _payPeriodId.toString() : null,
                                          region: selectedRegion ?? null,
                                          district: selectedDistrict ?? null,
                                          // region: _regionId != null ? _regionId.toString() : null,
                                          // district: _districtId != null ? _districtId.toString() : null,
                                          address: _vacancyTypeAheadController.text,
                                          street: _vacancyStreetController.text,
                                          houseNumber: _vacancyHouseNumberController.text,
                                          latitude: _latitude,
                                          longitude: _longitude,
                                        );

                                        Vacancy.saveCompanyVacancy(vacancy: company_vacancy).then((value) {
                                          StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
                                          StoreProvider.of<AppState>(context).dispatch(getCompanyActiveVacancies());
                                          StoreProvider.of<AppState>(context).dispatch(getCompanyInactiveVacancies());
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.of(context).pop();
                                        });

                                        _vacancy_name_controller = TextEditingController();
                                        _vacancy_salary_controller = TextEditingController();
                                        _vacancy_salary_from_controller = TextEditingController();
                                        _vacancy_salary_to_controller = TextEditingController();
                                        _vacancy_description_controller = TextEditingController();
                                        _vacancyTypeAheadController = TextEditingController();
                                        _vacancyStreetController = TextEditingController();
                                        _vacancyHouseNumberController = TextEditingController();
                                        setState(() {
                                          _scheduleId = null;
                                          _busynessId = null;
                                          _jobTypeId = null;
                                          _vacancyTypeId = null;
                                          _regionId = null;
                                          _districtId = null;
                                          _currencyId = null;
                                          _salaryPeriodId = null;
                                          _experienceId = null;
                                          _payPeriodId = null;
                                          _latitude = null;
                                          _longitude = null;
                                        });
                                      } else {
                                        print('invalid');
                                      }
                                    },
                                    text: 'add'.tr(),
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
        });
  }

  @override
  void initState() {
    getLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CompanyVacanciesScreenProps>(
      converter: (store) => mapStateToVacancyProps(store),
      onInitialBuild: (props) => this.handleInitialBuildOfCompanyVacancy(props),
      builder: (context, props) {
        List<Vacancy> data = props.listResponse.data;
        bool loading = props.listResponse.loading;

        Widget body;
        if (loading) {
          body = Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else {
          body = data == null || data.isEmpty ? Container() : Column(
            children: [
              Expanded(
                child: StoreProvider.of<AppState>(context).state.vacancy.list.data !=null ?
                Container(
                  padding: EdgeInsets.all(20),
                  child: UsersGrid(
                      children: StoreProvider.of<AppState>(context).state.vacancy.list.data.map((vacancy) {
                        return GestureDetector(
                          child: VacancyCard(
                            vacancy: vacancy,
                            page: 'company',
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: kColorPrimary,
                                appBar: AppBar(
                                  title: Text("vacancy_view".tr()),
                                ),
                                body: VacancyView(
                                  page: "company_view",
                                  vacancy: vacancy,
                                ),
                              );
                            }));
                          },
                        );
                      }).toList()
                  ),
                ) :
                Center(
                  child: Text(
                    'empty'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }

        return Scaffold(
          backgroundColor: kColorPrimary,
          appBar: AppBar(
            title: Text("all_vacancies".tr()),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Boxicons.bx_plus_circle,
                  size: 25,
                  color: kColorPrimary,
                ),
                onPressed: () async {
                  await openVacancyForm(context);
                },
              )
            ],
          ),
          body: body,
        );
      },
    );
  }

  Future<List<dynamic>> _fetchAddressSuggestions(String pattern) async {
    List<dynamic> suggestions = [];
    String token = "132a62a4c888a776c87241ed9e615638651f14a8";

    if(pattern.length > 3) {
      final response = await http.post(
        Uri.parse('https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + token
        },
        body: jsonEncode(<String, String>{
          'query': pattern,
          'count': '3'
        }),
      );

      if (response.statusCode == 200) {
        Map<dynamic, dynamic> responseData = json.decode(response.body);
        for(int i = 0; i < responseData['suggestions'].length; i++) {
          suggestions.add(responseData['suggestions'][i]);
        }
      } else {
        throw Exception('Не удается найти адрес.');
      }

    }
    return suggestions;
  }
}

class CompanyVacanciesScreenProps {
  final Function getCompanyVacancies;
  final ListVacancysState listResponse;

  CompanyVacanciesScreenProps({
    this.getCompanyVacancies,
    this.listResponse,
  });
}

CompanyVacanciesScreenProps mapStateToVacancyProps(Store<AppState> store) {
  return CompanyVacanciesScreenProps(
    listResponse: store.state.vacancy.list,
    getCompanyVacancies: () => store.dispatch(getCompanyVacancies()),
  );
}