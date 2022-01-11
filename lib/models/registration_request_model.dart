class RegistrationRequestModel {
  final String personalNumber;
  final String phoneNumber;
  final String password1;
  final String password2;
  final String smsCode;
  final String sesId;



  RegistrationRequestModel({
    required this.personalNumber,
    required this.phoneNumber,
    required this.password1,
    required this.password2,
    required this.smsCode,
    required this.sesId,

  });

}