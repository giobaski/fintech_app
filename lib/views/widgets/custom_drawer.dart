import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final AuthController authController = Get.find();




  @override
  Widget build(BuildContext context) {
    var nameInitials = authController.appUser.value.name!.substring(0,1) + authController.appUser.value.sname!.substring(0,1) ;
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          // Text(username),
          UserAccountsDrawerHeader(
            accountName: Text(authController.appUser.value.name?? ""),
            accountEmail: Text(authController.appUser.value.pn?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(nameInitials, style: TextStyle(fontSize: 30.0),), //TODO: add image
            ),
            decoration:BoxDecoration(
              color: Colors.indigo[700],
            ),
          ),

          ListTile(
            leading: Icon(Icons.home),
            title: const Text('მთავარი'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('პროფილი'),
            onTap: () {
              Get.toNamed("/profile");
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: const Text('ჩემი განვადებები'),
            onTap: () {
              // Update the state of the app.
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: const Text('შეტყობინებები'),
            onTap: () {
              // Update the state of the app.
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('პარამეტრები'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: const Text('დახმარება'),
            onTap: () {
              // Update the state of the app.
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('გასვლა'),
            onTap: () {
              Get.defaultDialog(
                title: "Logout",
                content: Text("ნამდვილად გსურთ გასვლა?"),
                confirm: TextButton(
                    onPressed: (){
                      authController.logout();
                    },
                    child: Text("დიახ")
                ),
                cancel: TextButton(onPressed: (){Get.back();}, child: Text("არა")),

              );
            },
          ),
        ],
      ),
    );
  }
}