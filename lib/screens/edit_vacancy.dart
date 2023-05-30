import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/datas/Skill.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ishtapp/utils/textFormatter/lengthLimitingTextInputFormatter.dart';
import 'package:flutter/services.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum work_mode { work, training }

class EditVacancy extends StatefulWidget {
  const EditVacancy({Key key, this.vacancy, this.vacancySkill}) : super(key: key);

  final Vacancy vacancy;
  final List<VacancySkill> vacancySkill;

  @override
  _EditVacancyState createState() => _EditVacancyState();
}

class _EditVacancyState extends State<EditVacancy> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _vacancyEditFormKey = GlobalKey<FormState>();
  final courseAddFormKey = GlobalKey<FormState>();

  var data = [];
  List<String> regions = [];
  List<String> districts = [];

  List<dynamic> jobTypeList = [];
  List<dynamic> vacancyTypeList = [];
  List<dynamic> busynessList = [];
  List<dynamic> scheduleList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<dynamic> currencyList = [];

  int _job_type_id;
  int _vacancy_type_id;
  int _busyness_id;
  int _schedule_id;
  int _region_id;
  int _district_id;
  int _currency_id;
  int _salaryPeriodId;
  int _experienceId;
  int _payPeriodId;

  work_mode work;
  bool loading = false;
  bool isValid = false;
  bool is_disability_person_vacancy = false;
  int selectedCategoryIdFromFirstChip;
  int selectedCategoryIdSecondChip;

  String opportunity;
  String opportunityType;
  String selectedInternshipType;
  String opportunityDuration;
  String selectedTypeOfRecommendedLetter;
  String selectedRegion;
  String selectedDistrict;

  TextEditingController _vacancy_name_controller = TextEditingController();
  TextEditingController _vacancy_salary_from_controller = TextEditingController();
  TextEditingController _vacancy_salary_to_controller = TextEditingController();
  TextEditingController _vacancy_salary_controller = TextEditingController();
  TextEditingController _vacancy_description_controller = TextEditingController();
  TextEditingController _vacancyTypeAheadController = TextEditingController();
  TextEditingController _vacancyStreetController = TextEditingController();
  TextEditingController _vacancyHouseNumberController = TextEditingController();

  List<dynamic> _suggestionsAddress = [];
  String _selectedCity;

  String deadline;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  void _showDataPicker(context) {
    DatePicker.showDatePicker(context,
        locale: LocaleType.ru,
        minTime: DateTime.now(),
        theme: DatePickerTheme(
          headerColor: kColorPrimary,
          cancelStyle: const TextStyle(color: Colors.white, fontSize: 18),
          doneStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ), onConfirm: (date) {
      print(date);
      setState(() {
        deadline = formatter.format(date);
      });
    });
  }

  getDistrictsById(region) async {
    this.districtList = await Vacancy.getDistrictsById('districts', region);
  }

  getDistrictsByRegionName(region) async {
    districtList = [];
    districtList = await Vacancy.getLists('districts', region);
    districtList.forEach((district) {
      setState(() {
        districts.add(district['name']);
      });
    });
  }

  getLists() async {
    jobTypeList = await Vacancy.getLists('job_type', null);
    jobTypeList.forEach((item) {
      if (item['name'] == widget.vacancy.job_type) {
        setState(() {
          _job_type_id = item['id'];
        });
        return;
      }
    });
    vacancyTypeList = await Vacancy.getLists('vacancy_type', null);
    vacancyTypeList.forEach((item) {
      if (item['name'] == widget.vacancy.type) {
        setState(() {
          _vacancy_type_id = item['id'];
        });
      }
    });
    busynessList = await Vacancy.getLists('busyness', null);
    busynessList.forEach((item) {
      if (item['name'] == widget.vacancy.busyness) {
        setState(() {
          _busyness_id = item['id'];
        });
      }
    });
    scheduleList = await Vacancy.getLists('schedule', null);
    scheduleList.forEach((item) {
      if (item['name'] == widget.vacancy.schedule) {
        setState(() {
          _schedule_id = item['id'];
        });
      }
    });
    currencyList = await Vacancy.getLists('currencies', null);
    var v = widget.vacancy.currency;
    currencyList.forEach((item) {
      if (item['name'] == widget.vacancy.currency) {
        setState(() {
          _currency_id = item['id'];
        });
      }
    });
    await Vacancy.getLists('region', null).then((value) {
      regionList = value;
      value.forEach((region) {
        regions.add(region["name"]);
      });
    });
    var d = widget.vacancy.region;

    getDistrictsByRegionName(widget.vacancy.region);
  }

  //endregion

  //region styles
  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  //endregion

  void init() {
    //region vacancy
    _vacancy_name_controller.text = widget.vacancy.name;
    _vacancy_salary_controller.text = widget.vacancy.salary;
    _vacancy_salary_from_controller.text = widget.vacancy.salary_from;
    _vacancy_salary_to_controller.text = widget.vacancy.salary_to;
    _vacancy_description_controller.text = Bidi.stripHtmlIfNeeded(widget.vacancy.description);
    _vacancyTypeAheadController.text = widget.vacancy.address;

    selectedRegion = widget.vacancy.region;
    selectedDistrict = widget.vacancy.district;
    is_disability_person_vacancy = widget.vacancy.is_disability_person_vacancy == 1;

    _experienceId = int.parse(widget.vacancy.experience);
    _payPeriodId = int.parse(widget.vacancy.payPeriod);

    String _salaryPeriodString = widget.vacancy.period;
    if(_salaryPeriodString == 'Ставка за час'){
      _salaryPeriodId = 0;
    }
    if(_salaryPeriodString == 'Ставка за смену'){
      _salaryPeriodId = 1;
    }
    if(_salaryPeriodString == 'В неделю'){
      _salaryPeriodId = 2;
    }
    if(_salaryPeriodString == 'В месяц'){
      _salaryPeriodId = 3;
    }
    //endregion
  }

  @override
  void initState() {
    getLists();
    init();
    super.initState();
  }

  // getRegionId(String regionName) {
  //   regions.forEach((item) {
  //       if(item == )
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("edit".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  'work'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                )
            ),
            SizedBox(
              height: 20,
            ),

            /// Form
            Form(
              key: _vacancyEditFormKey,
              child: Column(
                children: <Widget>[
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
                                          if (name.isEmpty) {
                                            return "please_fill_this_field".tr();
                                          }
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
                                value: _currency_id,
                                onChanged: (int newValue) async {
                                  setState(() {
                                    _currency_id = newValue;
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

                  /// Сферы деятельности
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
                          value: _job_type_id,
                          onChanged: (int newValue) {
                            setState(() {
                              _job_type_id = newValue;
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

                  /// Vacancy Types
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
                          value: _vacancy_type_id,
                          onChanged: (int newValue) {
                            setState(() {
                              _vacancy_type_id = newValue;
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

                  /// Business
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
                          value: _busyness_id,
                          onChanged: (int newValue) {
                            setState(() {
                              _busyness_id = newValue;
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

                  /// Schedule
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
                          value: _schedule_id,
                          onChanged: (int newValue) {
                            setState(() {
                              _schedule_id = newValue;
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

                  /// Experience
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

                  /// Payment Freq
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
                            _vacancy_description_controller = TextEditingController();
                            _vacancyTypeAheadController = TextEditingController();
                            _vacancyStreetController = TextEditingController();
                            _vacancyHouseNumberController = TextEditingController();

                            setState(() {
                              _schedule_id = null;
                              _busyness_id = null;
                              _job_type_id = null;
                              _vacancy_type_id = null;
                              _region_id = null;
                              _district_id = null;
                              _currency_id = null;
                              _salaryPeriodId = null;
                              _experienceId = null;
                              _payPeriodId = null;
                            });
                            Navigator.of(context).pop();
                          },
                          text: 'cancel'.tr(),
                        ),
                        CustomButton(
                          color: kColorPrimary,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_vacancyEditFormKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              regionList.forEach((item) {
                                if (item['name'] == selectedRegion) {
                                  _region_id = item['id'];
                                }
                              });

                              districtList.forEach((item) {
                                if (item['name'] == selectedDistrict) {
                                  _district_id = item['id'];
                                }
                              });

                              Vacancy company_vacancy = new Vacancy(
                                id: widget.vacancy.id,
                                name: _vacancy_name_controller.text,
                                salary_from: _vacancy_salary_from_controller.text,
                                salary_to: _vacancy_salary_to_controller.text,
                                description: _vacancy_description_controller.text,
                                address: _vacancyTypeAheadController.text,
                                region: _region_id != null ? _region_id.toString() : null,
                                district: _district_id != null ? _district_id.toString() : null,
                                street: _vacancyStreetController.text,
                                houseNumber: _vacancyHouseNumberController.text,
                                type: _vacancy_type_id != null ? _vacancy_type_id.toString() : null,
                                busyness: _busyness_id != null ? _busyness_id.toString() : null,
                                schedule: _schedule_id != null ? _schedule_id.toString() : null,
                                job_type: _job_type_id != null ? _job_type_id.toString() : null,
                                currency: _currency_id != null ? _currency_id.toString() : null,
                                period: _salaryPeriodId != null ? _salaryPeriodId.toString() : null,
                                experience: _experienceId != null ? _experienceId.toString() : null,
                                payPeriod: _payPeriodId != null ? _payPeriodId.toString() : null,
                              );
                              Vacancy.saveCompanyVacancy(vacancy: company_vacancy).then((value) {
                                StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
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

                              setState(() {
                                _schedule_id = null;
                                _busyness_id = null;
                                _job_type_id = null;
                                _vacancy_type_id = null;
                                _region_id = null;
                                _district_id = null;
                                _currency_id = null;
                                _salaryPeriodId = null;
                                _experienceId = null;
                                _payPeriodId = null;
                              });
                            } else {
                              print('invalid');
                            }
                          },
                          text: 'update'.tr(),
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
