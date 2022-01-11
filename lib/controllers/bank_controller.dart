import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skany/services/bank_api_service.dart';

import 'auth_controller.dart';

class BankController extends GetxController {
  final AuthController authController = Get.find(); //for token

  // final availableBanks = ["ლაზიკა კაპიტალი", "საქართველოს ბანკი", "TBC"];
  var availableBanks = [];
  var selectedBank = "ლაზიკა კაპიტალი".obs;

  @override
  void onInit() {
    super.onInit();
    fetchAvailableBanks();
  }

  void fetchAvailableBanks() async {
    try {
      availableBanks = await BankApiService.fetchAvailableBanks(authController.token.value);
    } catch (e) {
      Get.snackbar(
          "შეცდომა!", "ბანკების გამოთხოვა სერვერიდან ვერ განხორციელდა!",
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
    }
  }


// void checkBankResponse(int installmentId)
// void sendInstallmentToBank()

}
