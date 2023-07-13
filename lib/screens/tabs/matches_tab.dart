import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/widgets/default_card_border.dart';
import 'package:ishtapp/widgets/profile_card_user.dart';
import 'package:ishtapp/widgets/user_view.dart';

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

  void handleInitialBuildOfLikedUsers(LikedUsersProps props) {
    props.getLikedUsers();
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
        return StoreConnector<AppState, LikedUsersProps>(
          converter: (store) => mapStateToLikedUsersProps(store),
          onInitialBuild: (props) => this.handleInitialBuildOfLikedUsers(props),
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
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Stack(
                                      children: [
                                        Card(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 0,
                                          color: Colors.white,
                                          margin: EdgeInsets.all(0),
                                          shape: defaultCardBorder(),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(0),
                                            height: double.maxFinite,
                                            child: Flex(
                                              direction: Axis.vertical,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Container(
                                                    color: kColorGray,
                                                    height: double.infinity,
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 10, horizontal: 20),
                                                    child: Flex(
                                                      direction: Axis.horizontal,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            child: Flex(
                                                              direction: Axis.horizontal,
                                                              children: [
                                                                Flexible(
                                                                  child: Container(
                                                                    // color: kColorDark,
                                                                    child: RichText(
                                                                      maxLines: 3,
                                                                      text: TextSpan(
                                                                        text: user.name != null ? user.surname != null ? '${user.name} ${user.surname}\n' : '${user.name.toString()}\n' : '',
                                                                        style: TextStyle(
                                                                          fontSize: user.name.length > 20 ? 14 : 20,
                                                                          fontWeight: FontWeight.w900,
                                                                          fontFamily: 'Manrope',
                                                                          color: kColorDark,
                                                                        ),
                                                                        children: <TextSpan>[
                                                                          TextSpan(
                                                                              text: user.region != null ? user.region : '',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Manrope',
                                                                                  fontSize: 12,
                                                                                  fontWeight:
                                                                                  FontWeight.w500,
                                                                                  color: kColorSecondary
                                                                              )
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 1,
                                                          child: Container(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(4),
                                                              child: user.image != null ? Image.network(
                                                                SERVER_IP + user.image + "?token=${Guid.newGuid}",
                                                                headers: {
                                                                  "Authorization":
                                                                  Prefs.getString(Prefs.TOKEN)
                                                                },
                                                                width: 60,
                                                                height: 60,
                                                              ) : Image.asset(
                                                                'assets/images/default-user.jpg',
                                                                fit: BoxFit.cover,
                                                                width: 60,
                                                                height: 60,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                    child: Flex(
                                                      direction: Axis.horizontal,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// Labels
                                                        Flexible(
                                                          child: Container(
                                                            child: Flex(
                                                              direction: Axis.vertical,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Интересуемые вакансии
                                                                user.vacancy_type != 'null' ? Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                  decoration: BoxDecoration(
                                                                      color: kColorGray,
                                                                      borderRadius: BorderRadius.circular(4)
                                                                  ),
                                                                  child: Text(
                                                                    user.vacancy_type != 'null' ? user.vacancy_type.toString() : '',
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: kColorDark,
                                                                    ),
                                                                  ),
                                                                ) : Container(),

                                                                // Вид занятости
                                                                user.business != 'null' ?
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                  margin: EdgeInsets.only(top: 5),
                                                                  decoration: BoxDecoration(
                                                                      color: kColorGray,
                                                                      borderRadius: BorderRadius.circular(4)
                                                                  ),
                                                                  child: Text(
                                                                    user.business != 'null' ? user.business.toString() : '',
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontFamily: 'Manrope',
                                                                        color: kColorDark
                                                                    ),
                                                                  ),
                                                                )  : Container(),

                                                                // Статус
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                  margin: EdgeInsets.only(top: 5),
                                                                  decoration: BoxDecoration(
                                                                      color: user.status == 1 ? kColorBlue :
                                                                      user.status == 2  ? kColorGreen : kColorGray,
                                                                      borderRadius: BorderRadius.circular(4)
                                                                  ),
                                                                  child: Text(
                                                                    user.statusText != null ? user.statusText : '',
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontFamily: 'Manrope',
                                                                        color: kColorDark
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        /// Salary
                                                        Flexible(
                                                          child: Container(
                                                            child: Flex(
                                                              direction: Axis.vertical,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    (user.salary != null ? user.salary : '') +
                                                                        ' ${user.currency}',
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w900,
                                                                      fontFamily: 'Manrope',
                                                                      color: kColorPrimary,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    user.period != null
                                                                        ? user.period
                                                                        .toLowerCase()
                                                                        : '',
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: 'Manrope',
                                                                      color: kColorPrimary,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                /// Company Name & Description
                                                Expanded(
                                                  child: Container(
                                                    width: double.maxFinite,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                    child: Flex(
                                                      direction: Axis.vertical,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            child: RichText(
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 3,
                                                              text: TextSpan(
                                                                text: user.description != null ? Bidi.stripHtmlIfNeeded(user.description) : "",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontFamily: 'Manrope',
                                                                    color: kColorSecondary
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 10),
                                                    child: Flex(
                                                      direction: Axis.horizontal,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                                            child: CustomButton(
                                                              borderSide: BorderSide(
                                                                  color: kColorPrimary, width: 2.0
                                                              ),
                                                              padding: EdgeInsets.all(0),
                                                              color: Colors.transparent,
                                                              textColor: kColorPrimary,
                                                              onPressed: () async {
                                                                if (Prefs.getString(Prefs.TOKEN) == null) {

                                                                } else {
                                                                  removeCard(
                                                                      props: props,
                                                                      type: "LIKED_THEN_DELETED",
                                                                      userId: user.id,
                                                                      user: user,
                                                                      context: context
                                                                  );
                                                                }
                                                              },
                                                              text: 'delete'.tr(),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            margin:
                                                            EdgeInsets.symmetric(horizontal: 5),
                                                            child: CustomButton(
                                                              padding: EdgeInsets.all(0),
                                                              color: kColorPrimary,
                                                              textColor: Colors.white,
                                                              onPressed: () async {
                                                              },
                                                              text: 'invite'.tr(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (BuildContext ctx) =>
                                  //         ProfileInfoScreen(
                                  //           user_id: user.id,
                                  //           userVacancyId: user.userVacancyId,
                                  //           recruited: user.recruited,
                                  //         )
                                  // ));
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return Scaffold(
                                      backgroundColor: kColorPrimary,
                                      appBar: AppBar(
                                        title: Text('vacancy_view'.tr()),
                                      ),
                                      body: UserView(
                                          page: 'company_liked',
                                          user: user
                                      ),
                                    );
                                  }));
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

            return Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: body,
            );
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                                    // margin: EdgeInsets.only(bottom: 20),
                                    child: ProfileCard(
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
                                        backgroundColor: kColorPrimary,
                                        appBar: AppBar(
                                          title: Text("vacancy_view".tr()),
                                        ),
                                        body: VacancyView(
                                          page: "user_match",
                                          vacancy: vacancy,
                                          vacancySkill: vacancySkills,
                                        ),
                                      );
                                    })).then((value) {
                                      handleInitialBuild(props);
                                      StoreProvider.of<AppState>(context).dispatch(getNumOfLikedVacancyRequest());
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

  void removeCard({String type, int userId, props, context, Users user}) {
    if (Prefs.getString(Prefs.TOKEN) != null) {
      Users.deleteUserCompany(userId: userId, type: type).then((value) {
        props.listResponse.data.remove(user);
        StoreProvider.of<AppState>(context).dispatch(getLikedUsers());
      });
    } else {
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

class LikedUsersProps {
  final Function getLikedUsers;
  final LikedUserState listResponse;

  LikedUsersProps({
    this.getLikedUsers,
    this.listResponse,
  });
}

LikedUsersProps mapStateToLikedUsersProps(Store<AppState> store) {
  return LikedUsersProps(
    listResponse: store.state.user.liked_user_list,
    getLikedUsers: () => store.dispatch(getLikedUsers()),
  );
}
