import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:ishtapp/screens/profile_full_info_screen.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/submitted_user_card.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:redux/redux.dart';
import 'package:ishtapp/datas/Skill.dart';

import 'package:flutter_redux/flutter_redux.dart';

class MatchesTab extends StatefulWidget {
  @override
  _MatchesTabState createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  void handleInitialBuild(VacanciesScreenProps1 props) {
    props.getLikedVacancies();
  }

  void handleInitialBuildOfSubmits(SubmittedUsersProps props) {
    props.getSubmittedUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (Prefs.getString(Prefs.TOKEN) == "null" || Prefs.getString(Prefs.TOKEN) == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Text(
                "you_cant_see_matches_please_sign_in".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            CustomButton(
                text: "sign_in".tr(),
                textColor: kColorPrimary,
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushNamed(context, Routes.start);
                })
          ],
        ),
      );
    } else {
      if (Prefs.getString(Prefs.USER_TYPE) == 'COMPANY') {
        return StoreConnector<AppState, SubmittedUsersProps>(
          converter: (store) => mapStateToSubmittedUsersProps(store),
          onInitialBuild: (props) => this.handleInitialBuildOfSubmits(props),
          builder: (context, props) {
            List<Users> data = props.listResponse.data;
            bool loading = props.listResponse.loading;

            Widget body;
            if (loading) {
              body = Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              body = Column(
                children: [
                  Expanded(
                      child: data != null
                          ? UsersGrid(
                              children: data.map((user) {
                              return GestureDetector(
                                child: UserCard(
                                  user: user, /*page: 'match',*/
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext ctx) => ProfileInfoScreen(
                                            user_id: user.id,
                                            userVacancyId: user.userVacancyId,
                                            recruited: user.recruited,
                                          )));
                                },
                              );
                            }).toList())
                          : Container(
                              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: Center(
                                child: Text(
                                  'cvs_empty'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            )),
                ],
              );
            }

            return body;
          },
        );
      } else {
        return StoreConnector<AppState, VacanciesScreenProps1>(
          converter: (store) => mapStateToProps(store),
          onInitialBuild: (props) => this.handleInitialBuild(props),
          builder: (context, props) {
            List<Vacancy> data = props.listResponse1.data;
            bool loading = props.listResponse1.loading;

            Widget body;
            if (loading) {
              body = Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              body = Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      child: Container(
                        child: StoreProvider.of<AppState>(context).state.vacancy.liked_list.data != null &&
                            StoreProvider.of<AppState>(context).state.vacancy.liked_list.data.length != 0  ?
                        UsersGrid(
                            children: StoreProvider.of<AppState>(context).state.vacancy.liked_list.data.map((vacancy) {
                              return GestureDetector(
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB" ?
                                    !vacancy.isProductLabVacancy ?
                                    ProfileCard(
                                      vacancy: vacancy,
                                      page: 'match',
                                    ) :
                                    Container() :
                                    ProfileCardProductLab(
                                      vacancy: vacancy,
                                      page: 'match',
                                    ),
                                ),
                                onTap: () {
                                  VacancySkill.getVacancySkills(vacancy.id).then((value) {
                                    List<VacancySkill> vacancySkills = [];

                                    for (var i in value) {
                                      vacancySkills.add(new VacancySkill(
                                        id: i.id,
                                        name: i.name,
                                        vacancyId: i.vacancyId,
                                        isRequired: i.isRequired,
                                      ));
                                    }

                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return Scaffold(
                                        backgroundColor: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                            ? kColorProductLab
                                            : kColorPrimary,
                                        appBar: AppBar(
                                          title: Text("vacancy_view".tr()),
                                        ),
                                        body: VacancyView(
                                          page: Prefs.getString(Prefs.ROUTE) != 'PRODUCT_LAB' ? "user_match" : "view",
                                          vacancy: vacancy,
                                          vacancySkill: vacancySkills,
                                        ),
                                      );
                                    })).then((value)
                                    {
                                      handleInitialBuild(props);
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(getNumOfLikedVacancyRequest());
                                    });
                                  });
                                },
                              );
                            }).toList()
                        ) :
                        Center(
                          child: Text(
                            'empty'.tr(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return body;
          },
        );
      }
    }
  }
}

class VacanciesScreenProps1 {
  final Function getLikedVacancies;
  final LikedVacancyListState listResponse1;

  VacanciesScreenProps1({
    this.getLikedVacancies,
    this.listResponse1,
  });
}

VacanciesScreenProps1 mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps1(
    listResponse1: store.state.vacancy.liked_list,
    getLikedVacancies: () => store.dispatch(getLikedVacancies()),
  );
}

class SubmittedUsersProps {
  final Function getSubmittedUsers;
  final ListUserDetailState listResponse;

  SubmittedUsersProps({
    this.getSubmittedUsers,
    this.listResponse,
  });
}

SubmittedUsersProps mapStateToSubmittedUsersProps(Store<AppState> store) {
  return SubmittedUsersProps(
    listResponse: store.state.user.submitted_user_list,
    getSubmittedUsers: () => store.dispatch(getSubmittedUsers()),
  );
}
