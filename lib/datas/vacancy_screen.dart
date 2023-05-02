//import 'package:flutter/material.dart';
//import 'package:flutter_redux/flutter_redux.dart';
//import 'package:ishtapp/components/custom_button.dart';
//import 'package:ishtapp/datas/routes.dart';
//import 'package:ishtapp/datas/vacancy.dart';
//import 'package:ishtapp/utils/constants.dart';
//import 'package:ishtapp/widgets/profile_card.dart';
//import 'package:easy_localization/easy_localization.dart';
//import 'package:redux/redux.dart';
//import 'package:ishtapp/datas/app_state.dart';
//import 'RSAA.dart';
//
//
//class VacanciesScreen extends StatelessWidget {
//  void handleInitialBuild(VacanciesScreenProps props) {
//    props.getVacancies();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, VacanciesScreenProps>(
//      converter: (store) => mapStateToProps(store),
//      onInitialBuild: (props) => this.handleInitialBuild(props),
//      builder: (context, props) {
//        List<Vacancy> data = props.listResponse.data;
//        bool loading = props.listResponse.loading;
//
//        Widget body;
//        if (loading) {
//          body = Center(
//            child: CircularProgressIndicator(),
//          );
//        } else {
//          body = Stack(
//              alignment: Alignment.topCenter,
//              fit: StackFit.expand,
//              children: [
//                Container(
//            child: Stack(alignment: Alignment.center, children: [
//              for (int x = 0; x < data.length; x++)
//                Positioned(
//                  bottom: 5 + (x * 15.0),
//                  child: Draggable(
//                      onDragEnd: (drag) {
//                        print(
//                            "============================================");
//                        print(drag.offset.dy);
//                        print(drag.offset.dx);
//                        print(
//                            "============================================");
//
////                        if (drag.offset.dx < -200) {
////                          removeCards(x, 'left');
////                        }
////
////                        if (drag.offset.dx > 200) {
////                          removeCards(x, 'right');
////                        }
//                      },
//                      childWhenDragging: Container(),
//                      feedback: GestureDetector(
//                        onTap: () {
//                          print("Hello All");
//                        },
//                        child: ProfileCard(
//                          page: 'discover',
//                          vacancy: data[x],
//                          index: data.length - x,
//                        ),
//                      ),
//                      child: GestureDetector(
//                        onTap: () {
//                          Navigator.of(context).push(MaterialPageRoute(
//                              builder: (BuildContext context) {
//                                return ProfileCard(
//                                  vacancy: data[x],
//                                );
//                              }));
//                        },
//                        child: ProfileCard(
//                          page: 'discover',
//                          vacancy: data[x],
//                          index: data.length - x,
//                        ),
//                      )),
//                ),
//            ]),
//          ),
//                Container(
////          margin: const EdgeInsets.only(bottom: 20),
//                  padding: EdgeInsets.all(20),
//                  child: Align(
//                    alignment: Alignment.lerp(
//                        new Alignment(-1.0, -1.0), new Alignment(1, -1.0), 10),
//                    widthFactor: MediaQuery.of(context).size.width * 1,
//                    heightFactor: MediaQuery.of(context).size.height * 0.4,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: [
//                        CustomButton(
//                          width: MediaQuery.of(context).size.width * 0.25,
//                          padding: EdgeInsets.all(2),
//                          color: Colors.white,
//                          textColor: kColorPrimary,
//                          onPressed: () {
////                      Navigator.of(context).popAndPushNamed(Routes.signup);
//                          },
//                          text: 'day'.tr(),
//                        ),
//                        CustomButton(
//                          width: MediaQuery.of(context).size.width * 0.3,
//                          padding: EdgeInsets.all(2),
//                          color: Colors.white,
//                          textColor: kColorPrimary,
//                          onPressed: () {
////                      Navigator.of(context).popAndPushNamed(Routes.signup);
//                          },
//                          text: 'week'.tr(),
//                        ),
//                        CustomButton(
//                          width: MediaQuery.of(context).size.width * 0.3,
//                          padding: EdgeInsets.all(2),
//                          color: Colors.white,
//                          textColor: kColorPrimary,
//                          onPressed: () {
////                      Navigator.of(context).popAndPushNamed(Routes.signup);
//                          },
//                          text: 'month'.tr(),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ]);
//        }
//
//        return Scaffold(
//          appBar: AppBar(
//            title: Text('Vacancies list'),
//          ),
//          body: body,
//        );
//      },
//    );
//  }
//}
//
//
