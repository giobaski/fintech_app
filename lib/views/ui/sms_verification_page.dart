import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';
import 'package:skany/views/widgets/custom_elevated_button.dart';

class SmsVerificationPage extends StatefulWidget {
  SmsVerificationPage({Key? key}) : super(key: key);

  @override
  State<SmsVerificationPage> createState() => _SmsVerificationPageState();
}

class _SmsVerificationPageState extends State<SmsVerificationPage> {
  final AuthController authController = Get.find();
  final TextEditingController _smsCodeController = TextEditingController();
  bool _validate = false;

  int timeLeft = 15;

  void _startCountDown(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return; // to avoid memory leak!

      if(timeLeft > 0){
        setState(() {
          timeLeft = timeLeft - 1;
          print(timeLeft);
        });
      } else{
        timer.cancel();
      }
    });
  }

  @override
    void initState() {
      super.initState();

      _startCountDown();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SMS ვერიფიკაცია"),
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("ნაბიჯი 2/2...", style: TextStyle(color: Colors.indigo[500], fontWeight: FontWeight.bold),),
                ),
                Row(
                  children: [
                    Expanded(child: _buildRetrieveSmsCodeBtn()),
                    SizedBox(width: 20),
                    Expanded(child: _buildSmsCodeTextField())
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: timeLeft == 0
                      ? Text("")
                      : Text("0 : ${timeLeft.toString()}", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ),
                // Text("SMS კოდის თავიდან მოთხოვნას შეძლებთ 1 წუთის შემდეგ", style: TextStyle(color: Colors.grey, fontSize: 9)),
                _buildVerificationBtn(),

                SizedBox(height: 10),
                Text("ვერიფიკაციის კოდი გაგზავნილია თქვენს ნომერზე! \nკოდი ვალიდურია 5 წუთის განმავლობაში. \nSMS კოდის თავიდან მოთხოვნას შეძლებთ 1 წუთის შემდეგ",
                    style: TextStyle(color: Colors.grey, fontSize: 9),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          ),
        ));
  }

  //My Widgets:
  Widget _buildRetrieveSmsCodeBtn(){
    return Container(
        height: 40,
        child: ElevatedButton(
          onPressed: (timeLeft > 0)
              ? null
              : () {
                  authController.retrieveSmsCode();
                  setState(() {
                    timeLeft = 15;
                  });
                  _startCountDown();
          },
          child: Text("SMS მოთხოვნა"),
          // style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all(Colors.red)),
        ));
  }


  Widget _buildSmsCodeTextField (){
    return Container(
      height: 40,
      child: TextField(
        controller: _smsCodeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'SMS Code',
          labelStyle: TextStyle(fontSize: 14),
          errorText: _validate ? 'ცარიელია' : null,
        ),
      ),
    );
  }

  Widget _buildVerificationBtn() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _smsCodeController.text.isEmpty
                ? _validate = true
                : _validate = false;
          });
          // authController.verifyPhone(_smsCodeController.text);  // გამოიყენე როცა სმს ტელეფონზე მისვლაზე გადაეწყობა, ახლა რექვესთში მოდის
          authController.verifyPhone();
        },
        child: Text("ვერიფიკაცია"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigo)),
      ),
    );
  }
}
