import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/screens/otp_sms_screen.dart';
import 'package:ishtapp/screens/otp_sms_screen_login.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/pref_manager.dart';

import 'package:http/http.dart' as http;

enum is_company { Company, User }

class SignInScreen extends StatefulWidget {
  final String routeFrom;

  SignInScreen({this.routeFrom});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _obscureText = true;
  bool _isPhoneCorrect = false;
  bool isPhoneExists = false;
  is_company company = is_company.User;
  String initialCountry = 'RU';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');
  String phoneNumber = '';

  // SMSC.RU credentials
  String smscRuLogin = 'pobed-a';
  String smscRuPassword = 'podrab-180523';
  String smscRuMessage = '';

  void _showDialog(context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20),
        child: AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            CustomButton(
              height: 40.0,
              text: 'ok'.tr(),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
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

  setMode() {
    setState(() {
      company = Prefs.getString(Prefs.ROUTE) == "COMPANY" ? is_company.Company : is_company.User;
    });
  }

  @override
  void initState() {
    setMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sign_in_title".tr()),
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
                  "sign_in".tr(),
                  style: TextStyle(fontSize: 24, color: kColorDark, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ),

            /// Form
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  company == is_company.Company
                      ?
                      /// Контакный Телефон
                      Align(
                          widthFactor: 10,
                          heightFactor: 1.5,
                          alignment: Alignment.topLeft,
                          child: Text(
                            'email'.tr().toUpperCase() + '*',
                            style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                          ))
                      :
                      /// Электронный адрес
                      Align(
                          widthFactor: 10,
                          heightFactor: 1.5,
                          alignment: Alignment.topLeft,
                          child: Text(
                            'phone_number'.tr().toString().toUpperCase() + '*',
                            style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                        ),

                  company == is_company.User ?
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: InternationalPhoneNumberInput(
                      countries: ['KG', 'RU', 'KZ', 'UA', 'UZ', 'TJ'],
                      keyboardAction: TextInputAction.next,
                      onInputChanged: (PhoneNumber number) async {
                        phoneNumber = number.phoneNumber;
                        await Users.checkPhone(phoneNumber.trim()).then((value) {
                          print(phoneNumber);
                          setState(() {
                            isPhoneExists = !value;
                          });
                        });
                      },
                      onInputValidated: (bool value) {
                        _isPhoneCorrect = value;
                      },
                      selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true, useEmoji: true),
                      ignoreBlank: true,
                      autoValidateMode: AutovalidateMode.always,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phoneNumberController,
                      formatInput: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please_fill_this_field".tr();
                        } else if (!_isPhoneCorrect) {
                          return 'invalid_phone_number'.tr();
                        } else if (!isPhoneExists) {
                          return 'phone_number_not_exists'.tr();
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
                      locale: 'ru_RU',
                    ),
                  ) :
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      controller: _usernameController,
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
                      validator: (value) {
                        // Basic validation
                        if (value.isEmpty) {
                          return "please_fill_this_field".tr();
                        } else if (!EmailValidator.validate(value.trim())) {
                          return 'please_write_valid_email'.tr();
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  company == is_company.Company ?
                  Container(
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
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            obscureText: _obscureText,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              filled: true,
                              fillColor: kColorWhite,
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                              errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                  color: kColorSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            validator: (password) {
                              if (password.isEmpty) {
                                return "please_fill_this_field".tr();
                              }
//                      else if (password.length <5) {
//                        return "password_must_at_least_5_chars".tr();
//                      }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),

                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.pushNamed(context, Routes.forgot_password);
                  //     },
                  //     child: Text(
                  //       'forgot_password'.tr(),
                  //       style: TextStyle(fontSize: 14, color: kColorDark, fontWeight: FontWeight.w500),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 30),

                  /// Sign In button
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomButton(
                      color: kColorPrimary,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {

                          /// Remove previous screens
                          Users user = new Users();
                          if(company == is_company.Company) {
                            user.login(_usernameController.text.trim(),
                                _passwordController.text.trim()).then((value) {
                              if (value == "OK") {
                                Navigator.of(context).popUntil((route) =>
                                route.isFirst);
                                Navigator.of(context).pushNamed(Routes.home);
                              } else {
                                _showDialog(context,
                                    "password_or_email_is_incorrect".tr());
                              }
                            });
                          } else {

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
                                    login: true,
                                    imageFile: null,
                                  )
                              ));
                            } else {
                              throw Exception('Не удалось отправить СМС-сообщение с кодом.');
                            }

                            // user.loginPhoneOTP(phoneNumber.trim()).then((
                            //     value) {
                            //   if (value == "OK") {
                            //     Navigator.of(context).popUntil((route) =>
                            //     route.isFirst);
                            //     Navigator.of(context).pushNamed(Routes.home);
                            //   } else {
                            //     _showDialog(context,
                            //         "invalid_phone_number_or_password".tr());
                            //   }
                            // });
                          }
                        }
                      },
                      text: 'sign_in'.tr(),
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
