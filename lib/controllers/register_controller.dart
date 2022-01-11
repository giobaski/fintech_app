import 'package:get/get.dart';
import 'package:skany/services/auth_api_service.dart';
import 'package:skany/models/registration_request_model.dart';
import 'package:skany/views/ui/login_page.dart';

class RegisterController extends GetxController {
  var sesId = ''.obs;
  var smsCode = 0.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSession();
  }

  // სესიის მიღება კლიენტის რეგისტრაციისთვის
  void getSession() async {
    try {
      sesId.value = await AuthApiService.getSession();
      print("##### getSession() has been called, ses_id:"+ sesId.value);

    } catch (e) {
      Get.snackbar("დაფიქსირდა კოდის მიღების შეცდომა!",
          "",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5));
    }
  }

  void retrieveSmsCode(String phoneNumber) async {
    try {
      var smsCodeResponse = await AuthApiService.retrieveSmsCode(sesId.value, phoneNumber);
      smsCode.value = smsCodeResponse.smsCode;

      Get.snackbar(
        "sms code: ${smsCode.value} (Debug mode!)",
        smsCodeResponse.message,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 10),
      );
    } catch (e) {
      Get.snackbar("დაფიქსირდა კოდის მიღების შეცდომა, თავიდან მოითხოვეთ sms!", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  void register(RegistrationRequestModel registrationRequestModel) async {
    try{
       var registrationResponse = await AuthApiService.register(registrationRequestModel);
      print("##### წარმატებით რეგისტრაცია" +  registrationResponse);

      Get.snackbar(registrationResponse, "შეგიძლიათ გაიაროთ ავტორიზაცია!",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      // Navigate to the login screen
      Get.to(LoginPage());

    } catch(e){
      Get.snackbar("სერვერის შეცდომა", "გთხოვთ თავიდან სცადოთ რეგისტრაცია",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}
