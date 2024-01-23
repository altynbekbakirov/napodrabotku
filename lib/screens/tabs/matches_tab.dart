import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/widgets/default_card_border.dart';
import 'package:ishtapp/widgets/user_view.dart';

import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:redux/redux.dart';
import 'package:ishtapp/widgets/Dialogs/Dialogs.dart';

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
    props.getCompanyActiveVacancies();
  }

  int vacancyId;
  List<dynamic> _vacancyList = [];

  final _vacancyAddFormKey = GlobalKey<FormState>();

  Future<void> openInviteDialog(context, Users user) async {

    _vacancyList = _vacancyList.map<DropdownMenuItem<int>>((dynamic value) {
      var jj = new Vacancy(id: value.id, name: value.name);
      return DropdownMenuItem<int>(
        value: jj.id,
        child: Text(jj.name.toString()),
      );
    }).toList();

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'choose_vacancy'.tr(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                      ),
                    ),

                    /// Form
                    Form(
                      key: _vacancyAddFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 40),
                            child: Column(

                              children: [
                                DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  hint: Text("select".tr()),
                                  value: vacancyId,
                                  onChanged: (int newValue) {
                                    setState(() {
                                      vacancyId = newValue;
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
                                  items: _vacancyList,
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
                                    setState(() {
                                      vacancyId = null;
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

                                      Vacancy.saveVacancyUserInvite(
                                          vacancy_id: vacancyId,
                                          type: "INVITED",
                                          user_id: user.id
                                      ).then((value) {
                                        if (value == "OK") {
                                          // Dialogs.showDialogBox(context,"successfully_submitted".tr());
                                          StoreProvider.of<AppState>(context).state.user.liked_user_list.data.remove(user);
                                          StoreProvider.of<AppState>(context).dispatch(getUsers());
                                          Navigator.of(context).pop();
                                        } else {
                                          Dialogs.showDialogBox(context,"some_error_occurred_try_again".tr());
                                        }
                                      });

                                      setState(() {
                                        vacancyId = null;
                                      });
                                    } else {
                                      print('invalid');
                                    }
                                  },
                                  text: 'send'.tr(),
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
            bool loading = props.listResponse.loading && props.activeList.loading;
            _vacancyList = props.activeList.data;

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
                                                                              text: user.district != null ? user.district : '',
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
                                                              child: user.image != null ?
                                                              CachedNetworkImage(
                                                                // imageUrl: SERVER_IP + user.image + "?token=${Guid.newGuid}",
                                                                imageUrl: SERVER_IP + user.image,
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                  width: 60,
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                httpHeaders: {
                                                                  "Authorization": Prefs.getString(Prefs.TOKEN)
                                                                },
                                                                placeholder: (context, url) => Container(
                                                                  padding: EdgeInsets.all(10),
                                                                  width: 60,
                                                                  height: 60,
                                                                  child: CircularProgressIndicator(),
                                                                ),
                                                                errorWidget: (context, url, error) => Image.asset("assets/images/default-user.jpg"),
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
                                                                await openInviteDialog(context, user);
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
                                      loading: false,
                                    ),
                                ),
                                onTap: () {
                                  // VacancySkill.getVacancySkills(vacancy.id).then((value) {
                                  //   List<VacancySkill> vacancySkills = [];
                                  //
                                  //   for (var i in value) {
                                  //     vacancySkills.add(new VacancySkill(
                                  //       id: i.id,
                                  //       name: i.name,
                                  //       vacancyId: i.vacancyId,
                                  //       isRequired: i.isRequired,
                                  //     ));
                                  //   }

                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return Scaffold(
                                        backgroundColor: kColorPrimary,
                                        appBar: AppBar(
                                          title: Text("vacancy_view".tr()),
                                        ),
                                        body: VacancyView(
                                          page: "user_match",
                                          vacancy: vacancy,
                                        ),
                                      );
                                    })).then((value) {
                                      handleInitialBuild(props);
                                      StoreProvider.of<AppState>(context).dispatch(getNumOfLikedVacancyRequest());
                                    });
                                  // });
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
  final Function getCompanyActiveVacancies;
  final ListVacancysState activeList;

  LikedUsersProps({
    this.getLikedUsers,
    this.listResponse,
    this.getCompanyActiveVacancies,
    this.activeList,
  });
}

LikedUsersProps mapStateToLikedUsersProps(Store<AppState> store) {
  return LikedUsersProps(
    listResponse: store.state.user.liked_user_list,
    getLikedUsers: () => store.dispatch(getLikedUsers()),
    getCompanyActiveVacancies: () => store.dispatch(getCompanyActiveVacancies()),
    activeList: store.state.vacancy.active_list,
  );
}
