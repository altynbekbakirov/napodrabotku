import 'dart:convert';

import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_api_middleware/redux_api_middleware.dart';

import 'package:ishtapp/datas/app_state.dart';

const LIST_USERS_REQUEST = 'LIST_USERS_REQUEST';
const LIST_USERS_SUCCESS = 'LIST_USERS_SUCCESS';
const LIST_USERS_FAILURE = 'LIST_USERS_FAILURE';

RSAA getUsersRequest({
  String type,
  List job_type_ids,
  List region_ids,
  List district_ids,
  List schedule_ids,
  List busyness_ids,
  List vacancy_type_ids,
  List gender_ids,
  List country_ids,
}) {
  return RSAA(
    method: 'POST',
    endpoint: API_IP + API_USERS_LIST,
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
      'gender_ids': gender_ids,
      'country_ids': country_ids,
    }),
    types: [
      LIST_USERS_REQUEST,
      LIST_USERS_SUCCESS,
      LIST_USERS_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN) != null ? Prefs.getString(Prefs.TOKEN) : 'null',
    },
  );
}

ThunkAction<AppState> getUsers() => (Store<AppState> store) => store.dispatch(getUsersRequest(
  type: store.state.user.type,
  region_ids: store.state.user.region_ids,
  district_ids: store.state.user.district_ids,
  schedule_ids: store.state.user.schedule_ids,
  busyness_ids: store.state.user.busyness_ids,
  vacancy_type_ids: store.state.user.vacancy_type_ids,
  gender_ids: store.state.user.gender_ids,
  country_ids: store.state.user.country_ids,
));

ThunkAction<AppState> setUserFilter({
  List region_ids,
  List district_ids,
  List vacancy_type_ids,
  List schedule_ids,
  List busyness_ids,
  List gender_ids,
  List country_ids,
}) =>
        (Store<AppState> store) {
      store.state.user.region_ids = region_ids;
      store.state.user.district_ids = district_ids;
      store.state.user.vacancy_type_ids = vacancy_type_ids;
      store.state.user.schedule_ids = schedule_ids;
      store.state.user.busyness_ids = busyness_ids;
      store.state.user.gender_ids = gender_ids;
      store.state.user.country_ids = country_ids;
    };

const LIST_VACANCIES_REQUEST = 'LIST_VACANCIES_REQUEST';
const LIST_VACANCIES_SUCCESS = 'LIST_VACANCIES_SUCCESS';
const LIST_VACANCIES_FAILURE = 'LIST_VACANCIES_FAILURE';

RSAA getVacanciesRequest(
    {List job_type_ids,
      List region_ids,
      List district_ids,
      List metros,
      List schedule_ids,
      List busyness_ids,
      List vacancy_type_ids,
      String type}) {
  return RSAA(
    method: 'POST',
    endpoint: API_IP + API_VACANCY_LIST + "?lang=" + Prefs.getString(Prefs.LANGUAGE) + "&route=" + Prefs.getString(Prefs.ROUTE),
    body: json.encode({
      'limit': 4,
      'lang': Prefs.getString(Prefs.LANGUAGE),
      'offset': 0,
      'type': type,
      'type_ids': vacancy_type_ids,
      'job_type_ids': job_type_ids,
      'schedule_ids': schedule_ids,
      'region_ids': region_ids,
      'district_ids': district_ids,
      'metros': metros,
      'busyness_ids': busyness_ids,
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
      metros: store.state.vacancy.metros,
      district_ids: store.state.vacancy.district_ids,
      schedule_ids: store.state.vacancy.schedule_ids,
      busyness_ids: store.state.vacancy.busyness_ids,
      vacancy_type_ids: store.state.vacancy.vacancy_type_ids,
      type: store.state.vacancy.type,
    ));

const LIST_MAP_VACANCIES_REQUEST = 'LIST_MAP_VACANCIES_REQUEST';
const LIST_MAP_VACANCIES_SUCCESS = 'LIST_MAP_VACANCIES_SUCCESS';
const LIST_MAP_VACANCIES_FAILURE = 'LIST_MAP_VACANCIES_FAILURE';

RSAA getMapVacanciesRequest({ List region_ids }) {
  return RSAA(
    method: 'POST',
    endpoint: API_IP + API_MAP_VACANCY_LIST + "?lang=" + Prefs.getString(Prefs.LANGUAGE) + "&route=" + Prefs.getString(Prefs.ROUTE),
    body: json.encode({
      'limit': 99,
      'lang': Prefs.getString(Prefs.LANGUAGE),
      'offset': 0,
      'region_ids': region_ids,
    }),
    types: [
      LIST_MAP_VACANCIES_REQUEST,
      LIST_MAP_VACANCIES_SUCCESS,
      LIST_MAP_VACANCIES_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN) != null ? Prefs.getString(Prefs.TOKEN) : 'null',
    },
  );
}

ThunkAction<AppState> getMapVacancies() =>
        (Store<AppState> store) => store.dispatch(getMapVacanciesRequest(
      region_ids: store.state.vacancy.region_ids,
    ));

ThunkAction<AppState> deleteItem() =>
        (Store<AppState> store) => store.state.vacancy.list.data.removeLast();

ThunkAction<AppState> setFilter({
  List job_type_ids,
  List region_ids,
  List district_ids,
  List metros,
  List schedule_ids,
  List busyness_ids,
  List vacancy_type_ids,
}) =>
        (Store<AppState> store) {
      store.state.vacancy.job_type_ids = job_type_ids;
      store.state.vacancy.schedule_ids = schedule_ids;
      store.state.vacancy.region_ids = region_ids;
      store.state.vacancy.district_ids = district_ids;
      store.state.vacancy.metros = metros;
      store.state.vacancy.vacancy_type_ids = vacancy_type_ids;
      store.state.vacancy.busyness_ids = busyness_ids;
    };

ThunkAction<AppState> setTimeFilter({String type}) => (Store<AppState> store) {
  store.state.vacancy.type = type;
  store.state.user.type = type;
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

const GET_USER_VACANCY_REQUEST = 'GET_USER_VACANCY_REQUEST';
const GET_USER_VACANCY_SUCCESS = 'GET_USER_VACANCY_SUCCESS';
const GET_USER_VACANCY_FAILURE = 'GET_USER_VACANCY_FAILURE';
RSAA getUserVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_USER_VACANCY_LIST +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_USER_VACANCY_REQUEST,
      GET_USER_VACANCY_SUCCESS,
      GET_USER_VACANCY_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getUserVacancies() =>
        (Store<AppState> store) => store.dispatch(getUserVacancyRequest());

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

const GET_INVITED_VACANCY_REQUEST = 'GET_INVITED_VACANCY_REQUEST';
const GET_INVITED_VACANCY_SUCCESS = 'GET_INVITED_VACANCY_SUCCESS';
const GET_INVITED_VACANCY_FAILURE = 'GET_INVITED_VACANCY_FAILURE';
RSAA getInvitedVacancyRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_INVITED_USER_VACANCY_LIST +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_INVITED_VACANCY_REQUEST,
      GET_INVITED_VACANCY_SUCCESS,
      GET_INVITED_VACANCY_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getInvitedVacancies() =>
        (Store<AppState> store) => store.dispatch(getInvitedVacancyRequest());

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


const GET_UNREAD_USER_VACANCY_NUMBER_REQUEST = 'GET_UNREAD_USER_VACANCY_NUMBER_REQUEST';
const GET_UNREAD_USER_VACANCY_NUMBER_SUCCESS = 'GET_UNREAD_USER_VACANCY_NUMBER_SUCCESS';
const GET_UNREAD_USER_VACANCY_NUMBER_FAILURE = 'GET_UNREAD_USER_VACANCY_NUMBER_FAILURE';
RSAA getNumOfUnreadResponsesRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_GET_UNREAD_RESPONSES,
    types: [
      GET_UNREAD_USER_VACANCY_NUMBER_REQUEST,
      GET_UNREAD_USER_VACANCY_NUMBER_SUCCESS,
      GET_UNREAD_USER_VACANCY_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getNumberOfUnreadResponses() =>
        (Store<AppState> store) => store.dispatch(getNumOfUnreadResponsesRequest());

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

const GET_COMPANY_ACTIVE_VACANCIES_REQUEST =
    'GET_COMPANY_ACTIVE_VACANCIES_REQUEST';
const GET_COMPANY_ACTIVE_VACANCIES_SUCCESS =
    'GET_COMPANY_ACTIVE_VACANCIES_SUCCESS';
const GET_COMPANY_ACTIVE_VACANCIES_FAILURE =
    'GET_COMPANY_ACTIVE_VACANCIES_FAILURE';
RSAA getCompanyActiveVacanciesRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_COMPANY_ACTIVE_VACANCIES +
        '?lang=' +
        Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_COMPANY_ACTIVE_VACANCIES_REQUEST,
      GET_COMPANY_ACTIVE_VACANCIES_SUCCESS,
      GET_COMPANY_ACTIVE_VACANCIES_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getCompanyActiveVacancies() =>
        (Store<AppState> store) =>
        store.dispatch(getCompanyActiveVacanciesRequest());



const GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_REQUEST =
    'GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_REQUEST';
const GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_SUCCESS =
    'GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_SUCCESS';
const GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_FAILURE =
    'GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_FAILURE';
RSAA getCompanyActiveVacanciesForUserRequest(int userId) {
  return RSAA(
    method: 'GET',
    endpoint: API_IP +
        API_COMPANY_ACTIVE_VACANCIES +
        '?lang=$Prefs.getString(Prefs.LANGUAGE)'
        + '&user_id=$userId',
    types: [
      GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_REQUEST,
      GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_SUCCESS,
      GET_COMPANY_ACTIVE_VACANCIES_FOR_USER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getCompanyActiveVacanciesForUser(int userId) =>
        (Store<AppState> store) =>
        store.dispatch(getCompanyActiveVacanciesForUserRequest(userId));

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
RSAA getMessageListRequest(int receiver_id, int vacancy_id) {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_MESSAGE_LIST + "/" + receiver_id.toString() + "/" + vacancy_id.toString(),
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

const GET_UNREAD_MESSAGES_NUMBER_REQUEST = 'GET_UNREAD_MESSAGES_NUMBER_REQUEST';
const GET_UNREAD_MESSAGES_NUMBER_SUCCESS = 'GET_UNREAD_MESSAGES_NUMBER_SUCCESS';
const GET_UNREAD_MESSAGES_NUMBER_FAILURE = 'GET_UNREAD_MESSAGES_NUMBER_FAILURE';
RSAA getNumOfUnreadMessagesRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_UNREAD_MESSAGES,
    types: [
      GET_UNREAD_MESSAGES_NUMBER_REQUEST,
      GET_UNREAD_MESSAGES_NUMBER_SUCCESS,
      GET_UNREAD_MESSAGES_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}
ThunkAction<AppState> getNumberOfUnreadMessages() =>
        (Store<AppState> store) =>
        store.dispatch(getNumOfUnreadMessagesRequest());

ThunkAction<AppState> getMessageList(int receiver_id, int vacancy_id) =>
        (Store<AppState> store) =>
        store.dispatch(getMessageListRequest(receiver_id, vacancy_id));

const GET_LIKED_USER_COMPANY_NUMBER_REQUEST = 'GET_LIKED_USER_COMPANY_NUMBER_REQUEST';
const GET_LIKED_USER_COMPANY_NUMBER_SUCCESS = 'GET_LIKED_USER_COMPANY_NUMBER_SUCCESS';
const GET_LIKED_USER_COMPANY_NUMBER_FAILURE = 'GET_LIKED_USER_COMPANY_NUMBER_FAILURE';
RSAA getNumOfLikedUsersRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_USER_COMPANY_NUMBER_LIKED,
    types: [
      GET_LIKED_USER_COMPANY_NUMBER_REQUEST,
      GET_LIKED_USER_COMPANY_NUMBER_SUCCESS,
      GET_LIKED_USER_COMPANY_NUMBER_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getNumberOfLikedUsers() =>
        (Store<AppState> store) => store.dispatch(getNumOfLikedUsersRequest());


const GET_LIKED_USERS_REQUEST = 'GET_LIKED_USERS_REQUEST';
const GET_LIKED_USERS_SUCCESS = 'GET_LIKED_USERS_SUCCESS';
const GET_LIKED_USERS_FAILURE = 'GET_LIKED_USERS_FAILURE';
RSAA getLikedUsersRequest() {
  return RSAA(
    method: 'POST',
    endpoint: API_IP + API_LIKED_USERS + Prefs.getInt(Prefs.USER_ID).toString(),
    types: [
      GET_LIKED_USERS_REQUEST,
      GET_LIKED_USERS_SUCCESS,
      GET_LIKED_USERS_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getLikedUsers() =>
        (Store<AppState> store) => store.dispatch(getLikedUsersRequest());

const GET_ALL_USERS_REQUEST = 'GET_ALL_USERS_REQUEST';
const GET_ALL_USERS_SUCCESS = 'GET_ALL_USERS_SUCCESS';
const GET_ALL_USERS_FAILURE = 'GET_ALL_USERS_FAILURE';
RSAA getAllUsersRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_ALL_USERS + "?lang=" + Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_ALL_USERS_REQUEST,
      GET_ALL_USERS_SUCCESS,
      GET_ALL_USERS_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getAllUsers() =>
        (Store<AppState> store) => store.dispatch(getAllUsersRequest());

const GET_SUBMITTED_USERS_REQUEST = 'GET_SUBMITTED_USERS_REQUEST';
const GET_SUBMITTED_USERS_SUCCESS = 'GET_SUBMITTED_USERS_SUCCESS';
const GET_SUBMITTED_USERS_FAILURE = 'GET_SUBMITTED_USERS_FAILURE';
RSAA getSubmitUsersRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_SUBMIT_USERS + "?lang=" + Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_SUBMITTED_USERS_REQUEST,
      GET_SUBMITTED_USERS_SUCCESS,
      GET_SUBMITTED_USERS_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getSubmitUsers() =>
        (Store<AppState> store) => store.dispatch(getSubmitUsersRequest());

const GET_INVITED_USERS_REQUEST = 'GET_INVITED_USERS_REQUEST';
const GET_INVITED_USERS_SUCCESS = 'GET_INVITED_USERS_SUCCESS';
const GET_INVITED_USERS_FAILURE = 'GET_INVITED_USERS_FAILURE';
RSAA getInviteUsersRequest() {
  return RSAA(
    method: 'GET',
    endpoint: API_IP + API_INVITE_USERS + "?lang=" + Prefs.getString(Prefs.LANGUAGE),
    types: [
      GET_INVITED_USERS_REQUEST,
      GET_INVITED_USERS_SUCCESS,
      GET_INVITED_USERS_FAILURE,
    ],
    headers: {
      'Content-Type': 'application/json',
      'Authorization': Prefs.getString(Prefs.TOKEN),
    },
  );
}

ThunkAction<AppState> getInviteUsers() =>
        (Store<AppState> store) => store.dispatch(getInviteUsersRequest());
