import 'dart:convert';

import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_api_middleware/redux_api_middleware.dart';

import 'package:ishtapp/datas/app_state.dart';

const LIST_VACANCIES_REQUEST = 'LIST_VACANCIES_REQUEST';
const LIST_VACANCIES_SUCCESS = 'LIST_VACANCIES_SUCCESS';
const LIST_VACANCIES_FAILURE = 'LIST_VACANCIES_FAILURE';

RSAA getVacanciesRequest(
    {List job_type_ids,
    List region_ids,
    List district_ids,
    List schedule_ids,
    List busyness_ids,
    List vacancy_type_ids,
    List opportunity_ids,
    List opportunity_type_ids,
    List opportunity_duration_ids,
    List internship_language_ids,
    String type}) {
  return RSAA(
    method: 'POST',
    endpoint: API_IP + API_VACANCY_LIST + "?lang=" + Prefs.getString(Prefs.LANGUAGE) + "&route=" + Prefs.getString(Prefs.ROUTE),
    body: json.encode({
      'limit': 5,
      'lang': Prefs.getString(Prefs.LANGUAGE),
      'offset': 0,
      'type': type,
      'type_ids': vacancy_type_ids,
      'job_type_ids': job_type_ids,
      'schedule_ids': schedule_ids,
      'region_ids': region_ids,
      'district_ids': district_ids,
      'busyness_ids': busyness_ids,
      'opportunity_ids': opportunity_ids,
      'opportunity_type_ids': opportunity_type_ids,
      'opportunity_duration_ids': opportunity_duration_ids,
      'internship_language_ids': internship_language_ids,
    }),
    types: [
      LIST_VACANCIES_REQUEST,
      LIST_VACANCIES_SUCCESS,
      LIST_VACANCIES_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN) != null ? Prefs.getString(Prefs.TOKEN) : 'null',
    },
  );
}

ThunkAction<AppState> getVacancies() =>
    (Store<AppState> store) => store.dispatch(getVacanciesRequest(
        job_type_ids: store.state.vacancy.job_type_ids,
        region_ids: store.state.vacancy.region_ids,
        district_ids: store.state.vacancy.district_ids,
        schedule_ids: store.state.vacancy.schedule_ids,
        busyness_ids: store.state.vacancy.busyness_ids,
        vacancy_type_ids: store.state.vacancy.vacancy_type_ids,
        type: store.state.vacancy.type,
        opportunity_ids: store.state.vacancy.opportunity_ids,
        opportunity_type_ids: store.state.vacancy.opportunity_type_ids,
        opportunity_duration_ids: store.state.vacancy.opportunity_duration_ids,
        internship_language_ids: store.state.vacancy.internship_language_ids,
    ));
ThunkAction<AppState> deleteItem() =>
    (Store<AppState> store) => store.state.vacancy.list.data.removeLast();

ThunkAction<AppState> setFilter({
  List job_type_ids,
  List region_ids,
  List district_ids,
  List schedule_ids,
  List busyness_ids,
  List vacancy_type_ids,
  List opportunity_ids,
  List opportunity_type_ids,
  List opportunity_duration_ids,
  List internship_language_ids,
}) =>
    (Store<AppState> store) {
      store.state.vacancy.job_type_ids = job_type_ids;
      store.state.vacancy.schedule_ids = schedule_ids;
      store.state.vacancy.region_ids = region_ids;
      store.state.vacancy.district_ids = district_ids;
      store.state.vacancy.vacancy_type_ids = vacancy_type_ids;
      store.state.vacancy.busyness_ids = busyness_ids;
      store.state.vacancy.opportunity_ids = opportunity_ids;
      store.state.vacancy.opportunity_type_ids = opportunity_type_ids;
      store.state.vacancy.opportunity_duration_ids = opportunity_duration_ids;
      store.state.vacancy.internship_language_ids = internship_language_ids;
    };

ThunkAction<AppState> setTimeFilter({String type}) => (Store<AppState> store) {
      store.state.vacancy.type = type;
    };

const GET_LIKED_VACANCY_REQUEST = 'GET_LIKED_VACANCY_REQUEST';
const GET_LIKED_VACANCY_SUCCESS = 'GET_LIKED_VACANCY_SUCCESS';
const GET_LIKED_VACANCY_FAILURE = 'GET_LIKED_VACANCY_FAILURE';
const DELETE_ITEM = 'DELETE_ITEM';

RSAA getLikedVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_LIKED_USER_VACANCY_LIST +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_LIKED_VACANCY_REQUEST,
      GET_LIKED_VACANCY_SUCCESS,
      GET_LIKED_VACANCY_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getLikedVacancies() =>
    (Store<AppState> store) => store.dispatch(getLikedVacancyRequest());

const GET_SUBMITTED_VACANCY_REQUEST = 'GET_SUBMITTED_VACANCY_REQUEST';
const GET_SUBMITTED_VACANCY_SUCCESS = 'GET_SUBMITTED_VACANCY_SUCCESS';
const GET_SUBMITTED_VACANCY_FAILURE = 'GET_SUBMITTED_VACANCY_FAILURE';
RSAA getSubmittedVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_SUBMITTED_USER_VACANCY_LIST +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_SUBMITTED_VACANCY_REQUEST,
      GET_SUBMITTED_VACANCY_SUCCESS,
      GET_SUBMITTED_VACANCY_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getSubmittedVacancies() =>
    (Store<AppState> store) => store.dispatch(getSubmittedVacancyRequest());

ThunkAction<AppState> deleteItem1() =>
    (Store<AppState> store) => store.state.vacancy.list.data.removeLast();

const GET_LIKED_VACANCY_NUMBER_REQUEST = 'GET_LIKED_VACANCY_NUMBER_REQUEST';
const GET_LIKED_VACANCY_NUMBER_SUCCESS = 'GET_LIKED_VACANCY_NUMBER_SUCCESS';
const GET_LIKED_VACANCY_NUMBER_FAILURE = 'GET_LIKED_VACANCY_NUMBER_FAILURE';
RSAA getNumOfLikedVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_VACANCY_NUMBER_LIKED,
    types: [
      GET_LIKED_VACANCY_NUMBER_REQUEST,
      GET_LIKED_VACANCY_NUMBER_SUCCESS,
      GET_LIKED_VACANCY_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getNumberOfLikedVacancies() =>
    (Store<AppState> store) => store.dispatch(getNumOfLikedVacancyRequest());

const GET_SUBMITTED_VACANCY_NUMBER_REQUEST =
    'GET_SUBMITTED_VACANCY_NUMBER_REQUEST';
const GET_SUBMITTED_VACANCY_NUMBER_SUCCESS =
    'GET_SUBMITTED_VACANCY_NUMBER_SUCCESS';
const GET_SUBMITTED_VACANCY_NUMBER_FAILURE =
    'GET_SUBMITTED_VACANCY_NUMBER_FAILURE';
RSAA getNumOfSubmittedVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_VACANCY_NUMBER_SUBMITTED,
    types: [
      GET_SUBMITTED_VACANCY_NUMBER_REQUEST,
      GET_SUBMITTED_VACANCY_NUMBER_SUCCESS,
      GET_SUBMITTED_VACANCY_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getNumberOfSubmittedVacancies() =>
    (Store<AppState> store) =>
        store.dispatch(getNumOfSubmittedVacancyRequest());

const GET_USER_REQUEST = 'GET_USER_REQUEST';
const GET_USER_SUCCESS = 'GET_USER_SUCCESS';
const GET_USER_FAILURE = 'GET_USER_FAILURE';
RSAA getUserRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_GET_USER + '?lang=' + Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_USER_REQUEST,
      GET_USER_SUCCESS,
      GET_USER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getUser() =>
    (Store<AppState> store) => store.dispatch(getUserRequest());

const GET_USER_CV_REQUEST = 'GET_USER_CV_REQUEST';
const GET_USER_CV_SUCCESS = 'GET_USER_CV_SUCCESS';
const GET_USER_CV_FAILURE = 'GET_USER_CV_FAILURE';
RSAA getUserCvRequest() {
  return RSAA(
    method: 'GET',
    endpoint:
        API_IP + API_GET_USER_CV + '?lang=' + Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_USER_CV_REQUEST,
      GET_USER_CV_SUCCESS,
      GET_USER_CV_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getUserCv() =>
    (Store<AppState> store) => store.dispatch(getUserCvRequest());

const GET_COMPANY_VACANCIES_REQUEST = 'GET_COMPANY_VACANCIES_REQUEST';
const GET_COMPANY_VACANCIES_SUCCESS = 'GET_COMPANY_VACANCIES_SUCCESS';
const GET_COMPANY_VACANCIES_FAILURE = 'GET_COMPANY_VACANCIES_FAILURE';
RSAA getCompanyVacanciesRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_COMPANY_VACANCIES +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_COMPANY_VACANCIES_REQUEST,
      GET_COMPANY_VACANCIES_SUCCESS,
      GET_COMPANY_VACANCIES_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getCompanyVacancies() =>
    (Store<AppState> store) => store.dispatch(getCompanyVacanciesRequest());

const GET_COMPANY_INACTIVE_VACANCIES_REQUEST =
    'GET_COMPANY_INACTIVE_VACANCIES_REQUEST';
const GET_COMPANY_INACTIVE_VACANCIES_SUCCESS =
    'GET_COMPANY_INACTIVE_VACANCIES_SUCCESS';
const GET_COMPANY_INACTIVE_VACANCIES_FAILURE =
    'GET_COMPANY_INACTIVE_VACANCIES_FAILURE';
RSAA getCompanyInactiveVacanciesRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_COMPANY_INACTIVE_VACANCIES +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_COMPANY_INACTIVE_VACANCIES_REQUEST,
      GET_COMPANY_INACTIVE_VACANCIES_SUCCESS,
      GET_COMPANY_INACTIVE_VACANCIES_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getCompanyInactiveVacancies() =>
    (Store<AppState> store) =>
        store.dispatch(getCompanyInactiveVacanciesRequest());

const GET_SUBMITTED_USER_REQUEST = 'GET_SUBMITTED_USER_REQUEST';
const GET_SUBMITTED_USER_SUCCESS = 'GET_SUBMITTED_USER_SUCCESS';
const GET_SUBMITTED_USER_FAILURE = 'GET_SUBMITTED_USER_FAILURE';
RSAA getSubmittedUsersRequest() {
  return RSAA(
    method: 'POST',
    endpoint:
        API_IP + API_SUBMITTED_USERS + Prefs.getInt(Prefs.USER_ID).toString(),
    types: [
      GET_SUBMITTED_USER_REQUEST,
      GET_SUBMITTED_USER_SUCCESS,
      GET_SUBMITTED_USER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getSubmittedUsers() =>
    (Store<AppState> store) => store.dispatch(getSubmittedUsersRequest());

const GET_USER_FULL_INFO_REQUEST = 'GET_USER_FULL_INFO_REQUEST';
const GET_USER_FULL_INFO_SUCCESS = 'GET_USER_FULL_INFO_SUCCESS';
const GET_USER_FULL_INFO_FAILURE = 'GET_USER_FULL_INFO_FAILURE';
RSAA getUserFullInfoRequest(int user_id) {
  return RSAA(
    method: 'POST',
    endpoint: API_IP + API_USER_FULL_INFO + user_id.toString(),
    types: [
      GET_USER_FULL_INFO_REQUEST,
      GET_USER_FULL_INFO_SUCCESS,
      GET_USER_FULL_INFO_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getUserFullInfo(int user_id) =>
    (Store<AppState> store) => store.dispatch(getUserFullInfoRequest(user_id));

const GET_ACTIVE_VACANCY_NUMBER_REQUEST = 'GET_ACTIVE_VACANCY_NUMBER_REQUEST';
const GET_ACTIVE_VACANCY_NUMBER_SUCCESS = 'GET_ACTIVE_VACANCY_NUMBER_SUCCESS';
const GET_ACTIVE_VACANCY_NUMBER_FAILURE = 'GET_ACTIVE_VACANCY_NUMBER_FAILURE';
RSAA getNumOfActiveVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_ACTIVE_VACANCY_NUMBER,
    types: [
      GET_ACTIVE_VACANCY_NUMBER_REQUEST,
      GET_ACTIVE_VACANCY_NUMBER_SUCCESS,
      GET_ACTIVE_VACANCY_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getNumberOfActiveVacancies() =>
    (Store<AppState> store) => store.dispatch(getNumOfActiveVacancyRequest());

const GET_INACTIVE_VACANCY_NUMBER_REQUEST =
    'GET_INACTIVE_VACANCY_NUMBER_REQUEST';
const GET_INACTIVE_VACANCY_NUMBER_SUCCESS =
    'GET_INACTIVE_VACANCY_NUMBER_SUCCESS';
const GET_INACTIVE_VACANCY_NUMBER_FAILURE =
    'GET_INACTIVE_VACANCY_NUMBER_FAILURE';
RSAA getNumOfInactiveVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_INACTIVE_VACANCY_NUMBER,
    types: [
      GET_INACTIVE_VACANCY_NUMBER_REQUEST,
      GET_INACTIVE_VACANCY_NUMBER_SUCCESS,
      GET_INACTIVE_VACANCY_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getNumberOfInactiveVacancies() =>
    (Store<AppState> store) => store.dispatch(getNumOfInactiveVacancyRequest());

//CHAT
const GET_CHAT_LIST_REQUEST = 'GET_CHAT_LIST_REQUEST';
const GET_CHAT_LIST_SUCCESS = 'GET_CHAT_LIST_SUCCESS';
const GET_CHAT_LIST_FAILURE = 'GET_CHAT_LIST_FAILURE';
RSAA getChatListRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_CHAT_LIST,
    types: [
      GET_CHAT_LIST_REQUEST,
      GET_CHAT_LIST_SUCCESS,
      GET_CHAT_LIST_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getChatList() =>
    (Store<AppState> store) => store.dispatch(getChatListRequest());

const GET_MESSAGE_LIST_REQUEST = 'GET_MESSAGE_LIST_REQUEST';
const GET_MESSAGE_LIST_SUCCESS = 'GET_MESSAGE_LIST_SUCCESS';
const GET_MESSAGE_LIST_FAILURE = 'GET_MESSAGE_LIST_FAILURE';
RSAA getMessageListRequest(int receiver_id) {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_MESSAGE_LIST + "/" + receiver_id.toString(),
    types: [
      GET_MESSAGE_LIST_REQUEST,
      GET_MESSAGE_LIST_SUCCESS,
      GET_MESSAGE_LIST_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getMessageList(int receiver_id) =>
    (Store<AppState> store) =>
        store.dispatch(getMessageListRequest(receiver_id));
