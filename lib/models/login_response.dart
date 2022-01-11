class LoginResponse {

  final String accessToken;
  final String sesId;
  final int smsCode;


  LoginResponse({
    required this.accessToken,
    required this.sesId,
    required this.smsCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
        accessToken: json['access_token'] as String,
        sesId: json['ses_id'] as String,
        smsCode: json['sms_code'] as int
    );
  }


}