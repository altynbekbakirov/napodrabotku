import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/app_lat_long.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/screens/otp_sms_screen.dart';
import 'package:ishtapp/services/location_service.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:path/path.dart';

enum is_company { Company, User }
enum user_gender { Male, Female }

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  // final _linkedinController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _typeAheadController = TextEditingController();

  // bool _obscureText = true;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  String initialCountry = 'RU';
  String phoneNumber = '';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');
  is_company company = is_company.User;
  user_gender gender = user_gender.Male;
  bool isSending = false;
  bool isMigrant = false;
  bool isPhoneCorrect = false;
  bool isPhoneExists = false;
  bool isUserExists = false;
  String _selectedCity;
  // int _phoneNumberMaxLength;

  List<dynamic> _suggestions = [];

  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List spheres = [];
  List<String> items = [];
  List<String> districts = [];
  String selectedRegion;
  String selectedDistrict;

  // String _currentAddress;
  bool _obscureText = true;

  // SMSC.RU credentials
  String smscRuLogin = 'pobed-a';
  String smscRuPassword = 'podrab-180523';
  String smscRuMessage = '';

  void _showDataPicker(context) {
    var date = DateTime.now();
    DatePicker.showDatePicker(context,
        maxTime: new DateTime(date.year - 18, date.month, date.day),
        locale: Prefs.getString(Prefs.LANGUAGE) == 'ky' ? LocaleType.ky : LocaleType.ru,
        theme: DatePickerTheme(
          headerColor: kColorPrimary,
          cancelStyle: const TextStyle(color: Colors.white, fontSize: 17),
          doneStyle: const TextStyle(color: Colors.white, fontSize: 17),
        ), onConfirm: (date) {
      // Change state
      setState(() {
        _birthDateController.text = date.toString().split(" ")[0];
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
                if (!error) Navigator.pushReplacementNamed(context, Routes.home);
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
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );

      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print(e);
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
      print(response.exception.code);
    }
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

  setMode() {
    setState(() {
      company = Prefs.getString(Prefs.ROUTE) == "COMPANY" ? is_company.Company : is_company.User;
    });
  }

  @override
  void initState() {
    setMode();
    getRegions();
    _initPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sign_up_title".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "create_account".tr(),
                  style: TextStyle(fontSize: 24, color: kColorDark, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ),

            /// Profile photo
            GestureDetector(
              child: _imageFile == null
                  ? CircleAvatar(
                      backgroundColor: kColorGray,
                      radius: 50,
                      child: SvgIcon("assets/icons/camera_icon.svg", width: 40, height: 40, color: kColorSecondary),
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
            SizedBox(height: 20),

            /// Form
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[

                  /// Название организации
                  company == is_company.Company ?
                  Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Align(
                                widthFactor: 10,
                                heightFactor: 1.5,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'organization_name'.tr().toString().toUpperCase() + '*',
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                )
                            ),
                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: kColorWhite,
                              ),
                              validator: (name) {
                                if (name.isEmpty) {
                                  return "please_fill_this_field".tr();
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      /// Электронный адрес
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Align(
                              widthFactor: 10,
                              heightFactor: 1.5,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'email'.tr().toString().toUpperCase() + '*',
                                style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: kColorWhite,
                              ),
                              onChanged: (value) async {
                                if (value.isEmpty) {
                                  setState(() {
                                    isUserExists = false;
                                  });
                                } else {
                                  await Users.checkUsername(value.trim()).then((value) {
                                    setState(() {
                                      isUserExists = value;
                                    });
                                  });
                                }
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "please_fill_this_field".tr();
                                } else if (!EmailValidator.validate(value.trim())) {
                                  return "please_write_valid_email".tr();
                                } else if (isUserExists) {
                                  return "this_email_already_registered".tr();
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      /// Пароль
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Align(
                                widthFactor: 10,
                                heightFactor: 1.5,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'password'.tr().toString().toUpperCase() + '*',
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                )),
                            TextFormField(
                              obscureText: _obscureText,
                              controller: _passwordController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: kColorWhite,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: kColorSecondary,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              validator: (password) {
                                // Basic validation
                                if (password.isEmpty) {
                                  return "please_fill_this_field".tr();
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      /// Подверждение пароли
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Align(
                                widthFactor: 10,
                                heightFactor: 1.5,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'password_confirm'.tr().toString().toUpperCase() + '*',
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                )),
                            TextFormField(
                              controller: _passwordConfirmController,
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: kColorWhite,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: kColorSecondary,
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
                                } else if (_passwordConfirmController.text != _passwordController.text) {
                                  return "passwords_dont_satisfy".tr();
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ) : Container(),

                  /// Контакный Телефон
                  Align(
                      widthFactor: 10,
                      heightFactor: 1.5,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'phone_number'.tr().toString().toUpperCase() + '*',
                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: InternationalPhoneNumberInput(
                      countries: ['KG', 'RU', 'KZ', 'UA', 'UZ', 'TJ'],
                      keyboardAction: TextInputAction.next,
                      onInputChanged: (PhoneNumber number) async {
                        phoneNumber = number.phoneNumber;
                        initialCountry = number.isoCode;
                        await Users.checkPhone(phoneNumber.trim()).then((value) {
                          print(phoneNumber);
                          setState(() {
                            this.isPhoneExists = !value;
                          });
                        });
                      },
                      onInputValidated: (bool value) {
                        isPhoneCorrect = value;
                      },
                      maxLength: initialCountry == 'KG' ? 11 : 13,
                      selectorConfig:
                          const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              setSelectorButtonAsPrefixIcon: true, useEmoji: true
                          ),
                      ignoreBlank: true,
                      autoValidateMode: AutovalidateMode.always,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phoneNumberController,
                      formatInput: true,
                      // maxLength: initialCountry ==,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please_fill_this_field".tr();
                        } else if (!isPhoneCorrect) {
                          return 'invalid_phone_number'.tr();
                        } else if (isPhoneExists) {
                          return 'phone_number_exists'.tr();
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      spaceBetweenSelectorAndTextField: 0,
                      inputDecoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                        errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: kColorWhite,
                      ),
                      locale: 'ru',
                    ),
                  ),

                  /// Имя user
                  company == is_company.Company ? Container() :
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'name'.tr().toString().toUpperCase() + '*    ',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          validator: (name) {
                            // Basic validation
                            if (name.isEmpty && company == is_company.User) {
                              return "please_fill_this_field".tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Фамилия user
                  company == is_company.Company ? Container() :
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'lastname'.tr().toString().toUpperCase() + '*',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          controller: _lastnameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          validator: (name) {
                            // Basic validation
                            if (name.isEmpty && company == is_company.User) {
                              return "please_fill_this_field".tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Дата рождения
                  company == is_company.Company ? Container() :
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'birth_date'.tr().toString().toUpperCase() + '*',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                            controller: _birthDateController,
                            keyboardType: TextInputType.datetime,
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            onTap: () {
                              _showDataPicker(context);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                              errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              filled: true,
                              fillColor: kColorWhite,
                            ),
                            validator: (value) => value.isEmpty ? "please_fill_this_field".tr() : null),
                      ],
                    ),
                  ),

                  /// Адрес для User
                  company == is_company.Company ? Container() :
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'location'.tr().toString().toUpperCase(),
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: kColorWhite,
                              ),
                          ),
                          suggestionsCallback: (pattern) async {
                            print(pattern);
                            if(pattern.length > 3) {
                              _suggestions = await _fetchAddressSuggestions(pattern);
                              // for(int i=0; i<suggestionsFull.length; i++){
                              //   _suggestions.add(suggestionsFull[i]['value']);
                              // }
                            }
                            return _suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['value']),
                            );
                          },
                          noItemsFoundBuilder: (context) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Text(
                                'address_not_found'.tr(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54
                                ),
                              ),
                            );
                          },
                          transitionBuilder: (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            _typeAheadController.text = suggestion['value'];

                            // if(suggestion['data']['country_iso_code'] != '' && suggestion['data']['country_iso_code'] != null){
                            //   initialCountry = suggestion['data']['country_iso_code'];
                            //   number = PhoneNumber(isoCode: suggestion['data']['country_iso_code']);
                            // }

                            if(suggestion['data']['region_with_type'] != '' && suggestion['data']['region_with_type'] != null){
                              selectedRegion = suggestion['data']['region_with_type'];
                              getDistricts(suggestion['data']['region_with_type']);
                            }

                            if(suggestion['data']['city_with_type'] != '' && suggestion['data']['city_with_type'] != null){
                              selectedDistrict = suggestion['data']['city'];
                            }

                            print(suggestion);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Введите адрес';
                            }
                            return null;
                          },
                          onSaved: (value) => _selectedCity = value,
                        ),
                      ],
                    ),
                  ),

                  /// Область для User
                  company == is_company.Company ? Container() :
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'region'.tr().toString().toUpperCase(),
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                              errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              filled: true,
                              fillColor: kColorWhite,
                            ),
                            selectedItem: selectedRegion
                        ),
                      ],
                    ),
                  ),

                  /// Район для User
                  // company == is_company.Company ? Container() :
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 16),
                  //   child: Flex(
                  //     direction: Axis.vertical,
                  //     children: [
                  //       Align(
                  //           widthFactor: 10,
                  //           heightFactor: 1.5,
                  //           alignment: Alignment.topLeft,
                  //           child: Text(
                  //             'district'.tr().toString().toUpperCase(),
                  //             style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                  //           ),
                  //       ),
                  //       DropdownSearch<String>(
                  //         showSelectedItem: true,
                  //         items: districts,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             selectedDistrict = value;
                  //           });
                  //         },
                  //         dropdownSearchDecoration: InputDecoration(
                  //           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  //           border: OutlineInputBorder(),
                  //           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                  //           errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                  //           errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                  //           floatingLabelBehavior: FloatingLabelBehavior.always,
                  //           filled: true,
                  //           fillColor: kColorWhite,
                  //         ),
                  //         selectedItem: selectedDistrict,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  /// Пол
                  company == is_company.Company ? Container() :
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'gender'.tr().toString().toUpperCase()+'     ',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: user_gender.Male,
                              groupValue: gender,
                              activeColor: kColorPrimary,
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
                              activeColor: kColorPrimary,
                              onChanged: (user_gender value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                            Text('female'.tr(), style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Sign Up button
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: CustomButton(
                        color: kColorPrimary,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {

                            final DateFormat formatter = DateFormat('yyyy-MM-dd');
                            Users user = Users();
                            user.name = _nameController.text;
                            user.phone_number = phoneNumber;
                            user.address = _typeAheadController.text.toString();
                            user.birth_date = company == is_company.Company ? DateTime.now() : formatter.parse(_birthDateController.text);
                            user.surname = _lastnameController.text;
                            user.is_company = company == is_company.Company;
                            // user.is_migrant = isMigrant ? 1 : 0;
                            // user.linkedin = _linkedinController.text;
                            user.gender = gender == user_gender.Male ? "male" : "female";
                            user.region = selectedRegion;
                            user.district = selectedDistrict;
                            user.email = _emailController.text;
                            user.password = _passwordController.text;

                            if (company == is_company.User) {
                              debugPrint(phoneNumber);

                              int min = 100000;
                              int max = 999999;
                              var randomizer = new Random();
                              var rNum = min + randomizer.nextInt(max - min);

                              smscRuMessage = 'Код подтверждения - $rNum';

                              final response = await http.get(Uri.parse('https://smsc.ru/sys/send.php?login=$smscRuLogin&psw=$smscRuPassword&phones=$phoneNumber&mes=$smscRuMessage'));

                              if (response.statusCode == 200) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OtpSmsScreen(
                                      verificationId: rNum.toString(),
                                      users: user,
                                      phone: phoneNumber,
                                      login: false,
                                      imageFile: _imageFile,
                                    )
                                ));
                              } else {
                                throw Exception('Не удалось отправить СМС-сообщение с кодом.');
                              }

                              // await otpRegister(phoneNumber: phoneNumber, context: context, users: user, imageFile: _imageFile);
                            } else {

                              await Users.checkUsername(_emailController.text).then((value) async {

                                int min = 100000;
                                int max = 999999;
                                var randomizer = new Random();
                                var rNum = min + randomizer.nextInt(max - min);

                                smscRuMessage = 'Код подтверждения - $rNum';

                                final response = await http.get(Uri.parse('https://smsc.ru/sys/send.php?login=$smscRuLogin&psw=$smscRuPassword&phones=$phoneNumber&mes=$smscRuMessage'));

                                if (response.statusCode == 200) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OtpSmsScreen(
                                        verificationId: rNum.toString(),
                                        users: user,
                                        phone: phoneNumber,
                                        login: false,
                                        imageFile: _imageFile,
                                      )
                                  ));
                                } else {
                                  throw Exception('Не удалось отправить СМС-сообщение с кодом.');
                                }

                              });
                            }
                          }
                        },
                        text: 'create'.tr(),
                      ),
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

  Future<List<dynamic>> _fetchAddressSuggestions(String pattern) async {
    List<dynamic> suggestions = [];
    String token = "132a62a4c888a776c87241ed9e615638651f14a8";

    if(pattern.length > 3) {
      final response = await http.post(
        Uri.parse('https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + token
        },
        body: jsonEncode(<String, String>{
          'query': pattern,
          'count': '3'
        }),
      );

      if (response.statusCode == 200) {
        Map<dynamic, dynamic> responseData = json.decode(response.body);
        for(int i = 0; i < responseData['suggestions'].length; i++) {
          suggestions.add(responseData['suggestions'][i]);
        }
      } else {
        throw Exception('Не удается найти адрес.');
      }

    }
    return suggestions;
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
      // location = AppLatLong(
      //     lat: 56.321639975018435,
      //     long: 43.99102901753601
      // );
    } catch (_) {
      location = defLocation;
    }

    // _getAddressFromLatLng(location);
  }

  Future<void> _getAddressFromLatLng(AppLatLong location) async {
    
    final response = await http.get(Uri.parse('https://geocode-maps.yandex.ru/1.x?geocode=${location.long},${location.lat}&apikey=d88902f6-178b-4bba-82ed-0a1f4707031d&format=json'));

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> responseData = json.decode(response.body);
      String countryCode = responseData['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['metaDataProperty']['GeocoderMetaData']['AddressDetails']['Country']['CountryNameCode'];
      String region = responseData['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['metaDataProperty']['GeocoderMetaData']['AddressDetails']['Country']['AdministrativeArea']['AdministrativeAreaName'];
      String district = responseData['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['metaDataProperty']['GeocoderMetaData']['AddressDetails']['Country']['AdministrativeArea']['SubAdministrativeArea']['Locality']['LocalityName'];

      setState(() {

        if(countryCode != '' && countryCode != null){
          initialCountry = countryCode;
          number = PhoneNumber(isoCode: countryCode);
        }

        if(region != '' && region != null){
          selectedRegion = region;
        }

        // getDistricts(region);
        //
        // if(district != '' && district != null){
        //   selectedDistrict = district;
        // }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

}
