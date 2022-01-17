import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_api/weather_screen.dart';

class phoneScreen extends StatefulWidget {
  const phoneScreen({Key? key}) : super(key: key);

  @override
  _phoneScreenState createState() => _phoneScreenState();
}

class _phoneScreenState extends State<phoneScreen> {

  TextEditingController phoneController = TextEditingController(text: "+91");
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool status = false;
  bool otpVisibility = false;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone number"),
              keyboardType: TextInputType.phone,
            ),

            Visibility(child: TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: "Enter the OTP"),
              keyboardType: TextInputType.number,
            ),visible: otpVisibility,),

            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if(otpVisibility){
                    verifyOTP();
                    if(status) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => weatherScreen()));
                    }
                  }
                  else {
                    loginWithPhone();
                  }
                },
                child: Text(otpVisibility ? "Verify" : "Login")),
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value){
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

  void verifyOTP() async {

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value){
      status = true;
      print("Logged in successfully");
      Fluttertoast.showToast(
          msg: "Logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
}