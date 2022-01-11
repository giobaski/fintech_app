import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skany/models/check_store_response.dart';
import 'package:skany/models/installment.dart';

class InstallmentApiService{
  static var client = http.Client();
  static final BASE_URL = "http://skanysolutions.com/api";


  static Future<List<Installment>> fetchInstallments (String token) async {
    var response = await client.get(Uri.parse("$BASE_URL/client_installments"),
        headers: <String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
          "accept": "application/json"
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var list = jsonResponse['message'] as List;
      var installments = list.map((value) => Installment.fromJson(value)).toList();
      return installments;
    } else {
      throw Exception(
          "განვადებების გამოთხოვა სერვერიდან ვერ განხორციელდა");
    }
  }

  static Future<CheckStoreResponse> checkStore (String storePersonalNumber, String token) async{
    var response = await client.post(
        Uri.parse("$BASE_URL/check_store"),
        body: jsonEncode({"pn": storePersonalNumber}),
        headers: <String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
          "accept": "application/json"
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return CheckStoreResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 401){
      throw  Exception(jsonDecode(response.body)['message']); //Todo: use proper error handling
    } else {
      throw Exception("მაღაზიის პერსონალური ნომრის გადამოწმება ვერ განხორციელდა");
    }
  }

  static Future<String> storeInstallment(int storeId, String token) async{
    var response = await client.post(Uri.parse("$BASE_URL/post_installment"),
        body: jsonEncode({"id": storeId.toString()}),
        headers: <String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
          "accept": "application/json"
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['message'];
    } else if (response.statusCode == 401){
      throw  Exception(jsonDecode(response.body)['message']); //Todo: use proper error handling
    } else {
      throw Exception("ახალი განვადების შექმნა ვერ განხორციელდა");
    }
  }


  static Future<Installment> getInstallmentById(String installmentId, String token) async {
    var response = await client.post(Uri.parse("$BASE_URL/client_get_installment"),
        body: jsonEncode({
          "id": installmentId
        }),
        headers: <String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
          // "accept": "application/json"
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("##### from Servise API json: " + jsonResponse['message'][0].toString());
      return Installment.fromJson(jsonResponse['message'][0]);
    } else {
      throw Exception("სერვერის შეცდომა! განვადება ID:${installmentId} დეტალების გამოთხოვა ვერ განხორციელდა.");
    }
  }



}