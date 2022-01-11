import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';
import 'package:skany/controllers/register_controller.dart';
import 'package:skany/models/registration_request_model.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerController = Get.put(RegisterController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _personalNumber;
  String? _phoneNumber;
  String? _password1;
  String? _password2;
  String? _smsCode;
  // დროები ცვლადი განმეორებითი პაროლის ვალიდაციისთვის;
  var confirmPass;
  //sms მოთხოვნისთვის ღილაკისთვის წინასწარ ნომერის წამოღებისთვის
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("რეგისტრაცია"), centerTitle: true),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              _buildPersonalNumberField(),
              SizedBox(height: 10), //Todo:temp work around
              _buildPhoneNumberField(),
              SizedBox(height: 10), //Todo:temp work around
              _buildPasswordField(),
              SizedBox(height: 10), //Todo:temp work around
              _buildRepeatPasswordField(),
              SizedBox(height: 10),
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildRequestSmsBtn()),
                    SizedBox(width: 30),
                    Expanded(child: Container(height: 40,
                        child: _buildSmsCodeField())),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text("რეგისტრაცია"),
                    onPressed: (){
                      if(!_formKey.currentState!.validate()){
                        return;
                      }
                      _formKey.currentState!.save();
                      print("personal number: " + _personalNumber!);

                      registerController.register(
                          RegistrationRequestModel(
                              personalNumber: _personalNumber!,
                              phoneNumber:_phoneNumber!,
                              password1:_password1!,
                              password2:_password2!,
                              smsCode:_smsCode!,
                              sesId: registerController.sesId.value
                          )
                      );

                    },
                ),
              ),

              SizedBox(height: 200), //TODO:
              Text("By creating an account, you are agreeing to our \n Terms & Conditions and Privacy Policy!", style: TextStyle(color: Colors.grey),),

            ],
          ),
        )
      ),
    );
  }




  //MY WIDGETS:
  Widget _buildPersonalNumberField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "პირადი ნომერი ცარიელია";
        } else if (value.length != 11) {
          return "უნდა იყოს 11 ციფრი";
        }
      },
      onSaved: (String? value) {
        _personalNumber = value!;
      },
      decoration: InputDecoration(
        labelText: "პირადი ნომერი",
        hintText: "11 ციფრი",
        // icon: const Icon(Icons.art_track),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
        prefixIcon: Icon(Icons.art_track, color: Colors.teal),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _phoneNumberController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "ტელეფონის ნომერი ცარიელია";
        } else if (!value.isNumericOnly) {
          return "უნდა შეიცავდეს მხოლოდ ციფრებს";
        }
      },
      onSaved: (String? value) {
        _phoneNumber = value!;
      },
      decoration: InputDecoration(
        labelText: "ტელეფონის ნომერი",
        hintText: "XXX112233",
        // icon: const Icon(Icons.phone),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
        prefixIcon: Icon(Icons.phone, color: Colors.teal),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (String? value) {
        confirmPass =
            value; // პირველი პაროლის მნიშვ. აქ ვინახავთ განმეორებით პაროლთან შესადარებლად
        if (value!.isEmpty) {
          return " პაროლი ცარიელია";
        } else if (value.isAlphabetOnly || value.isNumericOnly) {
          return "მხოლოდ ალფანუმერული სიმბოლოები, მინიმუმ ერთი ციფრი";
        } else if (value.length < 8) {
          return "უნდა იყოს მინიმუმ 8 სიმბოლო";
        } //Todo: check - at least one capital letter
      },
      onSaved: (String? value) {
        _password1 = value!;
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "პაროლი",
        hintText: "მინიმუმ 8 ალფანუმერული სიმბოლო",

        // icon: const Icon(Icons.password),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(Icons.password, color: Colors.teal),

      ),
    );
  }

  Widget _buildRepeatPasswordField() {
    return TextFormField(
      validator: (String? value) {
        if (value!.isEmpty) {
          return "განმეორებითი პაროლი ცარიელია";
        } else if (value != confirmPass) {
          return "არ ემთხვევა ერთმანეთს";
        }
      },
      onSaved: (String? value) {
        _password2 = value!;
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "პაროლის გამეორება",
        // icon: const Icon(Icons.password),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(Icons.password, color: Colors.teal),
      ),
    );
  }

  Widget _buildRequestSmsBtn() {
    return ElevatedButton(
        onPressed: () {
          if(_phoneNumberController.text.length != 9){
            Get.snackbar("შეიყვანეთ სწორი ტელეფონის ნომერი",
              "Debug: " + _phoneNumberController.text,
            );
          }
          registerController.retrieveSmsCode(_phoneNumberController.text);
        },
        child: Text("SMS მოთხოვნა"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple[500])));
  }


  Widget _buildSmsCodeField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "კოდი ცარიელია";
        }
      },
      onSaved: (String? value) {
        _smsCode = value!;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '  SMS Code',
        labelStyle: TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.all(0),
        // filled: true,
        // fillColor: Colors.indigo[100],

      ),
    );
  }
}