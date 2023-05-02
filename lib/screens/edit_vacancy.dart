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
import 'package:chips_choice/chips_choice.dart';
import 'package:ms_accordion/ms_accordion.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  List<String> opportunities = [];
  List<String> opportunityTypes = [];
  List<String> internshipLanguageTypes = [];
  List<String> opportunityDurations = [];
  List<String> typeOfRecommendedLetters = [];
  List<String> regions = [];
  List<String> districts = [];
  List<String> tags = [];
  List<String> tags2 = [];
  List skills = [];

  List<dynamic> jobTypeList = [];
  List<dynamic> vacancyTypeList = [];
  List<dynamic> busynessList = [];
  List<dynamic> scheduleList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<dynamic> currencyList = [];
  List<dynamic> skillList = [];

  List<VacancySkill> vacancyRequiredSkills = [];
  List<VacancySkill> vacancyCanUpgradeSkills = [];
  List<Skill> skillSets = [];

  List<Widget> categories = [];
  List<Widget> skillsV1 = [];
  List<Widget> skillsV2 = [];

  int _job_type_id;
  int _vacancy_type_id;
  int _busyness_id;
  int _schedule_id;
  int _region_id;
  int _district_id;
  int _currency_id;

  work_mode work;
  bool salary_by_agreement;
  bool by_agreement = false;
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

  TextEditingController _ageFromController = TextEditingController();
  TextEditingController _ageToController = TextEditingController();
  TextEditingController _vacancy_name_controller = TextEditingController();
  TextEditingController _vacancy_salary_from_controller = TextEditingController();
  TextEditingController _vacancy_salary_to_controller = TextEditingController();
  TextEditingController _vacancy_salary_controller = TextEditingController();
  TextEditingController _vacancy_description_controller = TextEditingController();

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

  //region Methods
  getOpportunities() async {
    var list = await Vacancy.getLists('opportunity', null);
    list.forEach((item) {
      setState(() {
        opportunities.add(item["name"]);
      });
    });
  }

  getOpportunityTypes() async {
    var list = await Vacancy.getLists('opportunity_type', null);
    list.forEach((item) {
      setState(() {
        opportunityTypes.add(item["name"]);
      });
    });
  }

  getInternshipLanguages() async {
    var list = await Vacancy.getLists('intership_language', null);
    list.forEach((item) {
      setState(() {
        internshipLanguageTypes.add(item["name"]);
      });
    });
  }

  getOpportunityDurations() async {
    var list = await Vacancy.getLists('opportunity_duration', null);
    list.forEach((item) {
      setState(() {
        opportunityDurations.add(item["name"]);
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

  getRecommendationLetterType() async {
    var list = await Vacancy.getLists('recommendation_letter_type', null);
    list.forEach((item) {
      setState(() {
        typeOfRecommendedLetters.add(item["name"]);
      });
    });
  }

  getVacancySkills(int vacancyId) async {
    await VacancySkill.getVacancySkills(vacancyId).then((value) {
      value.forEach((item) {
        if (item.isRequired) {
          vacancyRequiredSkills.add(item);
        } else {
          vacancyCanUpgradeSkills.add(item);
        }
      });
    });
  }

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
                                  // SkillCategory skillCategory = new SkillCategory();
                                  // skillCategory.saveUserSkills(listTag, 1);
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

  getSkillSetCategories() async {
    List<String> pi = [];

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
                      setState(() {
                        skillSets.forEach((item) {
                          if (item.categoryId == id) {
                            list.add(item.name);
                          }
                        });
                      });

                      vacancyRequiredSkills.forEach((item) {
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

      skillsV1.add(
        StatefulBuilder(builder: (context, setState) {
          return Column(
            children: <Widget>[
              MsAccordion(
                titleChild: Text(item["name"], style: TextStyle(fontSize: 18)),
                showAccordion: false,
                margin: const EdgeInsets.all(0),
                expandedTitleBackgroundColor: Color(0xffF2F2F5),
                titleBorderRadius: BorderRadius.circular(6),
                textStyle: TextStyle(color: kColorWhite),
                collapsedTitleBackgroundColor: Colors.white10,
                contentBackgroundColor: Colors.white,
                contentChild: Column(
                  children: <Widget>[
                    Wrap(
                      children: [
                        ChipsChoice<String>.multiple(
                          choiceStyle: C2ChoiceStyle(
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            showCheckmark: false,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          choiceActiveStyle: C2ChoiceStyle(
                            color: kColorPrimary,
                          ),
                          mainAxisSize: MainAxisSize.max,
                          padding: EdgeInsets.zero,
                          value: tags,
                          onChanged: (val) => setState(() => tags = val),
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: skills,
                            value: (i, v) {
                              setState(() => selectedCategoryIdFromFirstChip = item["id"]);
                              return v;
                            },
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
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      );

      skillsV2.add(
        StatefulBuilder(builder: (context, setState) {
          return Column(
            children: <Widget>[
              MsAccordion(
                titleChild: Text(item["name"], style: TextStyle(fontSize: 18)),
                showAccordion: false,
                margin: const EdgeInsets.all(0),
                expandedTitleBackgroundColor: Color(0xffF2F2F5),
                titleBorderRadius: BorderRadius.circular(6),
                textStyle: TextStyle(color: kColorWhite),
                collapsedTitleBackgroundColor: Colors.white10,
                contentBackgroundColor: Colors.white,
                contentChild: Column(
                  children: <Widget>[
                    Wrap(
                      children: [
                        ChipsChoice<String>.multiple(
                          choiceStyle: C2ChoiceStyle(
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            showCheckmark: false,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          choiceActiveStyle: C2ChoiceStyle(
                            color: kColorPrimary,
                          ),
                          mainAxisSize: MainAxisSize.max,
                          padding: EdgeInsets.zero,
                          value: tags2,
                          onChanged: (val) => setState(() => tags2 = val),
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: skills,
                            value: (i, v) {
                              setState(() => selectedCategoryIdSecondChip = item["id"]);
                              return v;
                            },
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
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  openSkillDialog(context, bool isRequired) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, snapshot) {
            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Навыки'.tr().toUpperCase(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
                  ),
                ),

                /// Form
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: courseAddFormKey,
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: isRequired ? skillsV1 : skillsV2,
                        ),
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
                                color: kColorPrimary,
                                textColor: Colors.white,
                                onPressed: () {
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
                ),
              ],
            );
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
    widget.vacancy.isProductLabVacancy ? work = work_mode.training : work = work_mode.work;
    // work = work_mode.work;
    //region training init

    opportunity = widget.vacancy.opportunity;
    opportunityType = widget.vacancy.opportunityType;
    selectedInternshipType = widget.vacancy.internshipLanguage;
    opportunityDuration = widget.vacancy.opportunityDuration;
    selectedTypeOfRecommendedLetter = widget.vacancy.typeOfRecommendedLetter;
    _ageFromController.text = widget.vacancy.ageFrom;
    _ageToController.text = widget.vacancy.ageTo;

    //endregion

    //region vacancy

    _vacancy_name_controller.text = widget.vacancy.name;
    _vacancy_salary_controller.text = widget.vacancy.salary;
    _vacancy_salary_from_controller.text = widget.vacancy.salary_from;
    _vacancy_salary_to_controller.text = widget.vacancy.salary_to;
    _vacancy_description_controller.text = widget.vacancy.description;

    salary_by_agreement = widget.vacancy.salary != null;
    by_agreement = widget.vacancy.salary != null && widget.vacancy.salary.toLowerCase() == 'по договоренности';

    selectedRegion = widget.vacancy.region;
    selectedDistrict = widget.vacancy.district;
    is_disability_person_vacancy = widget.vacancy.is_disability_person_vacancy == 1;
    //endregion
  }

  getVS() {
    var list = widget.vacancySkill;
    list.forEach((item) {
      if (item.isRequired)
        tags.add(item.name);
      else
        tags2.add(item.name);
    });
  }

  @override
  void initState() {
    getVS();
    getLists();
    init();
    getOpportunities();
    getOpportunityTypes();
    getInternshipLanguages();
    getOpportunityDurations();
    getRecommendationLetterType();
    getSkillSetCategories();

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
            work == work_mode.work
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      'work'.tr(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ))
                : Align(
                    alignment: Alignment.center,
                    child: Text(
                      'improve_qualification'.tr(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    )),
            SizedBox(
              height: 20,
            ),

            /// Form
            Form(
              key: _vacancyEditFormKey,
              child: Column(
                children: <Widget>[
                  /// Название возможности
                  work == work_mode.training
                      ? Column(
                    children: [
                      Align(
                          widthFactor: 10,
                          heightFactor: 1.5,
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Название возможности'.tr(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                      TextFormField(
                        controller: _vacancy_name_controller,
                        focusNode: FocusNode(canRequestFocus: false),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (name) {
                          if (name.isEmpty) {
                            return "please_fill_this_field".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20)
                    ],
                  )
                      : Container(),

                  /// Выбор возможностей
                  work == work_mode.training
                      ? Column(
                          children: <Widget>[
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'choice_opportunity_options'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              showSelectedItem: true,
                              items: opportunities,
                              onChanged: (value) {
                                setState(() {
                                  opportunity = value;
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: opportunity,
                            ),
                          ],
                        )
                      : Container(),

                  /// Вид возможности
                  work == work_mode.training
                      ? Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'opportunity_type'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              items: opportunityTypes,
                              onChanged: (value) {
                                setState(() {
                                  opportunityType = value;
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: opportunityType,
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : Container(),

                  /// Язык для стажировки
                  work == work_mode.training
                      ? Column(
                          children: <Widget>[
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'internship_language'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              items: internshipLanguageTypes,
                              onChanged: (value) {
                                setState(() {
                                  selectedInternshipType = value;
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: selectedInternshipType,
                            ),
                          ],
                        )
                      : Container(),

                  /// Продолжительность возможности
                  work == work_mode.training
                      ? Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'opportunity_duration'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              showSelectedItem: true,
                              items: opportunityDurations,
                              onChanged: (value) {
                                setState(() {
                                  opportunityDuration = value;
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: opportunityDuration,
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : Container(),

                  /// Возраст, для которого предназначена возможность
                  work == work_mode.training
                      ? Align(
                          widthFactor: 10,
                          heightFactor: 1.5,
                          alignment: Alignment.topLeft,
                          child: Text(
                            'opportunity_age'.tr(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ))
                      : Container(),
                  work == work_mode.training
                      ? Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'От',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 60,
                                child: TextFormField(
                                  controller: _ageFromController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
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
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'До',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 60,
                                child: TextFormField(
                                  controller: _ageToController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
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
                            ),
                          ],
                        )
                      : Container(),

                  /// Выбор скиллсетов для возможности
                  work == work_mode.training
                      ? Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'choose_opportunity_skill_sets'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(
                                    color: kColorPrimaryDark,
                                    onPressed: () => openSkillDialog(context, true),
                                    child: Text(
                                      "Требуется",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    )),
                                FlatButton(
                                    color: kColorPrimaryDark,
                                    onPressed: () => openSkillDialog(context, false),
                                    child: Text(
                                      "Могут развить",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    )),
                              ],
                            ),
                          ],
                        )
                      : Container(),

                  /// Готовность выдать рекомендательное письмо
                  work == work_mode.training
                      ? Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Готовность выдать рекомендательное письмо',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              showSelectedItem: true,
                              items: typeOfRecommendedLetters,
                              onChanged: (value) {
                                setState(() {
                                  selectedTypeOfRecommendedLetter = value;
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: selectedTypeOfRecommendedLetter,
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : Container(),

                  /// Название вакансии
                  work_mode.work == work
                      ? Column(
                          children: [
                            Align(
                                widthFactor: 10,
                                heightFactor: 1.5,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'vacancy_name'.tr(),
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                )),
                            TextFormField(
                              controller: _vacancy_name_controller,
                              focusNode: FocusNode(canRequestFocus: false),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (name) {
                                if (name.isEmpty) {
                                  return "please_fill_this_field".tr();
                                }
                                return null;
                              },
                            ),
                          ],
                        )
                      : Container(),

                  /// Salary
                  work == work_mode.work
                      ? Column(
                          children: [
                            SizedBox(height: 20),
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'vacancy_salary'.tr(),
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      )),
                                ),
                              ],
                            ),
                            salary_by_agreement
                                ? DropdownButtonFormField<int>(
                                    hint: Text("currency".tr()),
                                    value: _currency_id,
                                    onChanged: (int newValue) async {
                                      setState(() {
                                        _currency_id = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    items: currencyList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  )
                                : DropdownButtonFormField<int>(
                                    hint: Text("currency".tr()),
                                    value: _currency_id,
                                    onChanged: (int newValue) async {
                                      setState(() {
                                        _currency_id = newValue;
                                      });
                                    },
                                    focusNode: FocusNode(canRequestFocus: false),
                                    validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    items: currencyList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ),
                            SizedBox(height: 20),
                            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(
                                // optional flex property if flex is 1 because the default flex is 1
                                flex: 1,
                                child: salary_by_agreement
                                    ? TextFormField(
                                        controller: _vacancy_salary_from_controller,
                                        focusNode: FocusNode(canRequestFocus: false),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                        ),
                                        inputFormatters: [Utf8LengthLimitingTextInputFormatter(20)],
                                        validator: (name) {
                                          return null;
                                        },
                                      )
                                    : TextFormField(
                                        controller: _vacancy_salary_from_controller,
                                        focusNode: FocusNode(canRequestFocus: false),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          filled: true,
                                          fillColor: Colors.grey[200],
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
                                child: salary_by_agreement
                                    ? TextFormField(
                                        controller: _vacancy_salary_to_controller,
                                        focusNode: FocusNode(canRequestFocus: false),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                        ),
                                        inputFormatters: [Utf8LengthLimitingTextInputFormatter(20)],
                                        validator: (name) {
                                          return null;
                                        },
                                      )
                                    : TextFormField(
                                        controller: _vacancy_salary_to_controller,
                                        focusNode: FocusNode(canRequestFocus: false),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          filled: true,
                                          fillColor: Colors.grey[200],
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
                            ]),
                            SizedBox(height: 20),
                            CustomButton(
                              width: MediaQuery.of(context).size.width * 1,
                              padding: EdgeInsets.all(10),
                              color: by_agreement ? kColorPrimary : Colors.grey[200],
                              textColor: by_agreement ? Colors.white : kColorPrimary,
                              onPressed: () {
                                setState(() {
                                  by_agreement = !by_agreement;
                                });
                                by_agreement
                                    ? _vacancy_salary_controller.text = 'По договоренности'
                                    : _vacancy_salary_controller = TextEditingController();
                              },
                              text: 'by_agreement'.tr(),
                            ),
                          ],
                        )
                      : Container(),

                  work == work_mode.training
                      ? Container()
                      : Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Align(
                                widthFactor: 10,
                                heightFactor: 1.5,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'vacancy_description'.tr(),
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                )),
                            TextFormField(
                              controller: _vacancy_description_controller,
                              maxLines: 5,
                              focusNode: FocusNode(canRequestFocus: false),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: Colors.grey[200],
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

                  /// Область
                  work == work_mode.work
                      ? Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'region'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              showSelectedItem: true,
                              items: regions,
                              onChanged: (value) {
                                setState(() {
                                  selectedRegion = value;
                                  selectedDistrict = "";
                                  districts = [];
                                });
                                getDistrictsByRegionName(value);
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: selectedRegion,
                            )
                          ],
                        )
                      : Container(),
                  work == work_mode.work ? SizedBox(height: 20) : Container(),

                  /// Район
                  work == work_mode.work
                      ? Column(
                          children: <Widget>[
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'district'.tr(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            DropdownSearch<String>(
                              showSelectedItem: true,
                              items: districts,
                              onChanged: (value) {
                                setState(() {
                                  selectedDistrict = value;
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                              selectedItem: selectedDistrict,
                            )
                          ],
                        )
                      : Container(),

                  /// Сферы деятельности ishtapp
                  work == work_mode.work
                      ? Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              isExpanded: true,
                              hint: Text("job_types".tr()),
                              value: _job_type_id,
                              onChanged: (int newValue) {
                                setState(() {
                                  _job_type_id = newValue;
                                });
                              },
                              focusNode: FocusNode(canRequestFocus: false),
                              validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              items: jobTypeList.map<DropdownMenuItem<int>>((dynamic value) {
                                var jj = new JobType(id: value['id'], name: value['name']);
                                return DropdownMenuItem<int>(
                                  value: jj.id,
                                  child: Text(value['name']),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              isExpanded: true,
                              hint: Text("vacancy_types".tr()),
                              value: _vacancy_type_id,
                              onChanged: (int newValue) {
                                setState(() {
                                  _vacancy_type_id = newValue;
                                });
                              },
                              focusNode: FocusNode(canRequestFocus: false),
                              validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              items: vacancyTypeList.map<DropdownMenuItem<int>>((dynamic value) {
                                var jj = new JobType(id: value['id'], name: value['name']);
                                return DropdownMenuItem<int>(
                                  value: jj.id,
                                  child: Text(value['name']),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              isExpanded: true,
                              hint: Text("businesses".tr()),
                              value: _busyness_id,
                              onChanged: (int newValue) {
                                setState(() {
                                  _busyness_id = newValue;
                                });
                              },
                              focusNode: FocusNode(canRequestFocus: false),
                              validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              items: busynessList.map<DropdownMenuItem<int>>((dynamic value) {
                                var jj = new JobType(id: value['id'], name: value['name']);
                                return DropdownMenuItem<int>(
                                  value: jj.id,
                                  child: Text(value['name']),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              isExpanded: true,
                              hint: Text("schedules".tr()),
                              value: _schedule_id,
                              onChanged: (int newValue) {
                                setState(() {
                                  _schedule_id = newValue;
                                });
                              },
                              focusNode: FocusNode(canRequestFocus: false),
                              validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
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
                        )
                      : Container(),

                  Prefs.getString(Prefs.ROUTE) == 'COMPANY' && widget.vacancy.isProductLabVacancy
                      ? Column(
                    children: <Widget>[
                      Align(
                          widthFactor: 10,
                          heightFactor: 1.5,
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Дополнительная информация'.tr(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                      TextFormField(
                        controller: _vacancy_description_controller,
                        maxLines: 5,
                        focusNode: FocusNode(canRequestFocus: false),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (name) {
                          if (name.isEmpty) {
                            return "please_fill_this_field".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20)
                    ],
                  )
                      : SizedBox(),

                  Prefs.getString(Prefs.ROUTE) == 'COMPANY'
                      ? Column(
                          children: <Widget>[
                            FlatButton(
                              color: kColorPrimaryDark,
                              onPressed: () => _showDataPicker(context),
                              child: Text(
                                'Укажите дату дедлайна',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20)
                          ],
                        )
                      : Container(),

                  work == work_mode.work ? SizedBox(height: 20) : Container(),
                  work == work_mode.work
                      ? CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'for_disabilities_people'.tr(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: is_disability_person_vacancy,
                          onChanged: (value) {
                            setState(() {
                              is_disability_person_vacancy = value;
                            });
                          },
                        )
                      : Container(),
                  work == work_mode.work ? SizedBox(height: 20) : Container(),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(10),
                          color: Colors.grey[200],
                          textColor: kColorPrimary,
                          onPressed: () {
                            setState(() {
                              _schedule_id = null;
                              _busyness_id = null;
                              _job_type_id = null;
                              _vacancy_type_id = null;
                              _region_id = null;
                              _district_id = null;
                            });
                            Navigator.of(context).pop();
                          },
                          text: 'cancel'.tr(),
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(10),
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
                                is_disability_person_vacancy: is_disability_person_vacancy ? 1 : 0,
                                description: _vacancy_description_controller.text,
                                type: _vacancy_type_id != null ? _vacancy_type_id.toString() : null,
                                busyness: _busyness_id != null ? _busyness_id.toString() : null,
                                schedule: _schedule_id != null ? _schedule_id.toString() : null,
                                job_type: _job_type_id != null ? _job_type_id.toString() : null,
                                region: _region_id != null ? _region_id.toString() : null,
                                district: _district_id != null ? _district_id.toString() : null,
                                currency: _currency_id != null ? _currency_id.toString() : null,
                                opportunity: opportunity,
                                opportunityType: opportunityType,
                                opportunityDuration: opportunityDuration,
                                internshipLanguage: selectedInternshipType,
                                typeOfRecommendedLetter: selectedTypeOfRecommendedLetter,
                                ageFrom: _ageFromController.text,
                                ageTo: _ageToController.text,
                                isProductLabVacancy: work_mode.training == work,
                                deadline: deadline,
                              );
                              SkillCategory skillCategory = new SkillCategory();
                              Vacancy.saveCompanyVacancy(vacancy: company_vacancy).then((value) {
                                if (work == work_mode.training) {
                                  skillCategory.saveVacancySkills(tags, selectedCategoryIdFromFirstChip, value, true);
                                  skillCategory
                                      .saveVacancySkills(tags2, selectedCategoryIdSecondChip, value, false)
                                      .then((value) {
                                    StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.of(context).pop();
                                }
                              });

                              _vacancy_name_controller = TextEditingController();
                              _vacancy_salary_controller = TextEditingController();
                              _vacancy_salary_from_controller = TextEditingController();
                              _vacancy_salary_to_controller = TextEditingController();
                              _vacancy_description_controller = TextEditingController();
                              _ageFromController = TextEditingController();
                              _ageToController = TextEditingController();
                              setState(() {
                                _schedule_id = null;
                                _busyness_id = null;
                                _job_type_id = null;
                                _vacancy_type_id = null;
                                _region_id = null;
                                _district_id = null;
                                _currency_id = null;
                                opportunity = null;
                                opportunityType = null;
                                opportunityDuration = null;
                                selectedInternshipType = null;
                                selectedTypeOfRecommendedLetter = null;
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
}
