import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';
import 'package:skany/views/ui/home_page.dart';
import 'package:skany/views/ui/sms_verification_page.dart';
import 'package:skany/views/widgets/custom_elevated_button.dart';
import 'login_page.dart';

class SplashView extends StatelessWidget {
  SplashView({Key? key}) : super(key: key);

  final authController = Get.put(AuthController()); //Todo: initialize in a splashview()

//TODO: check login status and after 5 sec open LoginPage or Homepage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(Get.arguments?? "#გამარჯობა", style: TextStyle(fontWeight: FontWeight.bold),), //#გამარჯობა ან #ნახვამდის
          // backgroundColor: Colors.indigoAccent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),

      body: GestureDetector(
        onTap: () => Get.to(() => HomePage()),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.2,
                  // 0.4,
                  // 0.6,
                  0.9,
                ],
                colors: [
                  // Colors.deepPurple,
                  // Colors.white,
                  Colors.indigoAccent,
                  Colors.indigo, //teal
                ],
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Skany Solutions!',
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'ყველაზე მარტივი განვადება!',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 25),
                CustomElevatedButton(
                  child: Text("დაწყება"),
                  onPressed: () {
                    authController.isLogged.value ? Get.to(() => HomePage()) : Get.to(() => LoginPage());
                    },
                    // Get.to(() => HomePage()); //avoiding loginPage
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
