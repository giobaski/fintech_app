import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor
  }) : super(key: key);

  final Widget child;
  final GestureTapCallback onPressed;
  final Color? backgroundColor;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor?? Colors.redAccent),
          shadowColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
          minimumSize: MaterialStateProperty.all(const Size(150, 40)),
          // maximumSize: MaterialStateProperty.all(const Size(64, 36)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),






        )
    );
  }
}