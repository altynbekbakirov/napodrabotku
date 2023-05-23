import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/utils/common_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:translit/translit.dart';

class OtpSmsScreenLogin extends StatefulWidget {
  OtpSmsScreenLogin({Key key, @required this.verificationId, @required this.users, @required this.phone, this.imageFile, this.login = false})
      : super(key: key);
  final String verificationId, phone;
  final Users users;
  final bool login;
  final PickedFile imageFile;

  @override
  State<OtpSmsScreenLogin> createState() => _OtpSmsScreenLoginState();
}

class _OtpSmsScreenLoginState extends State<OtpSmsScreenLogin> {
  bool isSubmitEnabled = false;

  final firstController = TextEditingController();
  final secondController = TextEditingController();
  final thirdController = TextEditingController();
  final fourthController = TextEditingController();
  final fifthController = TextEditingController();
  final sixController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    fifthController.dispose();
    sixController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verification".tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${"we_have_sent_a_verification_sms".tr()} ${widget.phone}',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'enter_the_code_received_in_sms'.tr(),
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildItem(context: context, first: true, last: false, controller: firstController),
                      buildItem(context: context, first: false, last: false, controller: secondController),
                      buildItem(context: context, first: false, last: false, controller: thirdController),
                      buildItem(context: context, first: false, last: false, controller: fourthController),
                      buildItem(context: context, first: false, last: false, controller: fifthController),
                      buildItem(context: context, first: false, last: true, controller: sixController),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${'this_code_will_expire_in'.tr()} ",
                      ),
                      TweenAnimationBuilder(
                          tween: Tween(begin: 60.0, end: 0.0),
                          duration: const Duration(seconds: 60),
                          builder: (context, value, child) => Text(
                            '${value.toInt()}',
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomButton(
                      color: kColorPrimary,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      text: 'cancel'.tr(),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget buildItem({@required BuildContext context, @required bool first, @required bool last, @required TextEditingController controller}) {
    return Container(
      width: 50,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF435F81)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
        autofocus: first,
        textInputAction: first ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(counterText: "", border: InputBorder.none),
        maxLength: 1,
        onChanged: (value) async {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
          submitButtonEnable();
          try {
            if (widget.login) {
            } else {
              if (isSubmitEnabled) {
                final smsCode =
                    '${firstController.text.toString()}${secondController.text.trim()}${thirdController.text.trim()}${fourthController.text.trim()}${fifthController.text.trim()}${sixController.text.trim()}';

                if(widget.verificationId == smsCode){
                  await Users.checkPhone(widget.users.phone_number).then((value) async {

                    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    //
                    //
                    // var uri = Uri.parse(API_IP + API_REGISTER1 + '?lang=' + Prefs.getString(Prefs.LANGUAGE));
                    // var request = new http.MultipartRequest("POST", uri);
                    //
                    // request.fields["id"] = widget.users.id.toString();
                    // request.fields["password"] = Translit().toTranslit(source: widget.users.name).toLowerCase();
                    // request.fields["name"] = widget.users.name;
                    // request.fields["lastname"] = widget.users.surname;
                    // request.fields["email"] = "";
                    // request.fields["birth_date"] = formatter.format(widget.users.birth_date);
                    // request.fields["active"] = '1';
                    // request.fields["phone_number"] = widget.users.phone_number;
                    // request.fields["type"] = widget.users.is_company ? 'COMPANY' : 'USER';
                    // request.fields["linkedin"] = "";
                    // request.fields["is_migrant"] = "0";
                    // request.fields["gender"] = widget.users.gender.toString();
                    // request.fields["region"] = widget.users.region.toString();
                    // request.fields["district"] = widget.users.district.toString();
                    // request.fields["job_type"] = "";
                    // request.fields["is_product_lab_user"] = "0";
                    //
                    // // open a byteStream
                    // // if (widget.imageFile != null) {
                    // //   var _image = File(widget.imageFile.path);
                    // //   var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
                    // //   // get file length
                    // //   var length = await _image.length();
                    // //   // multipart that takes file.. here this "image_file" is a key of the API request
                    // //   var multipartFile = new http.MultipartFile('avatar', stream, length, filename: basename(_image.path));
                    // //   // add file to multipart
                    // //   request.files.add(multipartFile);
                    // // }
                    //
                    // request.send().then((response) {
                    //   print(response);
                    //   response.stream.transform(utf8.decoder).listen((value) {
                    //     var response = json.decode(value);
                    //     if (response['status'] == 200) {
                    //       Prefs.setString(Prefs.PASSWORD, Translit().toTranslit(source: widget.users.name).toLowerCase());
                    //       Prefs.setString(Prefs.TOKEN, response["token"]);
                    //       Prefs.setString(Prefs.PHONE_NUMBER, response["phone_number"]);
                    //       Prefs.setString(Prefs.EMAIL, response["email"]);
                    //       Prefs.setInt(Prefs.USER_ID, response["id"]);
                    //       Prefs.setString(Prefs.USER_TYPE, widget.users.is_company ? 'COMPANY' : 'USER');
                    //       Prefs.setString(Prefs.PROFILEIMAGE, response["avatar"]);
                    //       Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
                    //     } else {
                    //       showSnackBar(context: context, message: 'Error occurred while registering', backgroundColor: Colors.red);
                    //     }
                    //   });
                    // });
                  });
                }
              }
            }
          } catch (e) {
            showSnackBar(context: context, message: e.message.toString(), backgroundColor: Colors.red);
            print(e);
          }
        },
        textAlign: TextAlign.center,
      ),
    );
  }

  void submitButtonEnable() {
    if (firstController.text.trim().isNotEmpty &&
        secondController.text.trim().isNotEmpty &&
        thirdController.text.trim().isNotEmpty &&
        fourthController.text.trim().isNotEmpty &&
        fifthController.text.trim().isNotEmpty &&
        sixController.text.trim().isNotEmpty) {
      setState(() {
        isSubmitEnabled = true;
      });
    } else {
      setState(() {
        isSubmitEnabled = false;
      });
    }
  }
}
