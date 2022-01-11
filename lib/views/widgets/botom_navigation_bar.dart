import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBottomnavigationBar extends StatefulWidget {
  MyBottomnavigationBar({Key? key,}) : super(key: key);

  @override
  State<MyBottomnavigationBar> createState() => _MyBottomnavigationBarState();
}

class _MyBottomnavigationBarState extends State<MyBottomnavigationBar> {


  final screens = ["/home", "profile", "/profile"];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 20,
// selectedFontSize: 22,
// type: BottomNavigationBarType.fixed,
// currentIndex: 0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            // backgroundColor: Colors.blueGrey
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.grey[800],
      onTap: (index){
        // setState(() {_selectedIndex = index;});
        Get.toNamed(screens[index]);
      },
    );
  }
}
