import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skany/models/app_user.dart';
import 'package:skany/models/login_response.dart';
import 'package:skany/models/registration_request_model.dart';
import 'package:skany/models/sms_code_response.dart';

class AuthApiService {
  static var client = http.Client();
  static final BASE_URL = "http://skanysolutions.com/api";

  //returns access_token and ses_id, which we will use in SmsVerificationPage
  static Future<LoginResponse> loginWithPhoneAndPassword(
      String phone, String password) async {
    var response = await client.post(Uri.parse("$BASE_URL/login"),
        body: jsonEncode({
          "phone": phone,
          "password": password
        }),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json"
        });

    print("##### Response body: " + response.body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return LoginResponse.fromJson(jsonResponse);
    } //todo: else if (status 401)
    else {
      throw Exception("Failed to login");
    }
  }

  static Future<User> verifyPhone(int smsCode, String ses_id, String token,) async {
    var response = await client.post(Uri.parse("$BASE_URL/phone_verify"),
        body: jsonEncode({
          "verify_code": smsCode,
          "ses_id": ses_id
        }),
        headers: <String, String>{
          "Content-type": "application/json",
          // "Accept": "application/json",
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse['user']);
    } else if (response.statusCode == 401){
      throw  Exception(jsonDecode(response.body)['message']); //Todo: use proper error handling
    }
    else {
      throw Exception("sms ვერიფიკაცია წარუმატებელია");
    }
  }

  // კლიენტის რეგისტრაციისას
  static Future<SmsCodeResponse> retrieveSmsCode(String sesId, String phone) async {
    var response = await client.post(
        Uri.parse("$BASE_URL/reg_send_phone_verify_code"),
        body: jsonEncode({
          "phone": phone,
          "ses_id": sesId
        }),
        headers: <String, String>{
          "Content-type": "application/json",
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return SmsCodeResponse.fromJson(jsonResponse);
    }
    else {
      throw Exception("sms კოდი ვერ გაიგზავნა Debug: reg_send_phone_verify_code()");
    }
  }



  //   // კლიენტის ავტორიზაციისას
  static Future<SmsCodeResponse> resendSmsCode(String sesId, String token) async {
      var response = await client.post(
          Uri.parse("$BASE_URL/sms_resend"),
          body: jsonEncode({
            // "phone": phone,
            "ses_id": sesId
          }),
          headers: <String, String>{
            "Content-type": "application/json",
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return SmsCodeResponse.fromJson(jsonResponse);
      }
      else {
        throw Exception("sms კოდი ვერ გაიგზავნა Debug: reg_send_phone_verify_code()");
      }
    }

  static Future<User> getUserProfile(String token) async {
    var response = await client.get(Uri.parse("$BASE_URL/get_user_profile"),
        headers: <String, String>{
          "Content-type": "application/json",
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse['message']);
    } else {
      throw Exception("იუზერის პროფილის წამოღება წარუმატებლად დასრულდა");
    }

  }



  // Registration APIs:

  static Future<String> getSession() async {
    var response = await client.post(
        Uri.parse("$BASE_URL/get_session"),
        body: jsonEncode({
          "route_type": "register_user"
        }),
        headers: <String, String>{
          "Content-type": "application/json",
        });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['ses_id'];
    }
    else {
      throw Exception("სერვერის შეცდომა - (debug:getSession())");
    }
  }


  static Future<String> register(RegistrationRequestModel registrationRequest)  async {
    var response = await client.post(
        Uri.parse("$BASE_URL/register"),
        body: jsonEncode({
          "ses_id": registrationRequest.sesId,
          "pn": registrationRequest.personalNumber,
          "phone": registrationRequest.phoneNumber,
          "password": registrationRequest.password1,
          "verify_code": registrationRequest.smsCode
        }),
        headers: <String, String>{
          "Content-type": "application/json",
        });

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['message'];
    }
    else {
      throw Exception("სერვერის შეცდომა - (debug:register())");
    }
  }



}


