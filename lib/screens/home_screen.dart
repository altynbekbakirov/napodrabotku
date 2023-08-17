import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/screens/tabs/vacancies_tab.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/widgets/cicle_button.dart';
import 'package:ishtapp/screens/tabs/conversations_tab.dart';
import 'package:ishtapp/screens/tabs/discover_tab.dart';
import 'package:ishtapp/screens/tabs/matches_tab.dart';
import 'package:ishtapp/screens/tabs/profile_tab.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/widgets/badge.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

enum work_mode { isWork, isTraining }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Intro introStart = Intro(
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

  Intro intro;
  Intro intro2;

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

  List spheres = [];

  String selectedRegion;
  String selectedDistrict;
  String selectedJobType;

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
              key: intro.keys[0],
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
      // 'Настрой поиск под себя',
      'Заполни полностью свой профиль',
      // 'Выбери нужный период актуальности вакансии и способ отображения предложений',
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
        onTap: () {},
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
                        onPressed: () {
                          if(stepCount - 1 == currentStepIndex){
                            stepWidgetParams.onFinish();
                            // DiscoverTab().intro.start(context);
                            Future.delayed(Duration.zero, () {
                              intro2.start(context);
                            });
                          } else {
                            stepWidgetParams.onNext();
                          }
                        },
                        child: Text(
                          'Дальше',
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
            currentStepIndex == 0 ? Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
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
                    onPressed: () {
                      Prefs.setInt(Prefs.INTRO, 1);
                      stepWidgetParams.onFinish();
                    },
                    child: Text(
                      'Пропустить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget customThemeWidgetBuilder2(StepWidgetParams stepWidgetParams) {

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
      'Выбери нужный период актуальности вакансии',
      'Выбери способ отображения предложений',
      'Время свайпить подработки',
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
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: currentStepIndex < stepCount - 1 ? position['width'] : double.maxFinite,
                margin: currentStepIndex < stepCount - 1 ? EdgeInsets.zero : EdgeInsets.only(bottom: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: position['crossAxisAlignment'],
                  children: [
                    currentStepIndex < stepCount - 1 ?
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
                    ) :
                    Container(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Image(
                        image: AssetImage('assets/images/intro_1.png'),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 40,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    currentStepIndex < stepCount - 1 ?
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
                        onPressed: () {
                          if(stepCount - 1 == currentStepIndex){
                            Prefs.setInt(Prefs.INTRO, 1);
                            stepWidgetParams.onFinish();
                          } else {
                            stepWidgetParams.onNext();
                          }
                        },
                        child: Text(
                          currentStepIndex < stepCount - 1 ? 'Дальше' : 'Завершить',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ) :
                    Container(),
                  ],
                ),
              ),
              left: position['left'],
              top: position['top'],
              bottom: position['bottom'],
              right: position['right'],
            ),
            currentStepIndex < stepCount - 1 ? Container() :
            Positioned(
              bottom: position['bottom']-165,
              left: 0,
              right: 0,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/intro_3.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            currentStepIndex < stepCount - 1 ? Container() :
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
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
                    onPressed: () {
                      if(stepCount - 1 == currentStepIndex){
                        Prefs.setInt(Prefs.INTRO, 1);
                        stepWidgetParams.onFinish();
                      } else {
                        stepWidgetParams.onNext();
                      }
                    },
                    child: Text(
                      currentStepIndex < stepCount - 1 ? 'Дальше' : 'Завершить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _newMessagesCounter = 0;

  void loadCounter() async {
    setState(() {
      _newMessagesCounter = (Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) ?? 0);
    });
  }

  void bindEventPusher() async {
    channel.bind('new-message-sent', (PusherEvent event) {
      var data = json.decode(event.data);
      print("New message sent event " + event.data.toString());

      if(data['user_id'] - Prefs.getInt(Prefs.USER_ID) == 0){
        setState(() {
          // _newMessagesCounter = ((Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) ?? 0) + 1);
          // Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, _newMessagesCounter);
          StoreProvider.of<AppState>(context).dispatch(getChatList());
          StoreProvider.of<AppState>(context).dispatch(getNumberOfUnreadMessages());
          // StoreProvider.of<AppState>(context).dispatch(getMessageList(data['sender_id'], data['vacancy_id']));
        });
      }
    });
  }

  PusherClient pusher;
  Channel channel;

  @override
  void initState() {

    intro = Intro(
      padding: EdgeInsets.zero,
      stepCount: 5,
      widgetBuilder: customThemeWidgetBuilder,
    );

    intro.setStepConfig(
      1,
      padding: EdgeInsets.fromLTRB(
        20, 5, 20, 25
      ),
    );

    intro.setStepConfig(
      2,
      padding: EdgeInsets.fromLTRB(
          25, 5, 25, 25
      ),
    );

    intro.setStepConfig(
      3,
      padding: EdgeInsets.fromLTRB(
          5, 2, 5, 22
      ),
    );

    intro.setStepConfig(
      4,
      padding: EdgeInsets.fromLTRB(
          5, 2, 5, 22
      ),
    );

    intro2 = Intro(
      padding: EdgeInsets.zero,
      stepCount: 4,
      widgetBuilder: customThemeWidgetBuilder2,
    );

    intro2.setStepsConfig(
      [1,2],
      padding: EdgeInsets.fromLTRB(
          0, 5, 0, 5
      ),
    );

    if (Prefs.getString(Prefs.USER_TYPE) == 'COMPANY') {
      _deactivateVacancyWithOverDeadline();
    }
    getLists();
    buildSome(context);

    super.initState();

    print('INTRO - ' + Prefs.getInt(Prefs.INTRO).toString());

    if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
      if (Prefs.getInt(Prefs.INTRO) == null || Prefs.getInt(Prefs.INTRO) == 0) {
        Future.delayed(Duration.zero, () {
          intro.start(context);
        });
      }
    }

    loadCounter();

    PusherClient pusher = PusherClient(
      '73e14d3cf78debd02655',
      PusherOptions(
          cluster: 'ap2'
      ),
      autoConnect: true,
      enableLogging: true,
    );

    channel = pusher.subscribe("chat");

    pusher.onConnectionStateChange((state) {
      print("previousState: ${state.previousState}, currentState: ${state.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error.message}");
    });

    bindEventPusher();
  }

  @override
  void dispose() {
    // pusherService.unbindEvent('new-message-sent');
    super.dispose();
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
        onInitialBuild: (props) {
          this.handleInitialBuild(props);
        },
        builder: (context, props) {

          // if(Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) == 1){
          //   Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, props.numberOfUnreadMessages);
          // }

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
                        key: intro.keys[1],
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
                          key: intro.keys[1],
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
                          key: intro.keys[2],
                          color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey,
                        ),
                        title: Text(
                          "matches".tr(),
                          style: TextStyle(color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey),
                        )
                    ),

                    BottomNavigationBarItem(
                        icon: Container(
                          key: intro.keys[3],
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
                          key: intro.keys[4],
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
                                      // text: Prefs.getInt(Prefs.NEW_MESSAGES_COUNT).toString()
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
                      DiscoverTab(intro: intro2),
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
                      DiscoverTab(intro: intro2),
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
  final Function getNumberOfUnreadMessages;
  final int response;
  final int numberOfUnreadMessages;

  VacanciesScreenProps({
    this.getLikedNumOfVacancies,
    this.getSubmittedNumOfVacancies,
    this.getNumberOfUnreadMessages,
    this.response,
    this.numberOfUnreadMessages,
  });
}

VacanciesScreenProps mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps(
    response: store.state.vacancy.number_of_likeds,
    numberOfUnreadMessages: store.state.chat.number_of_unread,
    getLikedNumOfVacancies: () => store.dispatch(getNumberOfLikedVacancies()),
    getSubmittedNumOfVacancies: () => store.dispatch(getNumberOfSubmittedVacancies()),
    getNumberOfUnreadMessages: () => store.dispatch(getNumberOfUnreadMessages()),
  );
}