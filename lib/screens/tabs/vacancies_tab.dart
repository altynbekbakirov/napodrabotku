import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/screens/profile_screen.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/profile_card_user.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:ishtapp/widgets/user_view.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/Skill.dart';

class VacanciesTab extends StatefulWidget {

  @override
  _VacanciesTabState createState() => _VacanciesTabState();
}

class _VacanciesTabState extends State<VacanciesTab> {
  int type = 0;

  void handleInitialBuild(VacanciesScreenProps1 props) {
    props.getUserVacancies();
    props.getSubmittedVacancies();
    props.getInvitedVacancies();
  }

  void handleInitialBuildCompany(UsersScreenProps props) {
    props.getAllUsers();
    props.getSubmittedUsers();
    props.getInvitedUsers();
  }

  void handleInitialBuildOfCompanyVacancy(CompanyInactiveVacanciesScreenProps props) {
    props.getCompanyVacancies();
  }

  @override
  Widget build(BuildContext context) {

    if (Prefs.getString(Prefs.USER_TYPE) == 'COMPANY') {
      return StoreConnector<AppState, UsersScreenProps>(
        converter: (store) => mapStateToUsersProps(store),
        onInitialBuild: (props) => this.handleInitialBuildCompany(props),
        builder: (context, props) {
          bool loading;
          List<Users> data;

          if(type == 1) {
            data = props.invitedUsers.data;
            loading = props.invitedUsers.loading;
          } else if(type == 2) {
            data = props.submittedUsers.data;
            loading = props.submittedUsers.loading;
          } else {
            data = props.allUsers.data;
            loading = props.allUsers.loading;
          }

          Widget body;

          body = Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  // color: kColorGray,
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            borderSide: BorderSide(
                                color: kColorWhite,
                                width: 2.0
                            ),
                            color: type == 0 ? Colors.white : Colors.transparent,
                            textColor: type == 0 ? kColorPrimary : Colors.white,
                            textSize: 14,
                            padding: EdgeInsets.all(0),
                            height: 40.0,
                            onPressed: () {
                              Prefs.setInt(Prefs.OFFSET, 0);
                              StoreProvider.of<AppState>(context).dispatch(getAllUsers());
                              setState(() {
                                type = 0;
                              });
                            },
                            text: 'all'.tr(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            borderSide: BorderSide(
                                color: kColorWhite,
                                width: 2.0
                            ),
                            color: type == 1 ? Colors.white : Colors.transparent,
                            textColor: type == 1 ? kColorPrimary : Colors.white,
                            textSize: 14,
                            padding: EdgeInsets.all(0),
                            height: 40.0,
                            onPressed: () {
                              Prefs.setInt(Prefs.OFFSET, 0);
                              StoreProvider.of<AppState>(context).dispatch(getInviteUsers());
                              setState(() {
                                type = 1;
                              });
                            },
                            text: 'invites'.tr(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            borderSide: BorderSide(
                                color: kColorWhite,
                                width: 2.0
                            ),
                            color: type == 2 ? Colors.white : Colors.transparent,
                            textColor: type == 2 ? kColorPrimary : Colors.white,
                            textSize: 14,
                            padding: EdgeInsets.all(0),
                            height: 40.0,
                            onPressed: () {
                              Prefs.setInt(Prefs.OFFSET, 0);
                              StoreProvider.of<AppState>(context).dispatch(getSubmittedUsers());
                              setState(() {
                                type = 2;
                              });
                              // setState(() {
                              //   button == 3 ? button = 0 : button = 3;
                              // });
                            },
                            text: 'my_responses'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 15,
                child: loading ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ) : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child:  Flex(
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        child: UsersGrid(
                            children: data.map((user) {
                              return GestureDetector(
                                child: Container(
                                    child: ProfileCardUser(
                                        user: user,
                                        page: "company_responses"
                                    )
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Scaffold(
                                              backgroundColor: kColorPrimary,
                                              appBar: AppBar(
                                                title: Text("vacancy_view".tr()),
                                              ),
                                              body: UserView(
                                                page: "submitted",
                                                user: user,
                                              ),
                                            );
                                          })
                                  );
                                },
                              );
                            }).toList()
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );

          return Scaffold(
            backgroundColor: kColorPrimary,
            body: body,
          );
        },
      );
    } else {
      return StoreConnector<AppState, VacanciesScreenProps1>(
        converter: (store) => mapStateToProps(store),
        onInitialBuild: (props) => this.handleInitialBuild(props),
        builder: (context, props) {
          bool loading;
          List<Vacancy> data;

          if(type == 1) {
            data = props.invitedList.data;
            loading = props.invitedList.loading;
          } else if(type == 2) {
            data = props.listResponse1.data;
            loading = props.listResponse1.loading;
          } else {
            data = props.allList.data;
            loading = props.allList.loading;
          }

          Widget body;

          body = Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  // color: kColorGray,
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            borderSide: BorderSide(
                                color: kColorWhite,
                                width: 2.0
                            ),
                            color: type == 0 ? Colors.white : Colors.transparent,
                            textColor: type == 0 ? kColorPrimary : Colors.white,
                            textSize: 14,
                            padding: EdgeInsets.all(0),
                            height: 40.0,
                            onPressed: () {
                              Prefs.setInt(Prefs.OFFSET, 0);
                              StoreProvider.of<AppState>(context).dispatch(getUserVacancies());
                              setState(() {
                                type = 0;
                              });
                            },
                            text: 'all'.tr(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            borderSide: BorderSide(
                                color: kColorWhite,
                                width: 2.0
                            ),
                            color: type == 1 ? Colors.white : Colors.transparent,
                            textColor: type == 1 ? kColorPrimary : Colors.white,
                            textSize: 14,
                            padding: EdgeInsets.all(0),
                            height: 40.0,
                            onPressed: () {
                              Prefs.setInt(Prefs.OFFSET, 0);
                              StoreProvider.of<AppState>(context).dispatch(getInvitedVacancies());
                              setState(() {
                                type = 1;
                              });
                            },
                            text: 'invites'.tr(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            borderSide: BorderSide(
                                color: kColorWhite,
                                width: 2.0
                            ),
                            color: type == 2 ? Colors.white : Colors.transparent,
                            textColor: type == 2 ? kColorPrimary : Colors.white,
                            textSize: 14,
                            padding: EdgeInsets.all(0),
                            height: 40.0,
                            onPressed: () {
                              Prefs.setInt(Prefs.OFFSET, 0);
                              StoreProvider.of<AppState>(context).dispatch(getSubmittedVacancies());
                              setState(() {
                                type = 2;
                              });
                              // setState(() {
                              //   button == 3 ? button = 0 : button = 3;
                              // });
                            },
                            text: 'my_responses'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 15,
                child: loading ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ) : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child:  Flex(
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        child: UsersGrid(
                            children: data.map((vacancy) {
                              return GestureDetector(
                                child: Container(
                                    child: ProfileCard(vacancy: vacancy, page: "submit")
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Scaffold(
                                              backgroundColor: kColorPrimary,
                                              appBar: AppBar(
                                                title: Text("vacancy_view".tr()),
                                              ),
                                              body: VacancyView(
                                                page: "submitted",
                                                vacancy: vacancy,
                                              ),
                                            );
                                          })
                                  );
                                },
                              );
                            }).toList()
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );

          return Scaffold(
            backgroundColor: kColorPrimary,
            body: body,
          );
        },
      );
    }

  }
}

class UsersScreenProps {
  final Function getSubmittedUsers;
  final Function getInvitedUsers;
  final Function getAllUsers;
  final ListUsersState submittedUsers;
  final ListUsersState invitedUsers;
  final ListUsersState allUsers;

  UsersScreenProps({
    this.getSubmittedUsers,
    this.getInvitedUsers,
    this.getAllUsers,
    this.submittedUsers,
    this.invitedUsers,
    this.allUsers,
  });
}

UsersScreenProps mapStateToUsersProps(Store<AppState> store) {
  return UsersScreenProps(
    submittedUsers: store.state.user.submitted_users,
    invitedUsers: store.state.user.invited_users,
    allUsers: store.state.user.all_users,
    getSubmittedUsers: () => store.dispatch(getSubmitUsers()),
    getInvitedUsers: () => store.dispatch(getInviteUsers()),
    getAllUsers: () => store.dispatch(getAllUsers()),
  );
}

class VacanciesScreenProps1 {
  final Function getSubmittedVacancies;
  final Function getInvitedVacancies;
  final Function getUserVacancies;
  final ListVacancysState listResponse1;
  final ListVacancysState invitedList;
  final ListVacancysState allList;

  VacanciesScreenProps1({
    this.getSubmittedVacancies,
    this.getInvitedVacancies,
    this.getUserVacancies,
    this.listResponse1,
    this.invitedList,
    this.allList,
  });
}

VacanciesScreenProps1 mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps1(
    listResponse1: store.state.vacancy.submitted_list,
    invitedList: store.state.vacancy.invited_list,
    allList: store.state.vacancy.all_list,
    getSubmittedVacancies: () => store.dispatch(getSubmittedVacancies()),
    getInvitedVacancies: () => store.dispatch(getInvitedVacancies()),
    getUserVacancies: () => store.dispatch(getUserVacancies()),
  );
}

class CompanyInactiveVacanciesScreenProps {
  final Function getCompanyVacancies;
  final ListVacancysState listResponse;

  CompanyInactiveVacanciesScreenProps({
    this.getCompanyVacancies,
    this.listResponse,
  });
}

CompanyInactiveVacanciesScreenProps mapStateToVacancyProps(
    Store<AppState> store) {
  return CompanyInactiveVacanciesScreenProps(
    listResponse: store.state.vacancy.inactive_list,
    getCompanyVacancies: () => store.dispatch(getCompanyInactiveVacancies()),
  );
}
