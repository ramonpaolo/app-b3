//---- Packages
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';

//---- Screens
import 'package:Ibovespa/src/auth/login.page.dart';

void main() {
  runApp(MaterialApp(
    title: "Ibovespa",
    home: SplashScreen(),
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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.black,
      child: Center(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          "assets/logo.png",
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
          width: size.width * 0.6,
          height: size.height * 0.3,
        ),
      )),
    );
  }
}
