import 'dart:convert';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/pref_manager.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class Users {
  int id;
  String token;
  String password;
  String name;
  String surname;
  String image;
  String email;
  String linkedin;
  DateTime birth_date;
  String phone_number;
  String user_cv_name;
  String vacancy_name;
  String experience_year;
  bool is_company;
  int is_migrant;
  String gender;
  String region;
  String district;
  String vacancy_type;
  String business;
  String job_type;
  String job_sphere;
  String opportunity;
  String department;
  String social_orientation;
  String contact_person_fullname;
  String contact_person_position;
  bool is_product_lab_user;
  String address;
  int recruited;
  int userVacancyId;
  String lat;
  String long;
  int status;
  String statusText;
  String salary;
  String currency;
  String period;
  String description;
  String age;
  String response_type;
  bool response_read;
  List vacancy_types;
  List schedules;

  Users({
    this.id,
    this.token,
    this.password,
    this.name,
    this.surname,
    this.image,
    this.email,
    this.linkedin,
    this.birth_date,
    this.phone_number,
    this.user_cv_name,
    this.experience_year,
    this.vacancy_name,
    this.is_company,
    this.is_migrant,
    this.gender,
    this.region,
    this.district,
    this.vacancy_type,
    this.business,
    this.job_type,
    this.contact_person_fullname,
    this.contact_person_position,
    this.department,
    this.job_sphere,
    this.address,
    this.recruited,
    this.userVacancyId,
    this.lat,
    this.long,
    this.status,
    this.statusText,
    this.salary,
    this.currency,
    this.period,
    this.description,
    this.age,
    this.response_type,
    this.response_read,
    this.vacancy_types,
    this.schedules,
  });

  factory Users.fromJson(Map<String, dynamic> json) => new Users(
      id: json["id"],
      name: json["name"],
      surname: json["lastname"],
      image: json['avatar'],
      email: json['email'],
      linkedin: json['linkedin'],
      birth_date: DateTime.parse(json['birth_date']),
      phone_number: json['phone_number'],
      vacancy_name: json['vacancy_name'],
      user_cv_name: json['job_title'],
      experience_year: json['experience_year'].toString(),
      is_company: json['type'] == 'COMPANY',
      is_migrant: json['is_migrant'],
      gender: json['gender'],
      region: json['region'].toString(),
      district: json['district'].toString(),
      vacancy_type: json['vacancy_type'].toString(),
      business: json['business'].toString(),
      job_type: json['job_type'].toString(),
      job_sphere: json['job_sphere'].toString(),
      department: json['department'].toString(),
      contact_person_fullname: json['contact_person_fullname'],
      contact_person_position: json['contact_person_position'],
      address: json['address'],
      recruited: json['recruited'],
      userVacancyId: json['user_vacancy_id'],
      lat: json['lat'],
      long: json['long'],
      status: json['status'],
      statusText: json['status_text'],
      salary: json['salary'],
      currency: json['currency'],
      period: json['period'],
      description: json['description'],
      age: json['age'],
      response_type: json['response_type'],
      response_read: json['response_read'] == 0 ? false : true,
      vacancy_types: json['vacancy_types'] != null ? json['vacancy_types'] : [],
      schedules: json['schedules'] !=  null ? json['schedules'] : [],
  );

  Future<void> setRecruit(int userId, int userVacancyId, int recruited) async {
    var uri = Uri.parse(API_IP + API_SET_RECRUIT);

    try {
      Map<String, String> headers = {"Content-type": "application/json", "token": Prefs.getString(Prefs.TOKEN)};
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'user_vacancy_id': userVacancyId,
          'recruited': recruited,
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

  Future<int> getRecruit(int vacancyId) async {
    var uri = Uri.parse(API_IP + API_GET_RECRUIT + '/' + vacancyId.toString());
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": Prefs.getString(Prefs.TOKEN)};
      final response = await http.get(
        uri,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 400) {
        throw HttpException(responseData['status'].toString());
      } else {
        return responseData['recruited'];
      }
    } catch (error) {
      throw error;
    }
  }

  String uploadImage1(_image) {
    // string to uri
    var uri = Uri.parse(API_IP + API_REGISTER1);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["id"] = this.id.toString();
    request.fields["password"] = this.password;
    request.fields["name"] = this.name;
    request.fields["lastname"] = this.surname;
    request.fields["email"] = this.email;
    request.fields["birth_date"] = formatter.format(this.birth_date);
    request.fields["active"] = '1';
    request.fields["phone_number"] = this.phone_number;
    request.fields["type"] = this.is_company ? 'COMPANY' : 'USER';
    request.fields["is_migrant"] = this.is_migrant.toString();
    request.fields["gender"] = this.gender.toString();
    request.fields["region"] = this.region.toString();
    request.fields["district"] = this.district.toString();
    request.fields["job_type"] = this.job_type.toString();
    request.fields["is_product_lab_user"] = this.is_product_lab_user.toString();

    // open a byteStream
    if (_image != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // get file length
      var length = _image.length();
      // multipart that takes file.. here this "image_file" is a key of the API request
      var multipartFile = new http.MultipartFile('avatar', stream, length, filename: basename(_image.path));
      // add file to multipart
      request.files.add(multipartFile);
    }

    // send request to upload image
    var mm;
    request.send().then((response) {
      // listen for response
      print(response);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
        if (response['status'] == 200) {
          Prefs.setString(Prefs.PASSWORD, password);
          Prefs.setString(Prefs.TOKEN, response["token"]);
          Prefs.setInt(Prefs.USER_ID, response["id"]);
          Prefs.setString(Prefs.PROFILEIMAGE, response["avatar"]);
          Prefs.setString(Prefs.USER_TYPE, response["user_type"]);
          mm = "OK";
        } else {
          mm = "ERROR";
        }
      });
    }).catchError((e) {
      print(e);
    });
    return mm;
  }

  /// Method to upload Profile Image and Update User data
  Future<String> uploadImage2(_image) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_REGISTER + '/${this.id.toString()}');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["id"] = this.id.toString();
    request.fields["name"] = this.name;
    request.fields["lastname"] = this.surname;
    request.fields["email"] = this.email;
    request.fields["birth_date"] = formatter.format(this.birth_date);
    request.fields["phone_number"] = this.phone_number;
    request.fields["linkedin"] = this.linkedin;
    request.fields["is_migrant"] = this.is_migrant.toString();
    request.fields["gender"] = this.gender.toString();
    request.fields["region"] = this.region.toString();
    request.fields["district"] = this.district.toString();
    request.fields["job_type"] = this.job_type.toString();
    request.fields["is_product_lab_user"] = this.is_product_lab_user.toString();
    request.fields["contact_person_fullname"] = this.contact_person_fullname.toString();
    request.fields["contact_person_position"] = this.contact_person_position.toString();
    request.fields["job_sphere"] = this.job_sphere.toString();
    request.fields["department"] = this.department.toString();
    request.fields["social_orientation"] = this.social_orientation.toString();
    request.fields["address"] = this.address.toString();
    request.fields["description"] = this.description.toString();

    // open a byteStream
    if (_image != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // get file length
      var length = await _image.length();
      // multipart that takes file.. here this "image_file" is a key of the API request
      var multipartFile = new http.MultipartFile('avatar', stream, length, filename: basename(_image.path));
      // add file to multipart
      request.files.add(multipartFile);
    }

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        var data = json.decode(value);
        Prefs.setString(Prefs.PROFILEIMAGE, data["avatar"]);
      });
    }).catchError((e) {
      print(e);
    });

    return "OK";
  }

  Future<void> register() async {
    final url = API_IP + API_REGISTER;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(userRequestBodyToJson(this)),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 999) {
        throw HttpException(responseData['status'].toString());
      } else if (responseData['status'] == 888) {
        throw HttpException(responseData['status'].toString());
      } else if (responseData['token'] != null) {
        this.token = responseData['token'];
        this.id = responseData['id'];
      }
    } catch (error) {
      throw error;
    }
  }

  static Map<String, dynamic> userRequestBodyToJson(Users user) => {
        'password': user.password,
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'birth_date': user.birth_date,
        'phone_number': user.phone_number,
        'is_migrant': user.is_migrant,
        'gender': user.gender,
        'region': user.region,
        'district': user.district,
        'job_type': user.job_type,
        "is_product_lab_user": user.is_product_lab_user,
        "contact_person_fullname": user.contact_person_fullname,
        "contact_person_position": user.contact_person_position,
        "opportunity": user.opportunity,
        "job_sphere": user.job_sphere,
        "department": user.department,
        "social_orientation": user.social_orientation,
        "address": user.address,
        "lat": user.lat,
        "long": user.long,
      };

  bool get isAuth {
    return token != null;
  }

  Future<String> _authenticate(String email, String password) async {
    final url = API_IP + API_LOGIN;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(loginRequestBodyToJson(email, password)),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 999) {
        return "ERROR";
      } else if (responseData['status'] == 888) {
        return "ERROR";
      } else if (responseData['token'] != null) {
        this.password = password;
        Prefs.setString('password', password);
        Prefs.setString(Prefs.EMAIL, email);
        Prefs.setString(Prefs.PASSWORD, password);
        Prefs.setInt(Prefs.USER_ID, responseData["id"]);
        Prefs.setString(Prefs.TOKEN, responseData["token"]);
        Prefs.setString(Prefs.PROFILEIMAGE, responseData["avatar"]);
        Prefs.setString(Prefs.USER_TYPE, responseData["user_type"]);
        Prefs.setString(Prefs.USER_LAT, responseData["lat"]);
        Prefs.setString(Prefs.USER_LONG, responseData["long"]);
        Prefs.setInt(Prefs.USER_STATUS, responseData["active"]);
        // Prefs.setList(Prefs.SCHEDULES, responseData["schedules"].toList());
        // Prefs.setList(Prefs.VACANCY_TYPES, responseData["vacancy_types"].toList());
        return "OK";
      } else {
        return "FAILED";
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> _authenticatePhone(String phone, String password) async {
    final url = API_IP + API_LOGIN_PHONE;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(loginRequestBodyToJsonPhone(phone, password)),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 999) {
        return "ERROR";
      } else if (responseData['status'] == 888) {
        return "ERROR";
      } else if (responseData['token'] != null) {
        this.password = password;
        Prefs.setString('password', password);
        Prefs.setString(Prefs.EMAIL, responseData["email"]);
        Prefs.setString(Prefs.PASSWORD, password);
        Prefs.setInt(Prefs.USER_ID, responseData["id"]);
        Prefs.setString(Prefs.TOKEN, responseData["token"]);
        Prefs.setString(Prefs.PROFILEIMAGE, responseData["avatar"]);
        Prefs.setString(Prefs.USER_TYPE, responseData["user_type"]);
        Prefs.setString(Prefs.USER_LAT, responseData["lat"]);
        Prefs.setString(Prefs.USER_LONG, responseData["long"]);
        Prefs.setInt(Prefs.USER_STATUS, responseData["active"]);
        // Prefs.setList(Prefs.SCHEDULES, responseData["schedules"].toList());
        // Prefs.setList(Prefs.VACANCY_TYPES, responseData["vacancy_types"].toList());
        return "OK";
      } else {
        return "FAILED";
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> _authenticatePhoneOTP(String phone) async {
    final url = API_IP + API_LOGIN_PHONE;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(loginPhoneOTPRequestBodyToJsonPhone(phone)),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 999) {
        return "ERROR";
      } else if (responseData['status'] == 888) {
        return "ERROR";
      } else if (responseData['token'] != null) {
        this.password = password;
        Prefs.setString('password', password);
        Prefs.setString(Prefs.EMAIL, responseData["email"]);
        Prefs.setString(Prefs.PHONE_NUMBER, responseData["phone_number"]);
        Prefs.setString(Prefs.PASSWORD, password);
        Prefs.setInt(Prefs.USER_ID, responseData["id"]);
        Prefs.setString(Prefs.TOKEN, responseData["token"]);
        Prefs.setString(Prefs.PROFILEIMAGE, responseData["avatar"]);
        Prefs.setString(Prefs.USER_TYPE, responseData["user_type"]);
        Prefs.setString(Prefs.USER_LAT, responseData["lat"]);
        Prefs.setString(Prefs.USER_LONG, responseData["long"]);
        Prefs.setInt(Prefs.USER_STATUS, responseData["active"]);
        // Prefs.setList(Prefs.SCHEDULES, List<String>.from(responseData["schedules"]));
        // Prefs.setList(Prefs.VACANCY_TYPES, List<String>.from(responseData["vacancy_types"]));
        return "OK";
      } else {
        return "FAILED";
      }
    } catch (error) {
      throw error;
    }
  }

  static Map<String, dynamic> loginRequestBodyToJson(String email, String password) => {
    'email': email,
    'password': password,
  };

  static Map<String, dynamic> loginRequestBodyToJsonPhone(String phone, String password) => {
    'phone_number': phone,
    'password': password,
  };

  static Map<String, dynamic> loginPhoneOTPRequestBodyToJsonPhone(String phone) => {
    'phone_number': phone
  };

  static Future<bool> checkUsername(String email) async {
    final url = API_IP + API_CHECK_USER_EMAIL;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'email': email,
        }),
      );
      return json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  static Future<bool> checkPhone(String phone) async {
    final url = API_IP + 'phoneexist';
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'phone_number': phone,
        }),
      );
      print(response.body);
      if(json.decode(response.body) > 0){
        return true;
      }
      return false;
    } catch (error) {
      throw error;
    }
  }

  static Future<bool> checkUserCv(int userId) async {
    final url = API_IP + API_CHECK_USER_CV;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'user_id': userId.toString(),
        }),
      );
      return json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  static Future<String> sendMailOnForgotPassword(String email) async {
    final url = API_IP + API_FORGOT_PASSWORD;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'email': email,
          'language': Prefs.getString(Prefs.LANGUAGE),
        }),
      );
      print(response.body);
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  static Future<String> validateUserCode({String email, String code}) async {
    final url = API_IP + API_VALIDATE_CODE;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );
      var body = json.decode(response.body);
      if (body == 'user code does not exist') return "ERROR";
      Prefs.setString(Prefs.EMAIL, email);
      Prefs.setString(Prefs.USER_ID, body["id"].toString());
      Prefs.setString(Prefs.PROFILEIMAGE, body["avatar"]);

      return "OK";
    } catch (error) {
      throw error;
    }
  }

  static Future<String> resetPassword({String email, String new_password}) async {
    final url = API_IP + API_RESET_PASSWORD;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'email': email,
          'new_password': new_password,
        }),
      );
      var body = json.decode(response.body);
      Prefs.setString(Prefs.TOKEN, body['token']);

      return "OK";
    } catch (error) {
      throw error;
    }
  }

  Future<void> resetSettings({String email}) async {
    final url = API_IP + API_RESET_SETTINGS;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'email': email}),
      );
      var body = json.decode(response.body);
      // Prefs.setString(Prefs.TOKEN, body['token']);

      return "OK";
    } catch (error) {
      throw error;
    }
  }

  static Future<void> resetDislikedVacancies() async {
    final url = API_IP + API_RESET_DISLIKED_VACANCIES;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        url,
        headers: headers,
      );
      var body = json.decode(response.body);
      // Prefs.setString(Prefs.TOKEN, body['token']);

      return "OK";
    } catch (error) {
      throw error;
    }
  }

  static Future<String> getCompanyLogo({int vacancy_id}) async {
    final url = API_IP + API_GET_COMPANY_AVATAR;
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'vacancy_id': vacancy_id,
        }),
      );

      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<String> login(String email, String password) async {
    return _authenticate(email.trim(), password.trim());
  }

  Future<String> loginPhone(String phone, String password) async {
    return _authenticatePhone(phone.trim(), password.trim());
  }

  Future<String> loginPhoneOTP(String phone) async {
    return _authenticatePhoneOTP(phone.trim());
  }

  Future<void> setPassword(String password) async {
    final url = API_IP + 'api/change-password/' + Prefs.getInt(Prefs.USER_ID).toString();
    try {
      Map<String, String> headers = {"Content-type": "application/json", "token": Prefs.getString(Prefs.TOKEN)};
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode({"new_password": password}),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == 999) {
        throw HttpException(responseData['status'].toString());
      } else if (responseData['status'] == 888) {
        throw HttpException(responseData['status'].toString());
      } else if (responseData['token'] != null) {
        Prefs.setString(Prefs.PASSWORD, password);
        Prefs.setInt(Prefs.USER_ID, responseData['id']);
        Prefs.setString(Prefs.TOKEN, responseData['token']);
        this.password = password;
      }
    } catch (error) {
      throw error;
    }
  }

  void logout() async {
    var userId = 0;
    userId = Prefs.getInt(Prefs.USER_ID);
    final url = API_IP + 'api/logged';
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({"id": userId}),
      );
      final responseData = json.decode(response.body);
      if (responseData == "successfully") {}
    } catch (error) {
      throw error;
    }
  }

  static Future<List<dynamic>> deleteUser() async {
    var userId = Prefs.getInt(Prefs.USER_ID);
    final url = API_IP + 'deleteAccount/$userId';
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(
        url,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      if (responseData['message'] == "OK") {}
    } catch (error) {
      throw error;
    }
  }

  /// Filters
  void saveFilters(List regions, List districts, List activities, List types, List busyness, List schedules) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_SAVE_FILTER + '/${this.id.toString()}');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    request.fields["id"] = this.id.toString();
    request.fields["regions"] = regions.toString();
    request.fields["districts"] = districts.toString();
    request.fields["activities"] = activities.toString();
    request.fields["types"] = types.toString();
    request.fields["busyness"] = busyness.toString();
    request.fields["schedules"] = schedules.toString();

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        var data = json.decode(value);
        print(data);
      });
    }).catchError((e) {
      print(e);
    });
  }

  static Future<List<dynamic>> getFilters(model, id) async {
    final url = API_IP + API_GET_FILTERS + '/${id.toString()}/${model.toString()}';
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);
      print(model + ' - ' + utf8.decode(response.bodyBytes));
      return json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  static Future<String> saveUserCompany({
    int userId,
    int vacancyId,
    String type,
  }) async {
    final url = API_IP + API_USER_COMPANY_SAVE;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'user_id': userId, 'type': type, 'vacancy_id': vacancyId})
      );
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

  static Future<String> deleteUserCompany({
    int userId,
    String type,
  }) async {
    final url = API_IP + API_USER_COMPANY_DELETE;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(url,
          headers: headers,
          body: json.encode({'user_id': userId, 'type': type})
      );
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

  static changeStatus({int status}) async {
    var uri = Uri.parse(API_IP + API_CHANGE_STATUS);

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'status': status
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['status'] == 400) {
        throw HttpException(responseData['status'].toString());
      }
    } catch (error) {
      throw error;
    }
  }

  static changeSchedule({List schedules}) async {
    var uri = Uri.parse(API_IP + API_CHANGE_SCHEDULES);

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'schedules': schedules
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['status'] == 400) {
        throw HttpException(responseData['status'].toString());
      }
    } catch (error) {
      throw error;
    }
  }

  static changeVacancyTypes({List vacancyTypes}) async {
    var uri = Uri.parse(API_IP + API_CHANGE_VACANCY_TYPES);

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'vacancy_types': vacancyTypes
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['status'] == 400) {
        throw HttpException(responseData['status'].toString());
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<List<dynamic>> getSchedules(id) async {
    final url = API_IP + API_GET_SCHEDULES + '/${id.toString()}';
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);
      return json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  static Future<List<dynamic>> getVacancyTypes(id) async {
    final url = API_IP + API_GET_VACANCY_TYPES + '/${id.toString()}';
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.get(url, headers: headers);
      return json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> userCompanyRead(int userId, int userVacancyId) async {
    var uri = Uri.parse(API_IP + API_USER_VACANCY_READ);

    try {
      Map<String, String> headers = {"Content-type": "application/json", "token": Prefs.getString(Prefs.TOKEN)};
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'user_vacancy_id': userVacancyId,
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

class UserState {
  UserDetailState user;
  ListUserDetailState submitted_user_list;
  LikedUserState liked_user_list;
  ListUsersState list;
  UserCvState user_cv;
  UserFullInfoState user_full_info;
  String type;

  ListUsersState submitted_users;
  ListUsersState invited_users;
  ListUsersState all_users;

  List region_ids;
  List district_ids;
  List schedule_ids;
  List busyness_ids;
  List vacancy_type_ids;
  List gender_ids;
  List country_ids;

  int numberOfUnreadResponses;

  UserState({
    this.user,
    this.user_cv,
    this.submitted_user_list,
    this.liked_user_list,
    this.user_full_info,
    this.list,
    this.submitted_users,
    this.invited_users,
    this.all_users,
    this.type,
    this.region_ids,
    this.schedule_ids,
    this.busyness_ids,
    this.vacancy_type_ids,
    this.gender_ids,
    this.country_ids,
    this.numberOfUnreadResponses,
  });

  factory UserState.initial() => UserState(
    user: UserDetailState.initial(),
    user_cv: UserCvState.initial(),
    list: ListUsersState.initial(),
    submitted_user_list: ListUserDetailState.initial(),
    liked_user_list: LikedUserState.initial(),
    user_full_info: UserFullInfoState.initial(),
    submitted_users: ListUsersState.initial(),
    invited_users: ListUsersState.initial(),
    all_users: ListUsersState.initial(),
    type: 'all',
    region_ids: [],
    schedule_ids: [],
    busyness_ids: [],
    vacancy_type_ids: [],
    gender_ids: [],
    country_ids: [],
    numberOfUnreadResponses: 0,
  );
}

class ListUsersState {
  dynamic error;
  bool loading;
  List<Users> data;

  ListUsersState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListUsersState.initial() => ListUsersState(
    error: null,
    loading: false,
    data: [],
  );
}

class UserDetailState {
  dynamic error;
  bool loading;
  Users data;

  UserDetailState({
    this.error,
    this.loading,
    this.data,
  });

  factory UserDetailState.initial() => UserDetailState(
        error: null,
        loading: false,
        data: new Users(),
      );
}

class ListUserDetailState {
  dynamic error;
  bool loading;
  List<Users> data;

  ListUserDetailState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListUserDetailState.initial() => ListUserDetailState(
        error: null,
        loading: false,
        data: [],
      );
}

class LikedUserState {
  dynamic error;
  bool loading;
  List<Users> data;

  LikedUserState({
    this.error,
    this.loading,
    this.data,
  });

  factory LikedUserState.initial() => LikedUserState(
        error: null,
        loading: false,
        data: [],
      );
}

class UserCvState {
  dynamic error;
  bool loading;
  UserCv data;

  UserCvState({
    this.error,
    this.loading,
    this.data,
  });

  factory UserCvState.initial() => UserCvState(
        error: null,
        loading: false,
        data: new UserCv(),
      );
}

class UserFullInfoState {
  dynamic error;
  bool loading;
  UserFullInfo data;

  UserFullInfoState({
    this.error,
    this.loading,
    this.data,
  });

  factory UserFullInfoState.initial() => UserFullInfoState(
        error: null,
        loading: false,
        data: new UserFullInfo(),
      );
}

class EducationType {
  int id;
  String name;
}

class UserCv {
  int id;
  int experience_year;
  String job_title;
  String attachment;
  List<UserExperience> user_experiences;
  List<UserEducation> user_educations;
  List<UserCourse> user_courses;

  UserCv({this.id, this.experience_year, this.job_title, this.attachment, this.user_experiences, this.user_educations, this.user_courses});

  factory UserCv.fromJson(Map<String, dynamic> json) => new UserCv(
        id: json["id"],
        job_title: json["job_title"],
        attachment: json["attachment"],
        experience_year: json["experience_year"],
        user_courses: coursesToList(json['courses']),
        user_educations: educationsToList(json['educations']),
        user_experiences: experiencesToList(json['experiences']),
      );

  Future<String> save({attachment}) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_SAVE);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["user_id"] = Prefs.getInt(Prefs.USER_ID).toString();
    request.fields["user_cv_id"] = this.id.toString();
    request.fields["experience_year"] = this.experience_year != null ? this.experience_year.toString() : " ";
    request.fields["job_title"] = this.job_title ?? " ";
    request.fields["is_product_lab_user"] = Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB" ? "0" : "1";

//    request.fields["user_experiences"] = json.encode(this.user_experiences);
//    request.fields["user_educations"] = json.encode(this.user_educations);
//    request.fields["user_courses"] = json.encode(this.user_courses);

    // open a byteStream
    if (attachment != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(attachment.openRead()));
      // get file length
      var length = await attachment.length();
      // multipart that takes file.. here this "image_file" is a key of the API request
      var multipartFile = new http.MultipartFile('attachment', stream, length, filename: basename(attachment.path));
      // add file to multipart
      request.files.add(multipartFile);
    }

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        return value;
//        Prefs.setString('username', username);
//        Prefs.setString('password', password);
//        Prefs.setString(Prefs.USERNAME, username);
//        Prefs.setString(Prefs.PASSWORD, password);
//        Prefs.setString(Prefs.TOKEN, response["token"]);
//        Prefs.setString(Prefs.PROFILEIMAGE, response["avatar"]);
      });
    }).catchError((e) {
      print(e);
      return e;
    });

    return 'OK';
  }

  static List<UserExperience> experiencesToList(var j) {
    List<UserExperience> result = new List<UserExperience>();
    for (var i in j) {
      result.add(new UserExperience(
        id: i['id'],
        job_title: i['job_title'],
        start_date: i['start_date'],
        end_date: i['end_date'],
        organization_name: i['organization_name'],
        description: i['description'],
      ));
    }
    return result;
  }

  static List<UserEducation> educationsToList(var j) {
    List<UserEducation> result = new List<UserEducation>();
    for (var i in j) {
      result.add(new UserEducation(
        id: i['id'],
        type: i['type'],
        title: i['title'],
        faculty: i['faculty'],
        speciality: i['speciality'],
        end_year: i['end_year'].toString(),
      ));
    }
    return result;
  }

  static List<UserCourse> coursesToList(var j) {
    if (j == null) return null;
    List<UserCourse> result = [];
    print(j);
    for (var i in j) {
      result.add(new UserCourse(
        id: i['id'],
        name: i['name'],
        organization_name: i['organization_name'],
        duration: i['duration'],
        end_year: i['end_year'].toString(),
      ));
    }
    return result;
  }
}

class UserFullInfo {
  int id;
  int experience_year;
  String job_title;
  String surname_name;
  String name;
  String avatar;
  String email;
  String attachment;
  DateTime birth_date;
  String phone_number;
  String linkedin;
  int is_migrant;
  List<UserExperience> user_experiences;
  List<UserEducation> user_educations;
  List<UserCourse> user_courses;
  String opportunity;
  String jobSphere;
  List<dynamic> skills;
  List<dynamic> skills2;

  UserFullInfo(
      {this.id,
      this.experience_year,
      this.job_title,
      this.name,
      this.surname_name,
      this.avatar,
      this.email,
      this.birth_date,
      this.phone_number,
      this.linkedin,
      this.is_migrant,
      this.attachment,
      this.user_experiences,
      this.user_educations,
      this.user_courses,
      this.opportunity,
      this.jobSphere,
      this.skills,
      this.skills2});

  factory UserFullInfo.fromJson(Map<String, dynamic> json) => new UserFullInfo(
        id: json["id"],
        job_title: json["job_title"],
        name: json["name"],
        surname_name: json["surname_name"],
        avatar: json["avatar"],
        email: json["email"],
        birth_date: DateTime.parse(json['birth_date']),
        phone_number: json["phone_number"],
        linkedin: json["linkedin"],
        is_migrant: json["is_migrant"],
        attachment: json["attachment"],
        experience_year: json["experience_year"],
        user_courses: coursesToList(json['courses']),
        user_educations: educationsToList(json['educations']),
        user_experiences: experiencesToList(json['experiences']),
        opportunity: json["opportunity"],
        jobSphere: json["job_sphere"],
        skills: skillsToList(json["skills"]),
        skills2: skillsToList(json["skills2"]),
      );

  static List<dynamic> skillsToList(var j) {
    List<dynamic> result = [];
    for (var i in j) {
      result.add(i);
    }
    return result;
  }

  static List<UserExperience> experiencesToList(var j) {
    List<UserExperience> result = new List<UserExperience>();
    for (var i in j) {
      result.add(new UserExperience(
        id: i['id'],
        job_title: i['job_title'],
        start_date: (i['start_date']),
        end_date: (i['end_date']),
        organization_name: i['organization_name'],
        description: i['description'],
      ));
    }
    return result;
  }

  static List<UserEducation> educationsToList(var j) {
    List<UserEducation> result = new List<UserEducation>();
    for (var i in j) {
      result.add(new UserEducation(
        id: i['id'],
        type: i['type'],
        title: i['title'],
        faculty: i['faculty'],
        speciality: i['speciality'],
        end_year: i['end_year'].toString(),
      ));
    }
    return result;
  }

  static List<UserCourse> coursesToList(var j) {
    if (j == null) return null;
    List<UserCourse> result = [];
    print(j);
    for (var i in j) {
      result.add(new UserCourse(
        id: i['id'],
        name: i['name'],
        organization_name: i['organization_name'],
        duration: i['duration'],
        end_year: i['end_year'].toString(),
      ));
    }
    return result;
  }
}

class UserExperience {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  int id;
  String job_title;
  String start_date;
  String end_date;
  String organization_name;
  String description;

  UserExperience({this.id, this.job_title, this.start_date, this.end_date, this.organization_name, this.description});

  Map toJson() => {
        'id': id.toString(),
        'job_title': job_title.toString(),
        'start_date': start_date,
        'end_date': end_date,
        'organization_name': organization_name.toString(),
        'description': description.toString(),
      };

  Future<void> save(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_EXPERIENCE_SAVE);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["user_id"] = Prefs.getInt(Prefs.USER_ID).toString();
    request.fields["user_cv_id"] = id.toString();
    request.fields["job_title"] = this.job_title.toString();
    request.fields["start_date"] = start_date;
    request.fields["end_date"] = end_date;
    request.fields["organization_name"] = this.organization_name.toString();
    request.fields["description"] = this.description.toString();

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = value;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> update(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_EXPERIENCE_UPDATE + id.toString());

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["id"] = id.toString();
    request.fields["job_title"] = this.job_title.toString();
    request.fields["start_date"] = start_date;
    request.fields["end_date"] = end_date;
    request.fields["organization_name"] = this.organization_name.toString();
    request.fields["description"] = this.description.toString();

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> delete(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_EXPERIENCE_DELETE + id.toString());

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
      });
    }).catchError((e) {
      print(e);
    });
  }
}

class UserEducation {
  int id;
  String type;
  String title;
  String faculty;
  String speciality;
  String end_year;

  UserEducation({this.id, this.type, this.title, this.faculty, this.speciality, this.end_year});

  Map toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'faculty': faculty,
        'speciality': speciality,
        'end_year': end_year,
      };

  Future<String> save(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_EDUCATION_SAVE);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["user_id"] = Prefs.getInt(Prefs.USER_ID).toString();
    request.fields["user_cv_id"] = id.toString();
    request.fields["title"] = this.title.toString();
    request.fields["faculty"] = this.faculty.toString();
    request.fields["speciality"] = this.speciality.toString();
    request.fields["type"] = this.type.toString();
    request.fields["end_year"] = this.end_year.toString();

    // send request to upload image
    return await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        if (value == "OK") return value;
      });
    }).catchError((e) {
      return "ERROR";
      print(e);
    });
  }

  Future<void> update(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_EDUCATION_UPDATE + id.toString());

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["id"] = id.toString();
    request.fields["title"] = this.title.toString();
    request.fields["faculty"] = this.faculty.toString();
    request.fields["speciality"] = this.speciality.toString();
    request.fields["type"] = this.type.toString();
    request.fields["end_year"] = this.end_year.toString();

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<String> delete(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_EDUCATION_DELETE + id.toString());

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    // send request to upload image
    return await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        return value;
      });
    }).catchError((e) {
      print(e);
    });
  }
}

class UserCourse {
  int id;
  String name;
  String organization_name;
  String duration;
  String end_year;

  UserCourse({this.id, this.name, this.organization_name, this.duration, this.end_year});

  Map toJson() => {
        'id': id,
        'name': name,
        'organization_name': organization_name,
        'duration': duration,
        'end_year': end_year,
      };

  Future<void> save(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_COURSE_SAVE);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["user_id"] = Prefs.getInt(Prefs.USER_ID).toString();
    request.fields["user_cv_id"] = id.toString();
    request.fields["name"] = this.name.toString();
    request.fields["organization_name"] = this.organization_name.toString();
    request.fields["duration"] = this.duration.toString();
    request.fields["end_year"] = this.end_year.toString();

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> update(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_COURSE_UPDATE + id.toString());

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    request.fields["id"] = id.toString();
    request.fields["name"] = this.name.toString();
    request.fields["organization_name"] = this.organization_name.toString();
    request.fields["duration"] = this.duration.toString();
    request.fields["end_year"] = this.end_year.toString();

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> delete(id) async {
    // string to uri
    var uri = Uri.parse(API_IP + API_USER_CV_COURSE_DELETE + id.toString());

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = Prefs.getString(Prefs.TOKEN);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        var response = json.decode(value);
      });
    }).catchError((e) {
      print(e);
    });
  }
}
