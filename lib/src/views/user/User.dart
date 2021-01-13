import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  List acoes = [];

  var _snack = GlobalKey<ScaffoldState>();

  Future getPrice(String ticker) async {
    try {
      http.Response response =
          await http.get("http://192.168.100.102:3000/?ticker=$ticker");
      print(await jsonDecode(response.body));
      return await jsonDecode(response.body);
    } catch (e) {
      print(e);
      return;
    }
  }

  snackBar(String text) {
    _snack.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
      ),
    ));
  }

  Future<File> getDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + "/data.json");
  }

  Future getData() async {
    final file = await getDirectory();

    final datas = jsonDecode(file.readAsStringSync());

    for (var x = 0; x < datas["acoes"].length; x++) {
      print(datas["acoes"][x]["ticker"]);
      setState(() {
        acoes.add(datas["acoes"][x]);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
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
                              return GestureDetector(
                                  onLongPress: () {
                                    bottomSheet(size, snapshot, index);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(right: 8),
                                      width: size.width * 0.4,
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(9),
                                                    topRight:
                                                        Radius.circular(9)),
                                                child: Container(
                                                  child: Image.network(
                                                    acoes[index]["logo"],
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.cover,
                                                    width: size.width * 0.4,
                                                    height: size.height * 0.13,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: size.width * 0.3,
                                                      top: 4),
                                                  width: size.width * 0.095,
                                                  height: size.height * 0.045,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80)),
                                                  child: IconButton(
                                                    tooltip: "Excluir",
                                                    icon: Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      await excludeStock(
                                                          acoes[index]
                                                              ["ticker"]);
                                                    },
                                                  ))
                                            ],
                                          ),
                                          ListTile(
                                            title: Text(acoes[index]["nome"]
                                                        .toString()
                                                        .characters
                                                        .length >=
                                                    16
                                                ? acoes[index]["nome"]
                                                        .toString()
                                                        .characters
                                                        .getRange(0, 14)
                                                        .toString() +
                                                    "..."
                                                : acoes[index]["nome"]),
                                            subtitle:
                                                Text(acoes[index]["ticker"]),
                                            trailing: Text(
                                              "R\$" +
                                                  snapshot.data["data"]
                                                      ["valor_cota"],
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                          )
                                        ],
                                      )));
                            } else {
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
                                            margin: EdgeInsets.only(
                                              bottom: size.height * 0.15,
                                            ),
                                            child: LinearProgressIndicator(
                                              backgroundColor: Colors.black,
                                            )),
                                      ),
                                      CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                      )
                                    ],
                                  ));
                            }
                          },
                          future: getPrice(acoes[index]["ticker"]),
                        );
                      },
                      itemCount: acoes.length,
                    ))
              ],
            ))));
  }

  Future excludeStock(String ticker) async {
    for (var x = 0; x < acoes.length; x++) {
      if (acoes[x]["ticker"] == ticker) {
        setState(() {
          acoes.removeAt(x);
        });
        break;
      }
    }
    final file = await getDirectory();
    file.writeAsStringSync(jsonEncode({"acoes": acoes}));
  }

  bottomSheet(Size size, AsyncSnapshot snapshot, int index) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          width: size.width,
          height: size.height * 0.4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  width: size.width * 0.1,
                  height: 30,
                  child: IconButton(
                    tooltip: "Sair da janela",
                    icon: Icon(
                      Icons.clear,
                      size: 28,
                      color: Colors.red,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    child: Image.network(
                      acoes[index]["logo"],
                      fit: BoxFit.cover,
                      width: size.width * 0.5,
                      height: size.height * 0.15,
                    ),
                  ),
                ),
                Text(
                  acoes[index]["nome"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  acoes[index]["ticker"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Dividend Yield: " + snapshot.data["data"]["dy"] + "% a.a",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Preço Max no dia: R\$" +
                          snapshot.data["data"]["preco_max_cota_dia"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("|",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "Preço Min no dia: R\$" +
                          snapshot.data["data"]["preco_min_cota_dia"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "Valor da Cota: " + snapshot.data["data"]["valor_cota"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Oscilação da cota no dia: " +
                      snapshot.data["data"]["oscilacao_cota_dia"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Ultimo pagamento de DY: " +
                      snapshot.data["data"]["ultimo_pagamento"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  "Sobre a Empresa: " + acoes[index]["info"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
