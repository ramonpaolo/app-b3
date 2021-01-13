//---- Packages
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';

//---- Screens
import 'package:Ibovespa/src/auth/Login.dart';
import 'package:Ibovespa/src/nav.dart';

void main() {
  runApp(MaterialApp(
    title: "Ibovespa",
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      gotoWidget: Login(),
      splashscreenWidget: Splash(),
      timerInSeconds: 2,
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
