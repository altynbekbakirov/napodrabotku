import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/datas/chat.dart';

class AppState {
  VacancyState vacancy;
  UserState user;
  ChatState chat;

  AppState({this.user, this.vacancy, this.chat});

  AppState.fromAppState(AppState another) {
    vacancy = another.vacancy;
    user = another.user;
    chat = another.chat;
  }

  factory AppState.initial() => AppState(
      vacancy: VacancyState.initial(),
      user: UserState.initial(),
      chat: ChatState.initial()
  );

  AppState copyWith({VacancyState vacancy, UserState user, ChatState chat}) {
    return AppState(
        vacancy: vacancy ?? this.vacancy,
        user: user ?? this.user,
        chat: chat ?? this.chat);
  }
}
