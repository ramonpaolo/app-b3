//---- Packages
import 'package:Ibovespa/src/nav.dart';
import 'package:Ibovespa/src/views/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';

//---- Screens
import 'package:Ibovespa/src/auth/Login.dart';

void main() {
  runApp(MaterialApp(
    title: "Ibovespa",
    home: Nav(), // SplashScreen(),
    theme: ThemeData(fontFamily: "Roboto"),
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
