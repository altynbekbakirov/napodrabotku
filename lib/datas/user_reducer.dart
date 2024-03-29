import 'dart:convert';

import 'package:ishtapp/datas/actions_liked.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:redux_api_middleware/redux_api_middleware.dart';
import 'package:ishtapp/datas/vacancy.dart';

import 'RSAA.dart';

UserState userReducer(UserState state, FSA action) {
  UserState newState = state;

  switch (action.type) {
    case LIST_USERS_REQUEST:
      newState.list.error = null;
      newState.list.loading = true;
      newState.list.data = null;
      return newState;

    case LIST_USERS_SUCCESS:
      newState.list.error = null;
      newState.list.loading = false;
      newState.list.data = usersFromJsonStr(action.payload);
      return newState;

    case LIST_USERS_FAILURE:
      newState.list.error = action.payload;
      newState.list.loading = false;
      newState.list.data = null;
      return newState;

    case GET_USER_REQUEST:
      newState.user.error = null;
      newState.user.loading = true;
      newState.user.data = null;
      return newState;

    case GET_USER_SUCCESS:
      newState.user.error = null;
      newState.user.loading = false;
      newState.user.data = userFromJSONStr(action.payload);
      return newState;

    case GET_USER_FAILURE:
      newState.user.error = action.payload;
      newState.user.loading = false;
      newState.user.data = null;
      return newState;

    case GET_USER_CV_REQUEST:
      newState.user_cv.error = null;
      newState.user_cv.loading = true;
      newState.user_cv.data = null;
      return newState;

    case GET_USER_CV_SUCCESS:
      newState.user_cv.error = null;
      newState.user_cv.loading = false;
      newState.user_cv.data = userCvFromJSONStr(action.payload);
      return newState;

    case GET_USER_CV_FAILURE:
      newState.user_cv.error = action.payload;
      newState.user_cv.loading = false;
      newState.user_cv.data = null;
      return newState;

    case GET_SUBMITTED_USER_REQUEST:
      newState.submitted_user_list.error = null;
      newState.submitted_user_list.loading = true;
      newState.submitted_user_list.data = null;
      return newState;

    case GET_SUBMITTED_USER_SUCCESS:
      newState.submitted_user_list.error = null;
      newState.submitted_user_list.loading = false;
      newState.submitted_user_list.data = usersFromJsonStr(action.payload);
      return newState;

    case GET_SUBMITTED_USER_FAILURE:
      newState.submitted_user_list.error = action.payload;
      newState.submitted_user_list.loading = false;
      newState.submitted_user_list.data = null;
      return newState;

    case GET_USER_FULL_INFO_REQUEST:
      newState.user_full_info.error = null;
      newState.user_full_info.loading = true;
      newState.user_full_info.data = null;
      return newState;

    case GET_USER_FULL_INFO_SUCCESS:
      newState.user_full_info.error = null;
      newState.user_full_info.loading = false;
      newState.user_full_info.data = userFullInfoFromJSONStr(action.payload);
      return newState;

    case GET_USER_FULL_INFO_FAILURE:
      newState.user_full_info.error = action.payload;
      newState.user_full_info.loading = false;
      newState.user_full_info.data = null;
      return newState;

    case GET_LIKED_USERS_REQUEST:
      newState.liked_user_list.error = null;
      newState.liked_user_list.loading = true;
      newState.liked_user_list.data = null;
      return newState;

    case GET_LIKED_USERS_SUCCESS:
      newState.liked_user_list.error = null;
      newState.liked_user_list.loading = false;
      newState.liked_user_list.data = usersFromJsonStr(action.payload);
      return newState;

    case GET_LIKED_USERS_FAILURE:
      newState.liked_user_list.error = action.payload;
      newState.liked_user_list.loading = false;
      newState.liked_user_list.data = null;
      return newState;

    case GET_ALL_USERS_REQUEST:
      newState.all_users.error = null;
      newState.all_users.loading = true;
      newState.all_users.data = null;
      return newState;

    case GET_ALL_USERS_SUCCESS:
      newState.all_users.error = null;
      newState.all_users.loading = false;
      newState.all_users.data = usersFromJsonStr(action.payload);
      return newState;

    case GET_ALL_USERS_FAILURE:
      newState.all_users.error = action.payload;
      newState.all_users.loading = false;
      newState.all_users.data = null;
      return newState;

    case GET_SUBMITTED_USERS_REQUEST:
      newState.submitted_users.error = null;
      newState.submitted_users.loading = true;
      newState.submitted_users.data = null;
      return newState;

    case GET_SUBMITTED_USERS_SUCCESS:
      newState.submitted_users.error = null;
      newState.submitted_users.loading = false;
      newState.submitted_users.data = usersFromJsonStr(action.payload);
      return newState;

    case GET_SUBMITTED_USERS_FAILURE:
      newState.submitted_users.error = action.payload;
      newState.submitted_users.loading = false;
      newState.submitted_users.data = null;
      return newState;

    case GET_INVITED_USERS_REQUEST:
      newState.invited_users.error = null;
      newState.invited_users.loading = true;
      newState.invited_users.data = null;
      return newState;

    case GET_INVITED_USERS_SUCCESS:
      newState.invited_users.error = null;
      newState.invited_users.loading = false;
      newState.invited_users.data = usersFromJsonStr(action.payload);
      return newState;

    case GET_INVITED_USERS_FAILURE:
      newState.invited_users.error = action.payload;
      newState.invited_users.loading = false;
      newState.invited_users.data = null;
      return newState;

    case GET_UNREAD_USER_VACANCY_NUMBER_REQUEST:
      newState.numberOfUnreadResponses = 0;
      return newState;

    case GET_UNREAD_USER_VACANCY_NUMBER_SUCCESS:
      newState.numberOfUnreadResponses = int.parse(action.payload);
      return newState;

    case GET_UNREAD_USER_VACANCY_NUMBER_FAILURE:
      newState.numberOfUnreadResponses = 0;
      return newState;

    default:
      return newState;
  }
}

Users userFromJSONStr(dynamic payload) {
  return Users.fromJson(json.decode(payload));
}

UserCv userCvFromJSONStr(dynamic payload) {
  return UserCv.fromJson(json.decode(payload)[0]);
}

UserFullInfo userFullInfoFromJSONStr(dynamic payload) {
  return UserFullInfo.fromJson(json.decode(payload));
}

List<Users> usersFromJsonStr(dynamic payload) {
  Iterable jsonArray = json.decode(payload);
  return jsonArray.map((j) => Users.fromJson(j)).toList();
}
