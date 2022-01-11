import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';
import 'package:skany/utils/constants.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  //Todo: use lazy bindings for dependency injection later
  final AuthController authController = Get.find();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("ავტორიზაცია"), centerTitle: true,),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          // color: Colors.indigo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 30),
              //   child: Text(
              //     "გაიარეთ ავტორიზაცია",
              //     style: TextStyle(
              //         color: Colors.teal,
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold
              //     ),
              //   ),
              // ),

              // Start building login form
              SizedBox(height: 50),
              _buildPhoneNumberTextField(),
              SizedBox(height: 12),
              _buildPasswordTextField(),
              _buildForgotPasswordBtn(),
              _buildLoginBtn(),
              SizedBox(height: 50),
              Divider(),
              _buildOfferRegistration(),

              SizedBox(height: 50),
              Divider(),
              //make it a hyperlink text
              Text("www.skanysolutions.com",
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }





  //my widgets:
  Widget _buildPhoneNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ტელეფონის ნომერი:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(),
          child: TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone, color: Colors.teal),
              labelText: 'მაგ. 555112233',
              hintText: '9 ციფრი',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "პაროლი:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 50,
          // width: 250,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.password, color: Colors.indigo),
              labelText: 'შეიყვანე პაროლი',
              // hintText: '37255945238',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () => print("#### forgot button pressed"),
          child: Text("დაგავიწყდათ პაროლი?")),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(10),
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          onPressed: () async {
            authController.login(
                _phoneNumberController.text, _passwordController.text);
          },
          child: Text("შესვლა")),
    );
  }

  Widget _buildOfferRegistration() {
    return Column(
      children: [
        Text("არ ხართ რეგისტრირებული ჩვენთან?",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () {
                Get.defaultDialog(
                  title: "საიტის ლიცენზია", titleStyle: TextStyle(color: Colors.grey),
                  cancel: TextButton(onPressed: (){Get.back();}, child: Text("უკან", style: TextStyle(color: Colors.redAccent),),),
                  confirm: Obx(() => ElevatedButton(
                    onPressed: authController.isConfirmed.value? (){
                      Get.offNamed("/register");
                    }
                    : null,
                    child: Text("რეგისტრაცია"),
                    ),
                  ),

                  content: Container(
                    height: 500,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(Constants.CONFIRMATION_1_1_Site_License, style: TextStyle(fontSize: 12)),
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: authController.isConfirmed.value,
                                  onChanged: (value) {
                                    authController.isConfirmed.value = !authController.isConfirmed.value;
                                  },
                                  activeColor: Colors.teal,
                                  checkColor: Colors.white,

                                ),
                                Text("ვეთანხმები"),
                              ],
                            ),
                    ),


                            // ElevatedButton(onPressed: (){}, child: Text("რეგისტრაციის დაწყება"))
                          ],
                        )
                    ),
                  ),
                );
              },
              child: Text("რეგისტრაცია")),
        ),
      ],
    );
  }
}
