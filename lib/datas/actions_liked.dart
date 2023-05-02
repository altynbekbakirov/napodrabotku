import 'package:ishtapp/datas/vacancy.dart';

class AddLikedItemAction {
  final Vacancy vacancy;

  AddLikedItemAction(this.vacancy);
}

class RemoveLikedItemAction {
  final Vacancy vacancy;

  RemoveLikedItemAction(this.vacancy);
}
