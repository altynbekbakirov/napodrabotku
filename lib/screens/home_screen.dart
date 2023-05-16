import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/screens/tabs/school_tab.dart';
import 'package:ishtapp/screens/tabs/vacancies_tab.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ishtapp/widgets/cicle_button.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/screens/tabs/conversations_tab.dart';
import 'package:ishtapp/screens/tabs/discover_tab.dart';
import 'package:ishtapp/screens/tabs/matches_tab.dart';
import 'package:ishtapp/screens/tabs/profile_tab.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/widgets/badge.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/utils/textFormatter/lengthLimitingTextInputFormatter.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ishtapp/datas/Skill.dart';
import 'package:ms_accordion/ms_accordion.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ishtapp/constants/configs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

enum work_mode { isWork, isTraining }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //region Variables
  final _formKey = GlobalKey<FormState>();
  final courseAddFormKey = GlobalKey<FormState>();
  final _vacancyAddFormKey = GlobalKey<FormState>();
  List<String> selectedJobTypeChoices = List();
  List<String> selectedVacancyTypeChoices = List();
  List<String> selectedBusynessChoices = List();
  List<String> selectedScheduleChoices = List();

  List<dynamic> jobTypeList = [];
  List<dynamic> vacancyTypeList = [];
  List<dynamic> busynessList = [];
  List<dynamic> scheduleList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<dynamic> currencyList = [];
  List<dynamic> skillList = [];

  List<String> regions = [];
  List<String> districts = [];
  List<String> jobs = [];
  List<String> departments = [];
  List<String> socialOrientations = [];
  List<String> opportunities = [];
  List<String> opportunityTypes = [];
  List<String> opportunityDurations = [];
  List<String> internshipLanguageTypes = [];
  List<String> typeOfRecommendedLetters = [];

  List _jobTypes = [];
  List _vacancyTypes = [];
  List _businesses = [];
  List _schedules = [];
  List _regions = [];
  List _districts = [];
  List _currencies = [];
  List spheres = [];
  List skills = [];
  List<String> selectedVacancySkills = [];

  String selectedRegion;
  String selectedDistrict;
  String selectedJobType;
  String selectedDepartment;
  String socialOrientation;
  String opportunity;
  String opportunityType;
  String opportunityDuration;
  String selectedInternshipType;
  String selectedTypeOfRecommendedLetter;

  int _jobTypeId;
  int _vacancyTypeId;
  int _busynessId;
  int _scheduleId;
  int _regionId;
  int _districtId;
  int _currencyId;
  bool loading = false;
  work_mode work = work_mode.isWork;

  JobType vacancyRegion = new JobType(id: 1, name: 'Бишкек');
  int c = 0;

  DateTime currentBackPressTime;

  var myGroup = AutoSizeGroup();
  List<Widget> categories = [];
  List<Widget> skillsV1 = [];
  List<Widget> skillsV2 = [];
  List<String> tags = [];
  List<String> tags2 = [];
  bool isRequiredSkill = false;
  bool isUpgradableSkill = true;
  int selectedCategoryIdFromFirstChip;
  int selectedCategoryIdSecondChip;

  List<Skill> skillSets = [];
  List<String> categorySkills = [];
  List<VacancySkill> vacancyRequiredSkills = [];
  List<VacancySkill> vacancyCanUpgradeSkills = [];

  TextEditingController _vacancy_name_controller = TextEditingController();
  TextEditingController _vacancy_salary_controller = TextEditingController();
  TextEditingController _vacancy_salary_from_controller = TextEditingController();
  TextEditingController _vacancy_salary_to_controller = TextEditingController();
  TextEditingController _vacancy_description_controller = TextEditingController();
  TextEditingController _vacancy_link_controller = TextEditingController();
  TextEditingController _ageFromController = TextEditingController();
  TextEditingController _ageToController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'KG');

  bool isValid = false;
  bool isDisabilityPersonVacancy = false;
  bool salaryByAgreement;
  Users user;
  String deadline;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  final _pageController = new PageController();
  int _tabCurrentIndex = 0;
  var discoverPage = DiscoverTab();

  List<Widget> appBarTitles = [];

  bool isProfile = false;
  bool isSpecial = false;
  Timer timer;
  int receivedMessageCount = 0;

  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  getSkillSets() async {
    var list = await Vacancy.getLists('skillset', null);
    list.forEach((item) {
      skillSets.add(Skill(id: item["id"], name: item["name"], categoryId: item["category_id"]));
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
                      child: Text(categoryName.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
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
                                color: kColorPrimary,
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
                    color: kColorPrimary,
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
                    child: Text('skills'.tr().toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kColorDarkBlue)),
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

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(context, msg: 'click_once_to_exit'.tr());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('click_once_to_exit'.tr())));
      return Future.value(false);
    }
    return Future.value(true);
  }

  getSkills() {
    setState(() {
      this.skillList = [
        {'id': 1, 'name': "Ученые и исследователи экологического топлива"},
        {
          'id': 2,
          'name': "Анализ жизненного цикла: стоимость, социальные и экологические аспекты",
        },
        {
          'id': 3,
          'name': "Сотрудничество (онлайн и офлайн)",
        },
        {
          'id': 4,
          'name': "Менеджер по вопросам обеспечения бесперебойного функционирования: восстановление операций/работы после сбоя",
        },
        {
          'id': 5,
          'name': "Мета-программирование",
        },
        {
          'id': 6,
          'name': "Навыки AR / VR / MR (использование / дизайн / инжинерия)",
        },
        {
          'id': 7,
          'name': "Проектирование систем блокчейн",
        },
        {
          'id': 8,
          'name': "Дизайн и интеграция робототехники",
        },
        {
          'id': 9,
          'name': "Роли в квантовых вычислениях",
        },
      ];
    });
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

  getFilters(id) async {
    _jobTypes = await Users.getFilters('activities', id);
    _vacancyTypes = await Users.getFilters('types', id);
    _businesses = await Users.getFilters('busyness', id);
    _schedules = await Users.getFilters('schedules', id);
    _regions = await Users.getFilters('regions', id);
    // _districts = await User.getFilters('districts', id);
  }

  getDistrictsById(region) async {
    this.districtList = await Vacancy.getDistrictsById('districts', region);
  }

  getDistrictsByRegionName(region) async {
    districts.clear();
    districtList = await Vacancy.getLists('districts', region);
    districtList.forEach((district) {
      setState(() {
        districts.add(district['name']);
      });
    });
  }

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

  getOpportunityDurations() async {
    var list = await Vacancy.getLists('opportunity_duration', null);
    list.forEach((item) {
      setState(() {
        opportunityDurations.add(item["name"]);
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

  getRecommendationLetterType() async {
    var list = await Vacancy.getLists('recommendation_letter_type', null);
    list.forEach((item) {
      setState(() {
        typeOfRecommendedLetters.add(item["name"]);
      });
    });
  }

  selectDepartments(String jobType) {
    setState(() {
      selectedDepartment = null;
    });
    spheres.forEach((item) {
      if (item["jobType"] == jobType) {
        setState(() {
          departments = item["departments"];
        });
      }
    });
  }

  void _deactivateVacancyWithOverDeadline() async {
    Vacancy.deactivateVacancyWithOverDeadline();
  }

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

  Future<void> openFilterDialog(context) async {
    user = StoreProvider.of<AppState>(context).state.user.user.data;

    if (user != null) {
      getFilters(user.id);
    }

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'search_filter'.tr(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          )),
                      SizedBox(
                        height: 30,
                      ),

                      /// Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'region'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: regionList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _regions,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _regions = value;
                                });
                              },
                            ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'job_types'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: jobTypeList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _jobTypes,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _jobTypes = value;
                                });
                              },
                            ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'vacancy_types'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: vacancyTypeList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _vacancyTypes,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _vacancyTypes = value;
                                });
                              },
                            ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'businesses'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: busynessList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _businesses,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _businesses = value;
                                });
                              },
                            ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'schedules'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: scheduleList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _schedules,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _schedules = value;
                                });
                              },
                            ),
                            SizedBox(height: 30),

                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CustomButton(
                                    borderSide: BorderSide(
                                        color: kColorPrimary,
                                        width: 2.0
                                    ),
                                    color: Colors.transparent,
                                    textColor: kColorPrimary,
                                    onPressed: () {

                                      setState(() {
                                        _regionId = null;
                                        _regions = [];
                                        _districts = [];
                                        _jobTypes = [];
                                        _vacancyTypes = [];
                                        _businesses = [];
                                        _schedules = [];
                                      });

                                      if (user != null) {
                                        user.saveFilters(_regions, _districts, _jobTypes, _vacancyTypes, _businesses, _schedules);
                                      }

                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                          schedule_ids: _schedules,
                                          busyness_ids: _businesses,
                                          region_ids: [_regionId],
                                          district_ids: _districts,
                                          vacancy_type_ids: _vacancyTypes,
                                          job_type_ids: _jobTypes)
                                      );

                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());

                                      Navigator.of(context).pop();
                                      _nextTab(0);
                                    },
                                    text: 'reset'.tr(),
                                  ),
                                  CustomButton(
                                    color: kColorPrimary,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (user != null) {
                                        user.saveFilters(_regions, _districts, _jobTypes, _vacancyTypes, _businesses, _schedules);
                                      }
                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                          schedule_ids: _schedules,
                                          busyness_ids: _businesses,
                                          region_ids: [_regionId],
                                          district_ids: _districts,
                                          vacancy_type_ids: _vacancyTypes,
                                          job_type_ids: _jobTypes)
                                      );
                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                      Navigator.of(context).pop();
                                      _nextTab(0);
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
        });
  }

  Future<void> openVacancyForm(context) async {
    _jobTypeId = null;
    _vacancyTypeId = null;
    _busynessId = null;
    _scheduleId = null;
    _regionId = null;
    _districtId = null;
    _currencyId = null;

    salaryByAgreement = false;

    getSkills();
    print(skillList);

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
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              'add'.tr(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            )
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'fill_all_fields'.tr(),
                              style: TextStyle(fontSize: 14, color: kColorPrimary),
                            )
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        /// Form
                        Form(
                          key: _vacancyAddFormKey,
                          child: Column(
                            children: <Widget>[
                              /// Название вакансии
                              work_mode.isWork == work ?
                              Column(
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
                              ) : Container(),

                              /// Salary
                              work == work_mode.isWork ?
                              Column(
                                children: [
                                  SizedBox(height: 20),
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'vacancy_salary'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  salaryByAgreement ?
                                  DropdownButtonFormField<int>(
                                    hint: Text("currency".tr()),
                                    value: _currencyId,
                                    onChanged: (int newValue) async {
                                      setState(() {
                                        _currencyId = newValue;
                                      });
                                    },
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
                                    items: currencyList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value['id'], name: value['name']);
                                      return DropdownMenuItem<int>(
                                        value: jj.id,
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ) :
                                  DropdownButtonFormField<int>(
                                          hint: Text("currency".tr()),
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
                                  SizedBox(height: 20),
                                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: salaryByAgreement
                                          ? TextFormField(
                                              enabled: false,
                                              controller: _vacancy_salary_from_controller,
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
                                              inputFormatters: [Utf8LengthLimitingTextInputFormatter(20)],
                                              validator: (name) {
                                                return null;
                                              },
                                            )
                                          : TextFormField(
                                              controller: _vacancy_salary_from_controller,
                                              keyboardType: TextInputType.number,
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
                                      child: Text('-'),
                                    ),
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: salaryByAgreement
                                          ? TextFormField(
                                              enabled: false,
                                              controller: _vacancy_salary_to_controller,
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
                                              inputFormatters: [Utf8LengthLimitingTextInputFormatter(20)],
                                              validator: (name) {
                                                return null;
                                              },
                                            )
                                          : TextFormField(
                                              controller: _vacancy_salary_to_controller,
                                              keyboardType: TextInputType.number,
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
                                    borderSide: BorderSide(
                                        color: kColorPrimary,
                                        width: 2.0
                                    ),
                                    padding: EdgeInsets.all(0),
                                    color: salaryByAgreement ? kColorPrimary : Colors.transparent,
                                    textColor: salaryByAgreement ? Colors.white : kColorPrimary,
                                    onPressed: () {
                                      setState(() {
                                        salaryByAgreement = !salaryByAgreement;
                                      });
                                      salaryByAgreement ? _vacancy_salary_controller.text = 'По договоренности' : TextEditingController();
                                    },
                                    text: 'by_agreement'.tr(),
                                  ),
                                ],
                              ) : Container(),

                              ///Description
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
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

                              /// Область
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'region'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  DropdownSearch<String>(
                                    showSelectedItem: true,
                                    items: regions,
                                    onChanged: (value) {
                                      getDistrictsByRegionName(value);
                                      setState(() {
                                        selectedRegion = value;
                                      });
                                    },
                                    dropdownSearchDecoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    selectedItem: selectedRegion,
                                  )
                                ],
                              ),
                              SizedBox(height: 20),

                              /// Район
                              Column(
                                children: <Widget>[
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'district'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
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
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                      errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: kColorWhite,
                                    ),
                                    selectedItem: selectedDistrict,
                                  )
                                ],
                              ),

                              /// Сферы деятельности
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("job_types".tr() + '*'),
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
                                  SizedBox(height: 20),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("vacancy_types".tr() + '*'),
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
                                  SizedBox(height: 20),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("businesses".tr() + '*'),
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
                                  SizedBox(height: 20),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    hint: Text("schedules".tr() + '*'),
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
                                  SizedBox(height: 20),
                                ],
                              ),

                              Column(
                                children: <Widget>[
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'link'.tr().toString().toUpperCase() + '*',
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  TextFormField(
                                    controller: _vacancy_link_controller,
                                    focusNode: FocusNode(canRequestFocus: false),
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
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),


                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'for_disabilities_people'.tr(),
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: isDisabilityPersonVacancy,
                                onChanged: (value) {
                                  setState(() {
                                    isDisabilityPersonVacancy = value;
                                  });
                                },
                              ),
                              SizedBox(height: 20),

                              SizedBox(
                                width: double.maxFinite,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomButton(
                                      borderSide: BorderSide(
                                          color: kColorPrimary,
                                          width: 2.0
                                      ),
                                      color: Colors.transparent,
                                      textColor: kColorPrimary,
                                      onPressed: () {
                                        setState(() {
                                          _scheduleId = null;
                                          _busynessId = null;
                                          _jobTypeId = null;
                                          _vacancyTypeId = null;
                                          _regionId = null;
                                          _districtId = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      text: 'cancel'.tr(),
                                    ),
                                    CustomButton(
                                      color: kColorPrimary,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        var linkResultSubstring = "";
                                        if (_vacancyAddFormKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });

                                          if (_vacancy_link_controller != null && _vacancy_link_controller.text.isNotEmpty) {
                                            var vacancySubstring = _vacancy_link_controller.text.substring(0, 4);
                                            if (vacancySubstring != "http") {
                                              linkResultSubstring = 'http://${_vacancy_link_controller.text}';
                                            } else {
                                              linkResultSubstring = _vacancy_link_controller.text;
                                            }
                                          } else {
                                            linkResultSubstring = "";
                                          }

                                          Vacancy company_vacancy = new Vacancy(
                                            name: _vacancy_name_controller.text,
                                            salary: _vacancy_salary_controller.text,
                                            salary_from: _vacancy_salary_from_controller.text,
                                            salary_to: _vacancy_salary_to_controller.text,
                                            is_disability_person_vacancy: isDisabilityPersonVacancy ? 1 : 0,
                                            description: _vacancy_description_controller.text,
                                            type: _vacancyTypeId != null ? _vacancyTypeId.toString() : null,
                                            busyness: _busynessId != null ? _busynessId.toString() : null,
                                            schedule: _scheduleId != null ? _scheduleId.toString() : null,
                                            job_type: _jobTypeId != null ? _jobTypeId.toString() : null,
                                            region: _regionId != null ? _regionId.toString() : null,
                                            district: _districtId != null ? _districtId.toString() : null,
                                            currency: _currencyId != null ? _currencyId.toString() : null,
                                            opportunity: opportunity,
                                            opportunityType: opportunityType,
                                            opportunityDuration: opportunityDuration,
                                            internshipLanguage: selectedInternshipType,
                                            typeOfRecommendedLetter: selectedTypeOfRecommendedLetter,
                                            ageFrom: _ageFromController.text,
                                            ageTo: _ageToController.text,
                                            isProductLabVacancy: work_mode.isTraining == work,
                                            vacancyLink: linkResultSubstring,
                                            deadline: deadline,
                                          );
                                          SkillCategory skillCategory = new SkillCategory();
                                          Vacancy.saveCompanyVacancy(vacancy: company_vacancy).then((value) {
                                            if (work == work_mode.isTraining) {
                                              skillCategory.saveVacancySkills(tags, selectedCategoryIdFromFirstChip, value, true);
                                              skillCategory.saveVacancySkills(tags2, selectedCategoryIdSecondChip, value, false).then((value) {
                                                StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
                                                setState(() {
                                                  loading = false;
                                                });
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
                                          _vacancy_link_controller = TextEditingController();
                                          setState(() {
                                            deadline = null;
                                            _scheduleId = null;
                                            _busynessId = null;
                                            _jobTypeId = null;
                                            _vacancyTypeId = null;
                                            _regionId = null;
                                            _districtId = null;
                                            _currencyId = null;
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

  void _nextTab(int tabIndex, {isProfile = false}) {
    // Update tab index
    setState(() => _tabCurrentIndex = tabIndex);
    setState(() => isProfile = true);
    // Update page index
    _pageController.animateToPage(tabIndex, duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  buildSome(BuildContext context) {
    appBarTitles = [
      Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Align(
              child: Container(
                // height: 20.0,
                child: Image.asset(
                  'assets/images/logo_white.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                GestureDetector(
                  child: CircleButton(
                      bgColor: Colors.transparent,
                      padding: 12,
                      icon: Icon(
                        Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? Boxicons.bxs_plus_square : Boxicons.bx_filter,
                        color: Colors.white,
                        size: 35,
                      )),
                  onTap: () async {
                    Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? await openVacancyForm(context) : await openFilterDialog(context);
                  },
                ),
                GestureDetector(
                  child: CircleButton(
                    bgColor: Colors.transparent,
                    padding: 12,
                    icon: Icon(
                      Boxicons.bx_user,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  onTap: () {
                    _nextTab(4);
                    setState(() {
                      isProfile = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('matches'.tr(), style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600)),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: Colors.white,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                isProfile = true;
              });
            },
          ),
        ],
      ),

      Prefs.getString(Prefs.ROUTE) == 'COMPANY' ?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'chat'.tr(),
            /*style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)*/
          ),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: kColorPrimary,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                isProfile = true;
              });
            },
          ),
        ],
      ) :
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('my_responses'.tr(), style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600)),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: Colors.white,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                isProfile = true;
              });
            },
          ),
        ],
      ),

      Prefs.getString(Prefs.ROUTE) == 'COMPANY' ?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'training'.tr(),
          ),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: kColorPrimary,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                isProfile = true;
              });
            },
          ),
        ],
      ) :
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'chat'.tr(),
          ),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: kColorPrimary,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                isProfile = true;
              });
            },
          ),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('profile'.tr(), style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    ];
  }

  @override
  void initState() {
    if (Prefs.getString(Prefs.ROUTE) == 'COMPANY') {
      _deactivateVacancyWithOverDeadline();
    }
    getSkillSetCategories();
    getLists();
    getOpportunities();
    getOpportunityTypes();
    getOpportunityDurations();
    getRecommendationLetterType();
    getInternshipLanguages();
    buildSome(context);
    if (Prefs.getString(Prefs.ROUTE) == 'COMPANY') {
      startTimerToCheckNewMessages(timer: timer, duration: Duration(minutes: 10));
    }
    super.initState();
  }

  void startTimerToCheckNewMessages({Timer timer, Duration duration}) {
    timer = Timer.periodic(duration, (Timer t) => checkForNewMessage());
    if (Prefs.getString(Prefs.ROUTE) != "COMPANY") {
      if (timer.isActive) {
        cancelTimer(timer);
      }
    }
  }

  void cancelTimer(Timer timer) {
    timer.cancel();
  }

  void checkForNewMessage() async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSettings, onSelectNotification: selectNotification);

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": Prefs.getString(Prefs.TOKEN)};

    var uri = Uri.parse(API_IP + API_MESSAGE_CHECK);
    await http.post(uri, headers: headers, body: json.encode({"created_message_date": Prefs.getString(Prefs.MESSAGEDATE)})).then((value) {
      var convert = json.decode(value.body);
      print(convert);
      Prefs.setString(Prefs.MESSAGEDATE, convert['created_at']);
      if (convert["is_exist"]) {
        setState(() {
          receivedMessageCount = convert["count"];
        });
        showNotification("Уведомления", flp);
      }

      return convert;
    });
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    print("HHHHHHHHHHHHHHHHHH");
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => (payload)),
    // );
  }

  void showNotification(v, flp) async {
    var android = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION', priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flp.show(0, 'Посмотрите уведомления от Ishtapp', '$v', platform, payload: 'VIS \n $v');
  }

  void handleInitialBuild(VacanciesScreenProps props) {
    props.getLikedNumOfVacancies();
    props.getSubmittedNumOfVacancies();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VacanciesScreenProps>(
        converter: (store) => mapStateToProps(store),
        onInitialBuild: (props) => this.handleInitialBuild(props),
        builder: (context, props) {

          return Scaffold(
            backgroundColor: isProfile ? kColorWhite : kColorPrimary,
            appBar: isSpecial
                ? AppBar(
                    automaticallyImplyLeading: false,
                    title: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: appBarTitles[_tabCurrentIndex],
                    ),
                  )
                : AppBar(
                    backgroundColor: isProfile ? kColorWhite : kColorPrimary,
                    elevation: 0,
                    toolbarHeight: 80,
                    automaticallyImplyLeading: false,
                    title: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: appBarTitles[_tabCurrentIndex],
                    ),
                    actions: [],
                  ),
            bottomNavigationBar: ClipRRect(
              child: BottomNavigationBar(
                  iconSize: 25,
                  type: BottomNavigationBarType.fixed,
                  elevation: Platform.isIOS ? 0 : 8,
                  selectedItemColor: Colors.grey[600],
                  selectedFontSize: _tabCurrentIndex == 4 ? 13 : 14,
                  currentIndex: _tabCurrentIndex == 4 ? 0 : _tabCurrentIndex,
                  onTap: (index) {
                    if (index == 1) {
                      setState(() {
                        receivedMessageCount = 0;
                      });
                    }
                    _nextTab(index);
                    if(Prefs.getString(Prefs.USER_TYPE) == 'COMPANY'){
                      if (index == 3 || index == 2) {
                        setState(() {
                          isSpecial = true;
                          isProfile = true;
                        });
                      } else {
                        setState(() {
                          isSpecial = false;
                          isProfile = false;
                        });
                      }
                    } else {
                      if (index == 3) {
                        setState(() {
                          isSpecial = true;
                          isProfile = true;
                        });
                      } else {
                        setState(() {
                          isSpecial = false;
                          isProfile = false;
                        });
                      }
                    }
                  },
                  items: [
                    Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                    BottomNavigationBarItem(
                      icon: Icon(
                        Boxicons.bx_home,
                        color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey,
                      ),
                      title: Text(
                        "home".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey),
                      )
                    ) :
                    BottomNavigationBarItem(
                      icon: Icon(
                        Boxicons.bx_search,
                        color: _tabCurrentIndex == 0 ? kColorPrimary : null,
                      ),
                      title: Text(
                        "search".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey),
                      )
                    ),

                    Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                    BottomNavigationBarItem(
                      icon: Container(
                        width: 50,
                        height: 30,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: receivedMessageCount > 0 ? null : 0.0,
                              child: Icon(
                                Boxicons.bx_folder,
                                color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey,
                              ),
                            ),
                            receivedMessageCount > 0
                                ? Positioned(
                                    top: 0.0,
                                    right: 0.0,
                                    child: Badge(
                                      text: receivedMessageCount.toString(),
                                    ))
                                : Container(),
                          ],
                        ),
                      ),
                      title: Text(
                        "received".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey),
                      )
                    ) :
                    BottomNavigationBarItem(
                            icon: Icon(
                              Boxicons.bx_heart,
                              color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey,
                            ),
                            title: Text(
                              "matches".tr(),
                              style: TextStyle(color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey),
                            )
                    ),

                    Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                    BottomNavigationBarItem(
                            icon: Icon(
                              Boxicons.bx_comment_detail,
                              color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey,
                            ),
                            title: Text(
                              "chat".tr(),
                              style: TextStyle(color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey),
                            )
                    ) :
                    BottomNavigationBarItem(
                            icon: Icon(
                              Boxicons.bx_file,
                              color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey,
                            ),
                            title: Text(
                              "my_responses".tr(),
                              style: TextStyle(color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey),
                            )
                    ),

                    Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                    BottomNavigationBarItem(
                            icon: Icon(
                              Boxicons.bx_book,
                              color: _tabCurrentIndex == 3 ? kColorPrimary : Colors.grey,
                            ),
                            title: Text(
                              "training".tr(),
                              style: TextStyle(color: _tabCurrentIndex == 3 ? kColorPrimary : Colors.grey),
                            )
                    ) :
                    BottomNavigationBarItem(
                            icon: Icon(
                              Boxicons.bx_comment_detail,
                              color: _tabCurrentIndex == 3 ? kColorPrimary : Colors.grey,
                            ),
                            title: Text(
                              "chat".tr(),
                              style: TextStyle(color: _tabCurrentIndex == 3 ? kColorPrimary : Colors.grey),
                            )
                    ),
                  ]
              ),
            ),
            body: Container(
              child: WillPopScope(
                child: Container(
                  child: Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                  PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DiscoverTab(),
                      MatchesTab(),
                      ConversationsTab(),
                      SchoolTab(),
                      ProfileTab(),
                    ],
                  ) :
                  PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DiscoverTab(),
                      MatchesTab(),
                      VacanciesTab(),
                      ConversationsTab(),
                      ProfileTab(),
                    ],
                  ),
                ),
                onWillPop: onWillPop,
              ),
            ),
          );
        });
  }
}

class VacanciesScreenProps {
  final Function getLikedNumOfVacancies;
  final Function getSubmittedNumOfVacancies;
  final int response;

  VacanciesScreenProps({
    this.getLikedNumOfVacancies,
    this.getSubmittedNumOfVacancies,
    this.response,
  });
}

VacanciesScreenProps mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps(
    response: store.state.vacancy.number_of_likeds,
    getLikedNumOfVacancies: () => store.dispatch(getNumberOfLikedVacancies()),
    getSubmittedNumOfVacancies: () => store.dispatch(getNumberOfSubmittedVacancies()),
  );
}
