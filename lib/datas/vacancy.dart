import 'package:ishtapp/constants/configs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';

class Vacancy {
  int id;
  String company_name;
  String company_logo;
  String name;
  String title;
  String description;
  String address;
  String salary;
  String salary_from;
  String salary_to;
  String busyness;
  String schedule;
  String region;
  String district;
  String job_type;
  String currency;
  String type;
  int company;
  int is_disability_person_vacancy;
  String opportunity;
  String opportunityType;
  String internshipLanguage;
  String opportunityDuration;
  String ageFrom;
  String ageTo;
  String typeOfRecommendedLetter;
  bool isProductLabVacancy;
  String vacancyLink;
  String deadline;

  Vacancy({
    this.id,
    this.company_name,
    this.company_logo,
    this.name,
    this.title,
    this.description,
    this.address,
    this.salary,
    this.salary_from,
    this.salary_to,
    this.busyness,
    this.schedule,
    this.job_type,
    this.region,
    this.district,
    this.currency,
    this.type,
    this.company,
    this.is_disability_person_vacancy,
    this.opportunity,
    this.opportunityType,
    this.internshipLanguage,
    this.opportunityDuration,
    this.ageFrom,
    this.ageTo,
    this.typeOfRecommendedLetter,
    this.isProductLabVacancy,
    this.vacancyLink,
    this.deadline,
  });

  static void deactivateVacancyWithOverDeadline() async {
    String url = API_IP + API_DEACTIVATE + '?lang=' + Prefs.getString(Prefs.LANGUAGE);

    try {
      Map<String, String> headers = {"Content-type": "application/json", 'Authorization': Prefs.getString(Prefs.PASSWORD)};
      var response = await http.put(url, headers: headers);

      var result = json.encode(response.body);

    } catch (error) {
      throw error;
    }
  }

  static Future<List<dynamic>> getLists(String model, String region) async {

    String url = '';

    if(region == null){
      url = API_IP + model + '?lang=' + Prefs.getString(Prefs.LANGUAGE);
    } else {
      url = API_IP + model + '?region=$region' + '&lang=' + Prefs.getString(Prefs.LANGUAGE);
    }

    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);

      print(model + ' - ' + utf8.decode(response.bodyBytes));

      return json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  static Future<List<dynamic>> getLists2(String model, String sphere) async {

    String url = '';

    if(sphere == null){
      url = API_IP + model + '?lang=' + Prefs.getString(Prefs.LANGUAGE);
    } else {
      url = API_IP + model + '?job_sphere=$sphere' + '&lang=' + Prefs.getString(Prefs.LANGUAGE);
    }

    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);

      print(model + ' - ' + utf8.decode(response.bodyBytes));

      return json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  static Future<List<dynamic>> getDistrictsById(String model, int region) async {

    String url = '';

    url = API_IP + 'districts_by_region_id' + '?region=$region' + '&lang=' + Prefs.getString(Prefs.LANGUAGE);

    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);

      print(model + ' - ' + utf8.decode(response.bodyBytes));

      return json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  factory Vacancy.fromJson(Map<String, dynamic> json) => new Vacancy(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        address: json["address"],
        salary: json['salary'],
        salary_from: json['salary_from'],
        salary_to: json['salary_to'],
        is_disability_person_vacancy: json['is_disability_person_vacancy'],
        company: json['company'],
        company_name: json['company_name'],
        company_logo: json['company_logo'],
        busyness: json['busyness'],
        schedule: json['schedule'],
        job_type: json['job_type'],
        region: json['region'],
        district: json['district'],
        type: json['type'],
        currency: json['currency'],
        opportunity: json['opportunity'],
        opportunityType: json['opportunity_type'],
        internshipLanguage: json['internship_language'],
        opportunityDuration: json['opportunity_duration'],
        ageFrom: json['age_from'],
        ageTo: json['age_to'],
        typeOfRecommendedLetter: json['recommendation_letter_type'],
        isProductLabVacancy: json['is_product_lab_vacancy'] == 1,
        vacancyLink: json['vacancy_link'],
        deadline: json['deadline']
      );

  static Map<String, dynamic> vacancyToJsonMap(Vacancy vacancy) => {
        'id': vacancy.id,
        'company_id': Prefs.getInt(Prefs.USER_ID).toString(),
        'name': vacancy.name,
        'salary': vacancy.salary,
        'salary_from': vacancy.salary_from,
        'salary_to': vacancy.salary_to,
        'is_disability_person_vacancy': vacancy.is_disability_person_vacancy,
        'description': vacancy.description,
        'region': vacancy.region,
        'district': vacancy.district,
        'busyness': vacancy.busyness,
        'schedule': vacancy.schedule,
        'job_type': vacancy.job_type,
        'currency': vacancy.currency,
        'type': vacancy.type,
        'opportunity': vacancy.opportunity,
        'opportunity_type': vacancy.opportunityType,
        'internship_language': vacancy.internshipLanguage,
        'opportunity_duration': vacancy.opportunityDuration,
        'age_from': vacancy.ageFrom,
        'age_to': vacancy.ageTo,
        'type_of_recommended_letter': vacancy.typeOfRecommendedLetter,
        'is_product_lab_vacancy': vacancy.isProductLabVacancy,
        'vacancy_link': vacancy.vacancyLink,
        'deadline': vacancy.deadline,
  };

  static List<Vacancy> getListOfVacancies() {
    getVacancyList(
        limit: 10,
        offset: 0,
        job_type_ids: [],
        region_ids: [],
        schedule_ids: [],
        busyness_ids: [],
        vacancy_type_ids: []).then((value) {
      return value;
    });
  }

  static Future<List<Vacancy>> getVacancyList({
    int limit,
    int offset,
    List job_type_ids,
    List region_ids,
    List schedule_ids,
    List busyness_ids,
    List vacancy_type_ids,
  }) async {
    final url = API_IP + API_VACANCY_LIST;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            'limit': limit,
            'offset': offset,
            'type_ids': vacancy_type_ids,
            'job_type_ids': job_type_ids,
            'schedule_ids': schedule_ids,
            'region_ids': region_ids,
            'busyness_ids': busyness_ids
          }));
      List<Vacancy> result_list = [];
      for (var i in json.decode(utf8.decode(response.bodyBytes))) {
        Vacancy model = Vacancy.fromJson(i);
        result_list.add(model);
      }

      return result_list;
    } catch (error) {
      throw error;
    }
  }

  static Future<Vacancy> getVacancyByOffset({
    int limit,
    int offset,
    String type,
    List job_type_ids,
    List region_ids,
    List schedule_ids,
    List busyness_ids,
    List vacancy_type_ids,
  }) async {
    final url =
        API_IP + API_VACANCY_LIST + '?lang=' + Prefs.getString(Prefs.LANGUAGE) + "&route=" + Prefs.getString(Prefs.ROUTE);
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            'limit': 1,
            'offset': offset,
            'type_ids': vacancy_type_ids,
            'type': type,
            'job_type_ids': job_type_ids,
            'schedule_ids': schedule_ids,
            'region_ids': region_ids,
            'busyness_ids': busyness_ids
          }));
      for (var i in json.decode(utf8.decode(response.bodyBytes))) {
        Vacancy model = Vacancy.fromJson(i);
        return model;
      }
      return null;
    } catch (error) {
      throw error;
    }
  }

  static Future<List<Vacancy>> getVacancyListByType(
    int limit,
    int offset,
    String type,
  ) async {
    final url = API_IP + API_LIKED_USER_VACANCY_LIST;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": '616bcc21ca95a4d1367ef5b6870f50e8c865205f'
      };
      final response = await http.post(url,
          headers: headers,
          body:
              json.encode({'limit': limit, 'offset': offset, 'type': 'LIKE'}));
      List<Vacancy> result_list = [];
      for (var i in json.decode(utf8.decode(response.bodyBytes))) {
        Vacancy model = Vacancy.fromJson(i);
        result_list.add(model);
      }

      return result_list;
    } catch (error) {
      throw error;
    }
  }

  static Future<String> saveVacancyUser({
    int vacancy_id,
    String type,
  }) async {
    final url = API_IP + API_VACANCY_USER_SAVE;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'vacancy_id': vacancy_id, 'type': type}));
      if(response.statusCode == 200) {
        return "OK";
      } else {
        return "ERROR";
      }
    } catch (error) {
      return "ERROR";
      throw error;
    }
  }

  static Future<String> saveCompanyVacancy({Vacancy vacancy}) async {
    final url = API_IP + API_VACANCY_SAVE + '?lang=' + Prefs.getString(Prefs.LANGUAGE);
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      var body = vacancyToJsonMap(vacancy);
      final response = await http.post(
          url,
          headers: headers,
          body: json.encode(body)
      );

      var result = json.decode(response.body);
      print(json.decode(response.body));
      return fromJsonToId(result as Map).toString();
    } catch (error) {
      return "ERROR";
      throw error;
    }
  }

  static fromJsonToId(Map<String, dynamic> json) {
    return json["id"];
  }


  static Future<String> deleteCompanyVacancy({
    int vacancy_id,
  }) async {
    final url = API_IP + API_COMPANY_VACANCY_DELETE;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(url,
          headers: headers, body: json.encode({'vacancy_id': vacancy_id}));
      return "OK";
    } catch (error) {
      return "ERROR";
      throw error;
    }
  }

  static Future<String> activateDeactiveVacancy(
      {int vacancy_id, bool active}) async {
    final url = API_IP + API_COMPANY_VACANCY_ACTIVATE_DEACTIVATE;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'vacancy_id': vacancy_id, 'active': active}));
      return "OK";
    } catch (error) {
      return "ERROR";
      throw error;
    }
  }
}

class JobType {
  int id;
  String name;

  JobType({this.id, this.name});
}

class VacancyState {
  List job_type_ids;
  String type;
  int number_of_likeds;
  int number_of_submiteds;
  int number_of_active_vacancies;
  int number_of_inactive_vacancies;
  List region_ids;
  List district_ids;
  List schedule_ids;
  List busyness_ids;
  List vacancy_type_ids;
  List opportunity_ids;
  List opportunity_type_ids;
  List opportunity_duration_ids;
  List internship_language_ids;
  ListVacancysState list;
  ListVacancysState inactive_list;
  LikedVacancyListState liked_list;
  ListSubmittedVacancyState submitted_list;
  UserState user;

  factory VacancyState.initial() => VacancyState(
      list: ListVacancysState.initial(),
      inactive_list: ListVacancysState.initial(),
      liked_list: LikedVacancyListState.initial(),
      submitted_list: ListSubmittedVacancyState.initial(),
      job_type_ids: [],
      region_ids: [],
      schedule_ids: [],
      busyness_ids: [],
      vacancy_type_ids: [],
      type: 'all',
      number_of_likeds: null,
      number_of_submiteds: 0,
      user: UserState.initial(),
  );

  VacancyState(
      {this.job_type_ids,
      this.region_ids,
      this.schedule_ids,
      this.busyness_ids,
      this.vacancy_type_ids,
      this.opportunity_ids,
      this.opportunity_type_ids,
      this.opportunity_duration_ids,
      this.internship_language_ids,
      this.list,
      this.liked_list,
      this.type,
      this.submitted_list,
      this.user,
      this.number_of_submiteds,
      this.number_of_likeds,
      this.inactive_list,
      });
}

class ListVacancysState {
  dynamic error;
  bool loading;
  List<Vacancy> data;

  ListVacancysState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListVacancysState.initial() => ListVacancysState(
        error: null,
        loading: false,
        data: [],
      );
}

class ListSubmittedVacancyState {
  dynamic error;
  bool loading;
  List<Vacancy> data;

  ListSubmittedVacancyState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListSubmittedVacancyState.initial() => ListSubmittedVacancyState(
        error: null,
        loading: false,
        data: [],
      );
}

class LikedVacancyListState {
  dynamic error;
  bool loading;
  List<Vacancy> data;

  LikedVacancyListState({
    this.error,
    this.loading,
    this.data,
  });

  factory LikedVacancyListState.initial() => LikedVacancyListState(
        error: null,
        loading: false,
        data: [],
      );
}

class VacancyType {
  int id;
  String name;

  VacancyType({this.id, this.name});
}

class Busyness {
  int id;
  String name;

  Busyness({this.id, this.name});
}

class Schedule {
  int id;
  String name;

  Schedule({this.id, this.name});
}
