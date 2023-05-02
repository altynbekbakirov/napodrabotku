import 'package:ishtapp/datas/user_reducer.dart';
import '../datas/actions.dart';
import '../datas/app_state.dart';
import '../datas/vacancy.dart';
import '../datas/vacancy_reducer.dart';
import '../datas/chat_reducer.dart';

List<Vacancy> vacancyItemsReducer(List<Vacancy> items, dynamic action) {
  if (action is ToggleItemStateAction) {
    return toggleItemState(items, action);
  }
  return items;
}

List<Vacancy> addItem(List<Vacancy> items, AddItemAction action) {
  return new List.from(items)..add(action.item);
}

List<Vacancy> toggleItemState(
    List<Vacancy> items, ToggleItemStateAction action) {
  List<Vacancy> itemsNew = items
      .map((item) => item.name == action.item.name ? action.item : item)
      .toList();
  return itemsNew;
}

AppState appReducer(AppState state, action) {
  return AppState(
      vacancy: vacancyReducer(state.vacancy, action),
      user: userReducer(state.user, action),
      chat: chatReducer(state.chat, action));
}
