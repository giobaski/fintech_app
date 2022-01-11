import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skany/models/installment.dart';
import 'package:skany/services/installment_api_service.dart';

import 'auth_controller.dart';

class InstallmentController extends GetxController {
  final AuthController authController = Get.find(); //for token

  late String token;

  var storeFound = false.obs;   //უნდა მოიძებნოს მაღაზიის პერსონალური ნომრით (9-11 ციფრი)
  var storeId = 0.obs; // მაგ. მაღაზიის ID=1
  var storeTitle = ''.obs;

  var isLoading = false.obs;  //განვადებების გამოთხოვა სერვერიდან
  var myInstallments = <Installment>[].obs;
  var installment = Installment().obs;


  @override
  void onInit() {
    super.onInit();
    token = authController.token.value;
    fetchInstallments();
  }

  void fetchInstallments() async {
    try {
      isLoading.value = true;
      myInstallments.value = await InstallmentApiService.fetchInstallments(token);
      isLoading.value = false;
    } on Exception catch (_, e) {
      Get.snackbar("დაფიქსირდა სერვერის შეცდომა!", "", //Todo: handle exception
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // პარტნიორი მაღაზიის პირადი ნომრით ვამოწმებთ არსებობს თუ არა ობიექტი
  Future<bool> checkStore(String storePersonalNumber) async {
    try{
      storeFound.value = false;
      var response = await InstallmentApiService.checkStore(storePersonalNumber, token);
      storeFound.value = true;
      storeId.value = response.storeId;
      storeTitle.value = response.storeTitle;
      // Get.snackbar("მოიძებნა: ${response.storeTitle}",
      //   "განვადების დასაწყებად შეიყვანეთ აღნიშნული კოდი: ${storeId}",
      //   snackPosition: SnackPosition.TOP,
      //   duration: Duration(seconds: 15),
      // );
      return true;

    } on Exception catch (_, e) {
      Get.snackbar("წარუმატებელი ძებნა!", "აღნიშნული საიდენტიფიკაციო კოდით პარტნიორი ვერ მოიძებნა", //Todo: handle exception
          snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5));
      return false;
    }
  }

  //ახალი განვადების განთავსება, განვადების დაწყება.
  // void storeInstallment(int storeId)
    void storeNewInstallment() async {
    try{
      var response = await InstallmentApiService.storeInstallment(storeId.value, token);
      //updates in home page
      //Todo: ავტომატურად გადავიდეს ახალი განვადების გვერდზე???
      fetchInstallments();

      Get.snackbar("მოთხოვნა გაგზავნილია",
        "დეტალების სანახავად დააჭირეთ განვადება ID: ### ",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
      );
    } on Exception catch (_, e) {
      Get.snackbar("დაფიქსირდა კოდის მიღების შეცდომა!", "აღნიშნული საიდენტიფიკაციო კოდით პარტნიორი ვერ მოიძებნა", //Todo: handle exception
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5));
    }
  }

  Future<void> getInstallmentById(String installmentId) async {
    try{
      print("before get_installmentById: " + installment.value.toString());
      var res = await InstallmentApiService.getInstallmentById(installmentId, token);

      print("############### res ----"+ res.toString());
      // print(res.runtimeType);
      installment(res);  //It updates the installment().obs value
      print("after get_installmentById: " + installment.toString());
      // installment(Installment(id: res.id));
      // print("after get_installmentById: " + installment().toString());

    } catch (e){
      print("##### catch dsdsd" + e.toString());
    }

  }


}