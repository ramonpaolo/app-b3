import 'package:Ibovespa/src/auth/Cadastro.dart';
import 'package:Ibovespa/src/auth/ForgotPassword.dart';
import 'package:Ibovespa/src/nav.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _visiblePassword = true;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(140))),
                    ),
                    Positioned(
                        top: size.height * 0.18,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 38,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cadastro()));
                          },
                        ))
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                  height: size.height * 0.23,
                ),
                _campForm(
                    size,
                    TextInputType.text,
                    Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    false,
                    _controllerEmail),
                Divider(
                  color: Colors.transparent,
                ),
                _campForm(
                    size,
                    TextInputType.visiblePassword,
                    Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    ),
                    _visiblePassword,
                    _controllerPassword),
                TextButton(
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()),
                        )),
                GestureDetector(
                    onTap: () {
                      if (_controllerEmail.text != "" &&
                          _controllerPassword.text != "") {
                        print("Logado");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Nav()),
                            (route) => false);
                      }
                    },
                    child: Container(
                        width: size.width * 0.3,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                            child: Text(
                          "Logar",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ))))
              ],
            ),
          ),
        ));
  }

  Widget _campForm(Size size, TextInputType textType, Icon iconPrefix,
      bool _password, TextEditingController _controller) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.06,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      child: TextField(
        controller: _controller,
        obscureText: _password,
        decoration: InputDecoration(
            prefixIcon: iconPrefix,
            border: InputBorder.none,
            suffixIcon: textType == TextInputType.visiblePassword
                ? IconButton(
                    icon: _visiblePassword == true
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.remove_red_eye_sharp,
                            color: Colors.black,
                          ),
                    onPressed: () {
                      setState(() {
                        _visiblePassword = !_visiblePassword;
                      });
                    },
                  )
                : null),
        keyboardType: textType,
      ),
    );
  }
}
