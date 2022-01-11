import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skany/models/app_user.dart';
import 'dart:developer' as devlog;
import 'package:skany/models/login_response.dart';
import 'package:skany/services/auth_api_service.dart';
import 'package:skany/views/ui/home_page.dart';
import 'package:skany/views/ui/profile_page.dart';
import 'package:skany/views/ui/sms_verification_page.dart';
import 'package:skany/views/ui/splash_view.dart';

class AuthController extends GetxController {
  late FlutterSecureStorage _localStorage;
  var token = ''.obs;
  var isLogged = false.obs;

  var phoneNumber = ''.obs;
  var smsCode = 0.obs;
  var sesId = ''.obs; //Todo: check initial value

  Rx<User> appUser = User().obs;

  //Getters and setters
  User get user => appUser.value;
  set user(User value) => this.appUser.value = value;

  //რეგისტრაციის წინა თანხმობის ჩექბოქსი (1.1)
  var isConfirmed = false.obs;


  @override
  Future<void> onInit() async {
    super.onInit();

    _localStorage = const FlutterSecureStorage();
    token.value = await _localStorage.read(key: 'token') ?? "";
    print("####token:" + token.value.toString()); //Todo: delete this line

    //ლოკალურ მეხსიერებაში შენახულია თუ არა თოქენი
    checkLoginStatus();
  }

  // todo: sms verifikaciis mere -true, tu ver gaivlis tokeni mainc shenaxulia storijshi, ase om gatyuebsb. check islogged
  void checkLoginStatus() {
      if(token.value.isEmpty){
        isLogged.value = false;
      } else {
        isLogged.value = true;
        // პირველი ავტორიზაციის შემდეგ, აპლიკაციის ყოველ გახსნაზე იუზერის ინფო მოგვაქვს სერვერიდან
        // თუ თოქენი არაა წაშლილი
        getUserProfile();
      }
  }


  //კლიენტის მობილურზე გაიგზავნება სმს კოდი 5 ციფრი, ამის შემდეგ კლიენტი გადადის მობილურის იდენტიფიკაციის ფანჯარაში
  void login(String phone, String password) async {
    phoneNumber.value = phone; // I will use later for retrieving sms code
    try {
      var loginResponse =
          await AuthApiService.loginWithPhoneAndPassword(phone, password);
      // storage = GetStorage(); // you can move it to the auth service
      // storage.write('token', loginResponse.accessToken);
      // await _localStorage.write(key: 'token', value: loginResponse.accessToken);

      token.value = loginResponse.accessToken;
      smsCode.value = loginResponse.smsCode;
      sesId.value = loginResponse.sesId;
      Get.snackbar("მონაცემები სწორია!", "ავტორიზაციის პირველი ნაბიჯი წარმატებით გაიარეთ",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
      );
      // Navigate to the sms verification screen
      Get.to(SmsVerificationPage());
    } on Exception catch (_, e) {
      Get.snackbar("ავტორიზაციის შეცდომა", "გთხოვთ თავიდან სცადოთ მონაცემების შეყვანა ან გაიარეთ რეგისტრაცია",
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  //სმს-ით მიღებული 5 ნიშნა კოდის ვერიფიკაცია.
  // ვერიფიკაციის შემდეგ ვიღებთ იუზერის მონაცმებს და ავტორიზაცია დასრულებულია.
  void verifyPhone() async {
    try{
      appUser.value = await AuthApiService.verifyPhone(smsCode.value, sesId.value, token.value, );
      print("####USERR: " + appUser.toString());
      devlog.log("INFO #### This is an USER returned after phone verification: " + appUser.toString(), name:'GIOLOG');

      isLogged.value = true;
      await _localStorage.write(key: 'token', value: this.token.value);


      Get.snackbar("sms ვერიფიკაცია", "თქვენი ტელეფონის ნომერი ვერიფიცირებულია",
          snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );

      // Navigate to...
      //Todo: Get.to(user.isVerified.isEqual(1) ? HomePage() : VerificationPage());
      Get.off(appUser.value.isVerified!.isEqual(1) ? HomePage() : ProfilePage());

    } on Exception catch(_, e){
      Get.snackbar("დაფიქსირდა sms ვერიფიკაციის შეცდომა", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 15),
      );
    }
  }


  void getUserProfile() async {
    try{
      appUser.value = await AuthApiService.getUserProfile(token.value);
      print("###  : : getUserProfile() ${appUser.value}");
    } catch (e){
      print("იუზერის ინფორმაციის წამოღება წარუმატებლად დასრულდა");
    }
  }


  // SMS კოდის თავიდან მოთხოვნა სერვერიდან
  void retrieveSmsCode() async {
    try{
      var smsCodeResponse = await AuthApiService.resendSmsCode(sesId.value, token.value);
      smsCode.value = smsCodeResponse.smsCode;

      Get.snackbar("sms code: ${smsCode.value} (Debug mode!)",
        smsCodeResponse.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 10),
      );

    } catch(e){
      Get.snackbar("დაფიქსირდა კოდის მიღების შეცდომა!", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

  }



void logout(){
    print("####Debug!!!: Token before logout: ${token.value}, isLogged:${isLogged.value}");
  _localStorage.delete(key: 'token');
  isLogged.value = false;
  token.value = "";
  print("####Debug!!!: Token after logout: ${token.value}, isLogged:${isLogged.value}");

  Get.to(SplashView(),
      transition: Transition.downToUp,
      arguments: "#ნახვამდის",
  );
}

}
