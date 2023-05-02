import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/screens/otp_verification_screen.dart';
import 'package:ishtapp/utils/constants.dart';

Future otpRegister(
    {@required BuildContext context, @required String phoneNumber, @required Users users, PickedFile imageFile, bool login = false}) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
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
      }));
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Navigator.of(context).pop();
        showSnackBar(message: '${e.message}', backgroundColor: Colors.red, context: context);
      },
      codeSent: (String verificationId, int resendToken) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
                  verificationId: verificationId,
                  users: users,
                  phone: phoneNumber,
                  login: login,
                  imageFile: imageFile,
                )));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } on FirebaseAuthException catch (e) {
    showSnackBar(context: context, message: '${e.message}', backgroundColor: Colors.red);
    Navigator.of(context).pop();
  }
}

void showSnackBar({@required BuildContext context, @required String message, @required Color backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(message)));
}
