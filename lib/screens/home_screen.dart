import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/screens/tabs/school_tab.dart';
import 'package:ishtapp/screens/tabs/vacancies_tab.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum work_mode { isWork, isTraining }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Intro intro2 = Intro(
    stepCount: 7,

    /// use defaultTheme, or you can implement widgetBuilder function yourself
    widgetBuilder: StepWidgetBuilder.useDefaultTheme(
      texts: [
        'Настрой поиск под себя',
        'Заполни полностью свой профиль',
        'Выбери нужный период актуальности вакансии и способ отображения предложений',
        'Главная страница поиска',
        'Отобранные Вами предложения',
        'Все Ваши отклики',
        'Вся Ваша переписка с работодателями',
      ],
      buttonTextBuilder: (currPage, totalPage) {
        return currPage < totalPage - 1 ? 'Дальше' : 'Завершить';
      },
      maskClosable: true,
    ),
  );

  Intro introStart;
  Intro intro;

  //region Variables
  final _formKey = GlobalKey<FormState>();
  final _vacancyAddFormKey = GlobalKey<FormState>();

  List<dynamic> jobTypeList = [];
  List<dynamic> vacancyTypeList = [];
  List<dynamic> busynessList = [];
  List<dynamic> scheduleList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<dynamic> currencyList = [];

  List<String> regions = [];
  List<String> districts = [];

  List _jobTypes = [];
  List _vacancyTypes = [];
  List _businesses = [];
  List _schedules = [];
  List _regions = [];
  List _districts = [];
  List _currencies = [];
  List spheres = [];

  String selectedRegion;
  String selectedDistrict;
  String selectedJobType;

  int _regionId;
  bool loading = false;
  work_mode work = work_mode.isWork;

  int c = 0;

  DateTime currentBackPressTime;

  PhoneNumber number = PhoneNumber(isoCode: 'KG');

  Users user;
  String deadline;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  final _pageController = new PageController();
  int _tabCurrentIndex = 0;

  List<Widget> appBarTitles = [];

  bool isProfile = false;
  bool isSpecial = false;
  Timer timer;
  int receivedMessageCount = 0;

  TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _vacancyTypeAheadController = TextEditingController();
  List<dynamic> _suggestions = [];
  List<dynamic> _suggestionsAddress = [];
  String _selectedCity;

  Completer<YandexMapController> _controller = Completer();
  Point _point;

  VacanciesScreenProps _props;

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

  void _deactivateVacancyWithOverDeadline() async {
    Vacancy.deactivateVacancyWithOverDeadline();
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
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Flex(
                                direction: Axis.vertical,
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'location'.tr().toString().toUpperCase(),
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  TypeAheadFormField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: _typeAheadController,
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
                                        _suggestions = await _fetchAddressSuggestions(pattern);
                                      }
                                      return _suggestions;
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
                                      _regions = [];
                                      _typeAheadController.text = suggestion['value'];

                                      String region = suggestion['data']['region_with_type'];
                                      double latitude = double.parse(suggestion['data']['geo_lat']);
                                      double longitude = double.parse(suggestion['data']['geo_lon']);

                                      if(region != '' && region != null){
                                        int regionId = await Vacancy.getRegionByName(region);
                                        setState(() {
                                          this._regions.add(regionId);
                                          this._point = Point(
                                              latitude: latitude,
                                              longitude: longitude
                                          );
                                        });
                                      }

                                      print(_regions);
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
                            // MultiSelectFormField(
                            //   dialogShapeBorder: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.all(Radius.circular(12.0))
                            //   ),
                            //   fillColor: kColorWhite,
                            //   // autovalidate: AutovalidateMode.disabled,
                            //   title: Text(
                            //     'region'.tr(),
                            //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.length == 0) {
                            //       return 'select_one_or_more'.tr();
                            //     }
                            //     return null;
                            //   },
                            //   dataSource: regionList,
                            //   textField: 'name',
                            //   valueField: 'id',
                            //   okButtonLabel: 'ok'.tr(),
                            //   cancelButtonLabel: 'cancel'.tr(),
                            //   // required: true,
                            //   hintWidget: Text('select_one_or_more'.tr()),
                            //   initialValue: this._regions,
                            //   onSaved: (value) {
                            //     if (value == null) return;
                            //     setState(() {
                            //       _regions = value;
                            //     });
                            //   },
                            // ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              fillColor: kColorWhite,
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
                              fillColor: kColorWhite,
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
                              fillColor: kColorWhite,
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
                              fillColor: kColorWhite,
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
                                        _typeAheadController.text = '';
                                        _suggestions = [];
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
                                    onPressed: () async {
                                      if (user != null) {
                                        user.saveFilters(_regions, _districts, _jobTypes, _vacancyTypes, _businesses, _schedules);
                                      }
                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                          schedule_ids: _schedules,
                                          busyness_ids: _businesses,
                                          // region_ids: [_regionId],
                                          region_ids: _regions,
                                          district_ids: _districts,
                                          vacancy_type_ids: _vacancyTypes,
                                          job_type_ids: _jobTypes)
                                      );
                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                      Navigator.of(context).pop();
                                      (await _controller.future).move(
                                        point: _point,
                                        animation: const MapAnimation(smooth: true, duration: 1),
                                        zoom: 8,
                                      );
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

  void _nextTab(int tabIndex, {isProfile = false}) {
    // Update tab index
    setState(() => _tabCurrentIndex = tabIndex);
    setState(() => isProfile = true);
    // Update page index
    _pageController.animateToPage(tabIndex, duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  buildSome(BuildContext context) {
    appBarTitles = [
      Row(
        // direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // color: kColorGray,
              height: 70.0,
              child: Image.asset(
                'assets/images/logo_white.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            // color: kColorGray,
            child: GestureDetector(
              key: intro.keys[1],
              child: CircleButton(
                bgColor: Colors.transparent,
                padding: 10,
                icon: Icon(
                  Boxicons.bx_user,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              onTap: () {
                _nextTab(4);
                setState(() {
                  isProfile = true;
                });
              },
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

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('responses'.tr(), style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600)),
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

  Widget customThemeWidgetBuilder(StepWidgetParams stepWidgetParams) {

    Map _smartGetPosition({
      Size size,
      Size screenSize,
      Offset offset,
    }) {
      double height = size.height;
      double width = size.width;
      double screenWidth = screenSize.width;
      double screenHeight = screenSize.height;
      double bottomArea = screenHeight - offset.dy - height;
      double topArea = screenHeight - height - bottomArea;
      double rightArea = screenWidth - offset.dx - width;
      double leftArea = screenWidth - width - rightArea;
      Map position = Map();
      position['crossAxisAlignment'] = CrossAxisAlignment.start;
      if (topArea > bottomArea) {
        position['bottom'] = bottomArea + height + 16;
      } else {
        position['top'] = offset.dy + height + 12;
      }
      if (leftArea > rightArea) {
        position['right'] = rightArea <= 0 ? 16.0 : rightArea;
        position['crossAxisAlignment'] = CrossAxisAlignment.end;
        position['width'] = min(leftArea + width - 16, screenWidth * 0.618);
      } else {
        position['left'] = offset.dx <= 0 ? 16.0 : offset.dx;
        position['width'] = min(rightArea + width - 16, screenWidth * 0.618);
      }

      /// The distance on the right side is very large, it is more beautiful on the right side
      if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
        position['left'] = offset.dx + width + 16;
        position['top'] = offset.dy - 4;
        position['bottom'] = null;
        position['right'] = null;
        position['width'] = min<double>(position['width'], rightArea * 0.8);
      }

      /// The distance on the left is large, it is more beautiful on the left side
      if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
        position['right'] = rightArea + width + 16;
        position['top'] = offset.dy - 4;
        position['bottom'] = null;
        position['left'] = null;
        position['crossAxisAlignment'] = CrossAxisAlignment.end;
        position['width'] = min<double>(position['width'], leftArea * 0.8);
      }
      return position;
    }

    List<String> texts = [
      'Настрой поиск под себя',
      'Заполни полностью свой профиль',
      'Выбери нужный период актуальности вакансии и способ отображения предложений',
      'Главная страница поиска',
      'Отобранные Вами предложения',
      'Все Ваши отклики',
      'Вся Ваша переписка с работодателями',
    ];

    int currentStepIndex = stepWidgetParams.currentStepIndex;
    int stepCount = stepWidgetParams.stepCount;
    Offset offset = stepWidgetParams.offset;

    Map position = _smartGetPosition(
      screenSize: stepWidgetParams.screenSize,
      size: stepWidgetParams.size,
      offset: offset,
    );

    return Container(
      child: GestureDetector(
        onTap: () {
          stepCount - 1 == currentStepIndex
              ? stepWidgetParams.onFinish()
              : stepWidgetParams.onNext();
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: position['width'],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: position['crossAxisAlignment'],
                  children: [
                    Text(
                      currentStepIndex > texts.length - 1
                          ? ''
                          : texts[currentStepIndex],
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 40,
                      child: OutlineButton(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(64),
                          ),
                        ),
                        highlightedBorderColor: Colors.white,
                        borderSide: BorderSide(color: Colors.white),
                        textColor: Colors.white,
                        onPressed: stepCount - 1 == currentStepIndex
                            ? stepWidgetParams.onFinish
                            : stepWidgetParams.onNext,
                        child: Text(
                          currentStepIndex < stepCount - 1 ? 'Дальше' : 'Завершить',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              left: position['left'],
              top: position['top'],
              bottom: position['bottom'],
              right: position['right'],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    intro = Intro(
      maskColor: Color.fromRGBO(0, 0, 0, 0.80),
      borderRadius: BorderRadius.all(Radius.circular(64.0)),
      stepCount: 7,
      widgetBuilder: customThemeWidgetBuilder,
    );

    if (Prefs.getString(Prefs.ROUTE) == 'COMPANY') {
      _deactivateVacancyWithOverDeadline();
    } else {
      // Timer(Duration(microseconds: 500), () {
      //   intro.start(context);
      // });
    }
    getLists();
    buildSome(context);

    // if (Prefs.getBool(Prefs.INTRO)) {
    // Timer(Duration(microseconds: 500), () {
    //   intro.start(context);
    // });
    // }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Timer.periodic(Duration(seconds:300), (Timer t) {
      StoreProvider.of<AppState>(context).dispatch(getChatList());
      StoreProvider.of<AppState>(context).dispatch(getNumberOfUnreadMessages());
    });
    super.didChangeDependencies();
  }

  void handleInitialBuild(VacanciesScreenProps props) {
    props.getLikedNumOfVacancies();
    props.getSubmittedNumOfVacancies();
    props.getNumberOfUnreadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VacanciesScreenProps>(
        distinct: true,
        converter: (store) => mapStateToProps(store),
        onInitialBuild: (props) => this.handleInitialBuild(props),
        builder: (context, props) {

          return Scaffold(
            backgroundColor: isProfile ? kColorWhite : kColorPrimary,
            appBar: isSpecial ? AppBar(
              automaticallyImplyLeading: false,
              title: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                child: appBarTitles[_tabCurrentIndex],
              ),
            ) : AppBar(
              backgroundColor: isProfile ? kColorWhite : kColorPrimary,
              elevation: 0,
              toolbarHeight: 100,
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
                        Boxicons.bx_search_alt,
                        key: intro.keys[3],
                        color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey,
                      ),
                      title: Text(
                        "search".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey),
                      ),
                    ) :
                    BottomNavigationBarItem(
                        icon: Icon(
                          Boxicons.bx_search,
                          key: intro.keys[3],
                          color: _tabCurrentIndex == 0 ? kColorPrimary : null,
                        ),
                        title: Text(
                          "search".tr(),
                          style: TextStyle(color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey),
                        )
                    ),

                    BottomNavigationBarItem(
                        icon: Icon(
                          Boxicons.bx_heart,
                          key: intro.keys[4],
                          color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey,
                        ),
                        title: Text(
                          "matches".tr(),
                          style: TextStyle(color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey),
                        )
                    ),

                    BottomNavigationBarItem(
                        icon: Container(
                          key: intro.keys[5],
                          width: 50,
                          height: 30,
                          child: Stack(children: [

                            Positioned(
                              top: 0,
                              left: 0,
                              right: StoreProvider.of<AppState>(context).state.vacancy.number_of_submiteds > 0 ? null : 0,
                              child: Icon(
                                Boxicons.bx_file,
                                color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey,
                              ),
                            ),

                            StoreProvider.of<AppState>(context).state.vacancy.number_of_submiteds > 0 ?
                            Positioned(
                              top: 0,
                              right: 0,
                              child: StoreProvider.of<AppState>(context).state.vacancy.number_of_submiteds > 0 ?
                              Badge(
                                  text: StoreProvider.of<AppState>(context).state.vacancy.number_of_submiteds.toString()
                              ) : Container(),
                            ) :
                            Container(),

                          ]),
                        ),
                        title: Text(
                          "responses".tr(),
                          style: TextStyle(color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey),
                        )
                    ),

                    BottomNavigationBarItem(
                        icon: Container(
                          key: intro.keys[6],
                          width: 50,
                          height: 30,
                          child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: StoreProvider.of<AppState>(context).state.chat.number_of_unread > 0 ? null : 0,
                                  child: Icon(
                                    Boxicons.bx_comment_detail,
                                    color: _tabCurrentIndex == 3 ? kColorPrimary : Colors.grey,
                                  ),
                                ),

                                StoreProvider.of<AppState>(context).state.chat.number_of_unread > 0 ?
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: StoreProvider.of<AppState>(context).state.chat.number_of_unread > 0 ?
                                  Badge(
                                      text: StoreProvider.of<AppState>(context).state.chat.number_of_unread.toString()
                                  ) : Container(),
                                ) :
                                Container(),
                              ]
                          ),
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
                      VacanciesTab(),
                      ConversationsTab(),
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

class VacanciesScreenProps {
  final Function getLikedNumOfVacancies;
  final Function getSubmittedNumOfVacancies;
  final Function getNumberOfUnreadMessages;
  final int response;

  VacanciesScreenProps({
    this.getLikedNumOfVacancies,
    this.getSubmittedNumOfVacancies,
    this.getNumberOfUnreadMessages,
    this.response,
  });
}

VacanciesScreenProps mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps(
    response: store.state.vacancy.number_of_likeds,
    getLikedNumOfVacancies: () => store.dispatch(getNumberOfLikedVacancies()),
    getSubmittedNumOfVacancies: () => store.dispatch(getNumberOfSubmittedVacancies()),
    getNumberOfUnreadMessages: () => store.dispatch(getNumberOfUnreadMessages()),
  );
}