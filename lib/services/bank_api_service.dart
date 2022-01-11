import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skany/models/bank.dart';

class BankApiService {
  static var client = http.Client();
  static final BASE_URL = "http://skanysolutions.com/api";

  static Future<List<Bank>> fetchAvailableBanks(String token) async {
    var response = await client
        .get(Uri.parse("$BASE_URL/get_banks"), headers: <String, String>{
      // "Content-type": "application/json",
      "Authorization": "Bearer $token",
      // "accept": "application/json"
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var list = jsonResponse['message'] as List;
      var banks = list.map((value) => Bank.fromJson(value)).toList();
      return banks;
    } else {
      throw Exception("ბანკების გამოთხოვა სერვერიდან ვერ განხორციელდა!");
    }
  }
}
