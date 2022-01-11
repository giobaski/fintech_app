import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:skany/views/ui/home_page.dart';
import 'package:skany/views/ui/installment_details_page.dart';
import 'package:skany/views/ui/login_page.dart';
import 'package:skany/views/ui/profile_page.dart';
import 'package:skany/views/ui/register.dart';
import 'package:skany/views/ui/sms_verification_page.dart';
import 'package:skany/views/ui/splash_view.dart';
import 'package:get/get.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'განვადება Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      // home: SplashView(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashView(),),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/sms', page: () => SmsVerificationPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        // GetPage(name: '/myinstallments', page: () => MyInstallmentsPage()),
        GetPage(name: '/installment', page: () => InstallmentDetailsPage()),
        // GetPage(name: '/help', page: () => HelpPage()),
      ],

    );
  }
}
