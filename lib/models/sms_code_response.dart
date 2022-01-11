class SmsCodeResponse {
  final String message;
  final int smsCode;

  SmsCodeResponse({
    required this.message,
    required this.smsCode,
  });

  factory SmsCodeResponse.fromJson(Map<String, dynamic> json){
    return SmsCodeResponse(
        message: json['message'] as String,
        smsCode: json['sms_code'] as int
    );
  }


}