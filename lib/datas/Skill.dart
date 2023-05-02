import 'package:ishtapp/constants/configs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ishtapp/datas/pref_manager.dart';

class VacancySkill {
  int id;
  int vacancyId;
  String name;
  int categoryId;
  bool isRequired;

  VacancySkill({this.id, this.vacancyId, this.name, this.categoryId, this.isRequired});

  factory VacancySkill.fromJson(Map<String, dynamic> json) => new VacancySkill(
    id: json["id"],
    vacancyId: json["vacancy_id"],
    name: json["name"],
    categoryId: json["category_id"],
    isRequired: json["is_required"] == 1,
  );

  static Future<List<VacancySkill>> getVacancySkills(int vacancyId) async {
    final url = API_IP + API_VACANCY_SKILL_GET + "?vacancy_id=$vacancyId";
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);

      Iterable l = json.decode(response.body);
      List<VacancySkill> data = List<VacancySkill>.from(l.map((model)=> VacancySkill.fromJson(model)));
      return data;
    } catch (error) {
      throw error;
    }
  }
}

class Skill {
  int id;
  int categoryId;
  String name;

  Skill({this.id, this.categoryId, this.name});
}

class SkillCategory {
  int id;
  String name;
  List<Skill> skill = [];

  SkillCategory({this.id, this.name, this.skill});

  Future<String> saveUserSkills(List<String> list, int type) async {

    // string to uri
    var uri = Uri.parse(API_IP + API_USER_SKILL_SAVE);

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          "user_id": Prefs.getInt(Prefs.USER_ID).toString(),
          "user_skills": list,
          "type": type.toString()
        }),
      );
      json.decode(response.body);
      print(json.decode(response.body));
      return "OK";
    } catch (error) {
      throw error;
    }
  }

  Future<String> saveVacancySkills(List<String> list, int categoryId, String vacancyId, bool isRequired) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_VACANCY_SKILL_SAVE);

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          "vacancy_id": vacancyId,
          "vacancy_skills": list,
          "category_id": categoryId,
          "is_required": isRequired,
        }),
      );
      json.decode(response.body);
      print(json.decode(response.body));
      return "OK";
    } catch (error) {
      throw error;
    }
  }

}