import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _controllerEmail = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.25,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60))),
            ),
            Divider(
              color: Colors.transparent,
              height: size.height * 0.18,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Para podermos ajudá-lo a recuperar a sua senha, digite o seu email no campo a baixo para que possamos enviar um email de redefinir senha.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: size.width * 0.9,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: TextField(
                controller: _controllerEmail,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: size.height * 0.018),
                  hintText: "Digite seu email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_controllerEmail.text != "") {
                  print("Email com a redefinição da senha disponível");
                  Future.delayed(
                      Duration(seconds: 2), () => Navigator.pop(context));
                }
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: size.width * 0.3,
                  height: size.height * 0.05,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      "Enviar",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
