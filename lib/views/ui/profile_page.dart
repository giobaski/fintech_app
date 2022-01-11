import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';
import 'package:skany/models/app_user.dart';
import 'package:skany/views/widgets/botom_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final AuthController authController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("პროფილი"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit))
        ],
      ),
      bottomNavigationBar: MyBottomnavigationBar(),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [

          // Text(authController.appUser.value.name?? "Debug: no name, we have to get details from server"),
          // Text(Get.find<AuthController>().phoneNumber.value), //Todo Delete
          CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 40,
            child: Image.asset('assets/images/profile.jpeg',
             width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text("პერსონალური ინფორმაცია", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          Divider(thickness: 2),

          ListTile(
            leading: Icon(Icons.person),
            title: Text("მომხმარებელი:", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("${authController.appUser.value.name?? "სახელი "} ${authController.appUser.value.sname?? "გვარი"}"),
              dense: true,
            trailing: (authController.appUser.value.isVerified == 1) //Todo: set in back to 1
                      ?  Icon(Icons.verified, color: Colors.teal)
                      :  Icon(Icons.not_interested, color: Colors.red)
          ),
          ListTile(
            leading: Icon(Icons.art_track),
            title: Text("პირადი ნომერი", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(authController.appUser.value.pn?? "000000000000"),
            dense: true,
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("ტელეფონი", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(authController.appUser.value.phone?? "xxx-xx-xx-xx"),
            dense: true,
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text("ვერიფიკატორი", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            subtitle: Text(authController.appUser.value.verificator?? ""),
            dense: true,
          ),


          Container(
            // height: 100,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                // Text(DateTime.parse(authController.appUser.value.createdAt.toString()).toIso8601String()),

                Text("პროფილის შექმნის თარიღი: 2021-10-28", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                // CircleAvatar(
                //   backgroundColor: Colors.teal,
                //   radius: 30,
                //   child: Text("GT", style: TextStyle(fontSize: 30.0),), //TODO: add image
                // ),
                // Text("პერსონალური მონაცემები"),
              ],
            ),
          ),


          // თუ ვერიფიცირებული არაა (isVerified=0), მაშინ გამოაჩინე ვერიფიკაციის პროცედურა
          SizedBox(height: 20),
          if (authController.appUser.value.isVerified == 1) _buildStartVerificationCard()

        ],
      ),
    );
  }



  Widget _buildStartVerificationCard(){
    return Card(
      elevation: 10,
      child: Column(
        children: [
      Text("DEBUG: აირჩიეთ ვერიფიკაციის მეთოდი:",

      style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          //1. Button for the bank verification
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title:
                  "აირჩიეთ სასურველი ბანკი, სადაც გსურთ ვერიფიკაციის პროცესის გავლა",
                  titleStyle: TextStyle(
                      color: Colors.indigo,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600),
                  content: Text("ბანკების ჩამონათვალი......"),
                  confirm: ElevatedButton(
                      onPressed: () {}, child: Text("ვერიფიკაცია")));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ბანკი"),
                Icon(Icons.arrow_right)
              ],
            ),
          ),

          //2. Button for the video verification
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title:
                  "აირჩიეთ სასურველი ბანკი, სადაც გსურთ ვერიფიკაციის პროცესის გავლა",
                  titleStyle: TextStyle(
                      color: Colors.indigo,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600),
                  content: Text("ბანკების ჩამონათვალი......"),
                  confirm: ElevatedButton(
                      onPressed: () {}, child: Text("ვერიფიკაცია")));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ვიდეო"),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ],
      ),
    );

  }
}
