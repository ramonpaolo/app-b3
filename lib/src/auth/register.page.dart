//---- Packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//---- Screens
import 'package:Ibovespa/src/auth/login.page.dart';
import 'package:Ibovespa/src/nav.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _visiblePassword = true;

  TextEditingController _controllerEmail = TextEditingController(text: "");
  TextEditingController _controllerPassword = TextEditingController(text: "");
  TextEditingController _controllerName = TextEditingController(text: "");

  File file;

  Future getImage() async {
    try {
      final image = await ImagePicker.platform
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      setState(() {
        file = File(image.path);
      });
    } catch (e) {
      print(e);
    }
  }

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
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(140))),
                    ),
                    Positioned(
                        top: size.height * 0.18,
                        left: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 38,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                        ))
                  ],
                ),
                if (file != null)
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.02),
                    width: size.width * 0.45,
                    height: size.height * 0.23,
                    child: CircleAvatar(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(400),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            height: size.height,
                            width: size.width,
                          )),
                    ),
                  )
                else
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.02),
                    width: size.width * 0.45,
                    height: size.height * 0.23,
                    child: IconButton(
                        tooltip: "Adicionar Imagem de perfil",
                        icon: Icon(
                          Icons.camera,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () async => await getImage()),
                  ),
                _campForm(
                    size,
                    TextInputType.name,
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    false,
                    _controllerName,
                    "Digite seu nome completo"),
                _campForm(
                    size,
                    TextInputType.text,
                    Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    false,
                    _controllerEmail,
                    "Digite seu email"),
                _campForm(
                    size,
                    TextInputType.visiblePassword,
                    Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    ),
                    _visiblePassword,
                    _controllerPassword,
                    "Digite uma senha"),
                GestureDetector(
                  onTap: () {
                    if (_controllerEmail.text != "" &&
                        _controllerPassword.text != "" &&
                        _controllerName.text != "") {
                      print("Cadastrado");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Nav()),
                          (route) => false);
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.012),
                      width: size.width * 0.3,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: Text(
                        "Cadastrar",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))),
                )
              ],
            ),
          ),
        ));
  }

  Widget _campForm(Size size, TextInputType textType, Icon iconPrefix,
      bool _password, TextEditingController _controller, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.012),
      width: size.width * 0.9,
      height: size.height * 0.06,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      child: TextField(
        controller: _controller,
        obscureText: _password,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: size.height * 0.018),
            hintText: hintText,
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
