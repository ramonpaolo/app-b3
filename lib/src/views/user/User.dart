import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  List acoes = [
    {"nome": "itub4"},
    {"nome": "itsa4"},
    {"nome": "taee11"},
  ];

  var _snack = GlobalKey<ScaffoldState>();

  Future getData(String ticker) async {
    try {
      http.Response response =
          await http.get("http://192.168.100.102:3000/?ticker=$ticker");
      print(await jsonDecode(response.body));
      var data = await jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
    }
    return acoes;
  }

  snackBar(String text) {
    _snack.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[900],
        key: _snack,
        body: Container(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    width: size.width,
                    height: size.height * 0.35,
                    child: Stack(children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40))),
                      ),
                      Positioned(
                          top: size.height * 0.16,
                          left: size.width * 0.34,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(240),
                              child: Container(
                                width: size.width * 0.36,
                                height: size.height * 0.18,
                                child: Image.network(
                                  "https://cdn.pixabay.com/photo/2020/12/21/19/05/window-5850628__340.png",
                                  fit: BoxFit.cover,
                                ),
                              )))
                    ])),
                Container(
                    height: size.height * 0.23,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.only(right: 8),
                                  width: size.width * 0.4,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(9),
                                            topRight: Radius.circular(9)),
                                        child: Container(
                                          child: Image.network(
                                            snapshot.data["data"]["logo"],
                                            fit: BoxFit.cover,
                                            width: size.width * 0.4,
                                            height: size.height * 0.13,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title:
                                            Text(snapshot.data["data"]["nome"]),
                                        subtitle: Text(
                                            snapshot.data["data"]["ticker"]),
                                      )
                                    ],
                                  ));
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                          future: getData(acoes[index]["nome"]),
                        );
                      },
                      itemCount: acoes.length,
                    ))
              ],
            ))));
  }
}
