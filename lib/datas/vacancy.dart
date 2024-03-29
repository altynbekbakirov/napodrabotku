import 'dart:io';

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
  String street;
  String houseNumber;
  String latitude;
  String longitude;
  String job_type;
  String currency;
  String period;
  String experience;
  String payPeriod;
  String type;
  int company;
  String status;
  String statusText;
  String responseType;
  bool responseRead;

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
    this.street,
    this.houseNumber,
    this.latitude,
    this.longitude,
    this.currency,
    this.period,
    this.experience,
    this.payPeriod,
    this.type,
    this.company,
    this.status,
    this.statusText,
    this.responseType,
    this.responseRead,
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

  static Future<List<dynamic>> getMetros(List districts) async {

    String url = API_IP + 'metros?lang=' + Prefs.getString(Prefs.LANGUAGE);

    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(url, headers: headers, body: json.encode({
        'districts': districts,
      }));

      print('metros - ' + utf8.decode(response.bodyBytes));

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

  static Future<dynamic> getRegionByName(String region) async {

    String url = '';

    url = API_IP + 'region_by_name' + '?region=$region' + '&lang=' + Prefs.getString(Prefs.LANGUAGE);

    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);

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
        company: json['company'],
        company_name: json['company_name'],
        company_logo: json['company_logo'],
        busyness: json['busyness'],
        schedule: json['schedule'],
        job_type: json['job_type'],
        region: json['region'],
        district: json['district'],
        street: json['street'],
        houseNumber: json['house_number'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        type: json['type'],
        currency: json['currency'],
        period: json['period'],
        experience: json['experience'],
        payPeriod: json['pay_period'],
        status: json['status'],
        statusText: json['status_text'],
        responseType: json['response_type'],
        responseRead: json['response_read'] == 0 ? false : true
      );

  static Map<String, dynamic> vacancyToJsonMap(Vacancy vacancy) => {
        'id': vacancy.id,
        'company_id': Prefs.getInt(Prefs.USER_ID).toString(),
        'name': vacancy.name,
        'salary': vacancy.salary,
        'salary_from': vacancy.salary_from,
        'salary_to': vacancy.salary_to,
        'description': vacancy.description,
        'address': vacancy.address,
        'region': vacancy.region,
        'district': vacancy.district,
        'street': vacancy.street,
        'house_number': vacancy.houseNumber,
        'latitude': vacancy.latitude,
        'longitude': vacancy.longitude,
        'busyness': vacancy.busyness,
        'schedule': vacancy.schedule,
        'job_type': vacancy.job_type,
        'currency': vacancy.currency,
        'period': vacancy.period,
        'experience': vacancy.experience,
        'pay_period': vacancy.payPeriod,
        'type': vacancy.type,
        'status': vacancy.status,
        'status_text': vacancy.statusText,
        'response_type': vacancy.responseType,
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
            'offset': offset-1,
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
      print(response.body);
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

  static Future<String> saveVacancyUserInvite({
    int vacancy_id,
    int user_id,
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
          body: json.encode({'vacancy_id': vacancy_id, 'type': type, 'user_id': user_id})
      );

      print(response.body);
      print(response.statusCode);

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

  Future<void> userCompanyRead(int userId, int userVacancyId) async {
    var uri = Uri.parse(API_IP + API_USER_COMPANY_READ);

    try {
      Map<String, String> headers = {"Content-type": "application/json", "token": Prefs.getString(Prefs.TOKEN)};
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'vacancy_id': userVacancyId,
          'read': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 400) {
        throw HttpException(responseData['status'].toString());
      }
    } catch (error) {
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
  List metros;
  List schedule_ids;
  List busyness_ids;
  List vacancy_type_ids;
  List opportunity_ids;
  List opportunity_type_ids;
  List opportunity_duration_ids;
  List internship_language_ids;
  ListVacancysState list;
  ListVacancysState listMap;
  ListVacancysState active_list;
  ListVacancysState active_list_user;
  ListVacancysState inactive_list;
  LikedVacancyListState liked_list;
  ListVacancysState all_list;
  ListVacancysState submitted_list;
  ListVacancysState invited_list;
  UserState user;

  factory VacancyState.initial() => VacancyState(
      list: ListVacancysState.initial(),
      listMap: ListVacancysState.initial(),
      active_list: ListVacancysState.initial(),
      active_list_user: ListVacancysState.initial(),
      inactive_list: ListVacancysState.initial(),
      liked_list: LikedVacancyListState.initial(),
      all_list: ListVacancysState.initial(),
      submitted_list: ListVacancysState.initial(),
      invited_list: ListVacancysState.initial(),
      job_type_ids: [],
      region_ids: [],
      metros: [],
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
      this.metros,
      this.schedule_ids,
      this.busyness_ids,
      this.vacancy_type_ids,
      this.opportunity_ids,
      this.opportunity_type_ids,
      this.opportunity_duration_ids,
      this.internship_language_ids,
      this.list,
      this.listMap,
      this.liked_list,
      this.type,
      this.all_list,
      this.submitted_list,
      this.invited_list,
      this.user,
      this.number_of_submiteds,
      this.number_of_likeds,
      this.active_list,
      this.active_list_user,
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

class ListAllVacancyState {
  dynamic error;
  bool loading;
  List<Vacancy> data;

  ListAllVacancyState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListAllVacancyState.initial() => ListAllVacancyState(
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

class ListInvitedVacancyState {
  dynamic error;
  bool loading;
  List<Vacancy> data;

  ListInvitedVacancyState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListInvitedVacancyState.initial() => ListInvitedVacancyState(
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
