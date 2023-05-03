import 'dart:io';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:dropdown_search/dropdown_search.dart';

enum is_company { Company, User }
enum user_gender { Male, Female }

class ProductLabSignUp extends StatefulWidget {
  @override
  _ProductLabSignUpState createState() => _ProductLabSignUpState();
}

class _ProductLabSignUpState extends State<ProductLabSignUp> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  final _username_controller = TextEditingController();
  final _name_controller = TextEditingController();
  final _surnname_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _linkedin_controller = TextEditingController();

  // final _phone_number_controller = TextEditingController(text: '+(996)');
  final _password_controller = TextEditingController();
  final _password_confirm_controller = TextEditingController();
  final _birth_date_controller = TextEditingController();
  bool _obscureText = true;

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String _retrieveDataError;
  String _birth_date;
  bool isValid = false;
  bool isUserExists = false;

  final TextEditingController _phone_number_controller = TextEditingController();
  String initialCountry = 'KG';
  PhoneNumber number = PhoneNumber(isoCode: 'KG');

  is_company company = is_company.User;
  bool is_sending = false;
  bool is_migrant = false;

  user_gender gender = user_gender.Male;

  void _showDataPicker(context) {
    var date = DateTime.now();
    DatePicker.showDatePicker(context,
        maxTime: new DateTime(date.year - 14, date.month, date.day),
        locale: Prefs.getString(Prefs.LANGUAGE) == 'ky' ? LocaleType.ky : LocaleType.ru,
        theme: DatePickerTheme(
          headerColor: kColorPrimary,
          cancelStyle: const TextStyle(color: Colors.white, fontSize: 17),
          doneStyle: const TextStyle(color: Colors.white, fontSize: 17),
        ), onConfirm: (date) {
      print(date);
      // Change state
      setState(() {
        _birth_date_controller.text = date.toString().split(" ")[0];
      });
    });
  }

  void _showDialog(context, String message, bool error) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('continue'.tr()),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (!error) Navigator.pushReplacementNamed(context, Routes.product_lab_home);
              },
            )
          ],
        ),
      ),
    );
  }

  void _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Container(
                color: Colors.transparent,
                height: 50,
                width: 50,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
                ))),
          ),
        );
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('from_gallery'.tr()),
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery, context: context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('camera'.tr()),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.camera, context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
        );

        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  List<dynamic> jobTypeList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<String> jobTypes = [];
  List<String> items = [];
  List<String> districts = [];
  String selectedJobType;
  String selectedRegion;
  String selectedDistrict;

  getJobTypes() async {
    jobTypeList = await Vacancy.getLists('job_type', null);
    jobTypeList.forEach((jobType) {
      setState(() {
        jobTypes.add(jobType['name']);
      });
    });
  }

  getRegions() async {
    regionList = await Vacancy.getLists('region', null);
    regionList.forEach((region) {
      setState(() {
        items.add(region['name']);
      });
    });
  }

  getDistricts(region) async {
    districts = [];
    districtList = await Vacancy.getLists('districts', region);
    districtList.forEach((district) {
      setState(() {
        districts.add(district['name']);
      });
    });
  }

  @override
  void initState() {
    getRegions();
    getJobTypes();
    // getDistricts('all');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sign_up_title".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text("create_account".tr(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            SizedBox(height: 20),

            /// Profile photo
            GestureDetector(
              child: _imageFile == null
                  ? CircleAvatar(
                      backgroundColor: kColorProductLab,
                      radius: 50,
                      child: SvgIcon("assets/icons/camera_icon.svg", width: 40, height: 40, color: Colors.white),
                    )
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 50,
                      backgroundImage: Image.file(
                        File(_imageFile.path),
                        fit: BoxFit.cover,
                      ).image,
                    ),
              onTap: () {
                _showPicker(context);
              },
            ),
            SizedBox(height: 10),

            /// Form
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'email'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  TextFormField(
                    controller: _email_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      isValid = EmailValidator.validate(_email_controller.text);
                    },
                    validator: (name) {
                      if (name.isEmpty) {
                        return "please_fill_this_field".tr();
                      } else if (!isValid) {
                        return "please_write_valid_email".tr();
                      } else if (isUserExists) {
                        return "this_email_already_registered".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'password'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: _password_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (name) {
                      // Basic validation
                      if (name.isEmpty) {
                        return "please_fill_this_field".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'password_confirm'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  TextFormField(
                    controller: _password_confirm_controller,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (name) {
                      // Basic validation
                      if (name.isEmpty) {
                        return "please_fill_this_field".tr();
                      } else if (_password_confirm_controller.text != _password_controller.text) {
                        return "passwords_dont_satisfy".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'name'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),

                  TextFormField(
                    controller: _name_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (name) {
                      // Basic validation
                      if (name.isEmpty && company == is_company.User) {
                        return "please_fill_this_field".tr();
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'region'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  DropdownSearch<String>(
                      showSelectedItem: true,
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                          getDistricts(value);
                        });
                      },
                      dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                      selectedItem: selectedRegion),
                  SizedBox(height: 20),

                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'district'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  DropdownSearch<String>(
                    showSelectedItem: true,
                    items: districts,
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                      });
                    },
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                    selectedItem: selectedDistrict,
                  ),
                  SizedBox(height: 20),

                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'phone_number'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: InternationalPhoneNumberInput(
                      countries: ['KG'],
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: true,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phone_number_controller,
                      formatInput: false,
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputDecoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      locale: 'ru',
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'birth_date'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  CustomButton(
                      mainAxisAlignment: MainAxisAlignment.start,
                      width: MediaQuery.of(context).size.width * 1,
                      color: Colors.grey[200],
                      textColor: kColorPrimary,
                      textSize: 16,
                      height: 60.0,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.right,
                      text: _birth_date_controller.text,
                      onPressed: () {
                        _showDataPicker(context);
                      }),
                  SizedBox(height: 20),

                  Row(children: [
                    Text(
                      'gender'.tr(),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ]),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        value: user_gender.Male,
                        groupValue: gender,
                        activeColor: Colors.grey,
                        onChanged: (user_gender value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('male'.tr(), style: TextStyle(color: Colors.black)),
                      Radio(
                        value: user_gender.Female,
                        groupValue: gender,
                        activeColor: Colors.grey,
                        onChanged: (user_gender value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('female'.tr(), style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 40),

                  /// Sign Up button
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomButton(
                      padding: EdgeInsets.all(10),
                      height: 60.0,
                      color: kColorProductLab,
                      textColor: Colors.white,
                      onPressed: () async {
                        Users.checkUsername(_email_controller.text).then((value) {
                          setState(() {
                            isUserExists = value;
                          });
                        });

                        /// Validate form
                        if (_formKey.currentState.validate()) {
//                           Navigator.of(context)
//                               .popUntil((route) => route.isFirst);
                          _openLoadingDialog(context);
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');

                          Users user = new Users();
                          user.password = _password_controller.text;
                          user.email = _email_controller.text;
                          user.phone_number = _phone_number_controller.text;
                          user.birth_date = formatter.parse(_birth_date_controller.text);
                          user.name = _name_controller.text;
                          user.surname = _surnname_controller.text;
                          user.is_company = false;
                          user.is_migrant = is_migrant ? 1 : 0;
                          user.linkedin = _linkedin_controller.text;
                          user.gender = gender == user_gender.Male ? "male" : "female";
                          user.region = selectedRegion;
                          user.district = selectedDistrict;
                          user.job_type = selectedJobType;
                          user.is_product_lab_user = true;

                          var uri = Uri.parse(API_IP + API_REGISTER1 + '?lang=' + Prefs.getString(Prefs.LANGUAGE));

                          // create multipart request
                          var request = new http.MultipartRequest("POST", uri);

                          // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
                          request.fields["id"] = user.id.toString();
                          request.fields["password"] = user.password;
                          request.fields["name"] = user.name;
                          request.fields["email"] = user.email;
                          request.fields["birth_date"] = formatter.format(user.birth_date);
                          request.fields["active"] = '1';
                          request.fields["phone_number"] = user.phone_number;
                          request.fields["type"] = user.is_company ? 'COMPANY' : 'USER';
                          request.fields["gender"] = user.gender.toString();
                          request.fields["region"] = user.region.toString();
                          request.fields["district"] = user.district.toString();
                          request.fields["is_product_lab_user"] = user.is_product_lab_user ? "1" : "0";

                          // open a byteStream
                          if (_imageFile != null) {
                            var _image = File(_imageFile.path);
                            var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
                            // get file length
                            var length = await _image.length();
                            // multipart that takes file.. here this "image_file" is a key of the API request
                            var multipartFile =
                                new http.MultipartFile('avatar', stream, length, filename: basename(_image.path));
                            // add file to multipart
                            request.files.add(multipartFile);
                          }
                          request.send().then((response) {
                            print(response);
                            response.stream.transform(utf8.decoder).listen((value) {
                              print(value);
                              var response = json.decode(value);
                              if (response['status'] == 200) {
                                Prefs.setString(Prefs.PASSWORD, user.password);
                                Prefs.setString(Prefs.TOKEN, response["token"]);
                                Prefs.setString(Prefs.EMAIL, response["email"]);
                                Prefs.setInt(Prefs.USER_ID, response["id"]);
                                Prefs.setString(Prefs.USER_TYPE, user.is_company ? 'COMPANY' : 'USER');
                                Prefs.setString(Prefs.PROFILEIMAGE, response["avatar"]);
                                _showDialog(context, 'successfull_sign_up'.tr(), false);
                              } else {
                                _showDialog(context, 'some_error_occurred_plese_try_again'.tr(), true);
                              }
                            });
                          }).catchError((e) {
                            print(e);
                          });
                        } else {
                          return;
                        }
                      },
                      text: 'create'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
