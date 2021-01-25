import 'dart:convert';
import 'dart:io';

import 'package:Ibovespa/src/template/stock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool error = false;

  List acoes = [];

  var _snack = GlobalKey<ScaffoldState>();

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
    try {
      final file = await getDirectory();
      final datas = await jsonDecode(file.readAsStringSync());
      await datas["acoes"].length == 0 ? setState(() => error = true) : null;

      for (var x = 0; x < await datas["acoes"].length; x++) {
        print(await datas["acoes"][x]["ticker"]);

        http.Response response = await http.get(
            "http://192.168.100.106:3000/?ticker=${datas["acoes"][x]["ticker"]}");
        Map resposta = jsonDecode(response.body);
        setState(() {
          acoes.add({
            "data": {
              "ticker": datas["acoes"][x]["ticker"],
              "nome": datas["acoes"][x]["nome"],
              "logo": datas["acoes"][x]["logo"],
              "info": datas["acoes"][x]["info"],
              "oscilacao_cota": resposta["data"]["oscilacao_cota"],
              "preco_max_cota": resposta["data"]["preco_max_cota"],
              "preco_min_cota": resposta["data"]["preco_min_cota"],
              "valor_cota": resposta["data"]["valor_cota"],
              "ultimo_pagamento": resposta["data"]["ultimo_pagamento"],
              "dy": resposta["data"]["dy"]
            }
          });
        });
      }

      return acoes;
    } catch (e) {
      setState(() => error = true);
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
                child: Column(children: [
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
              error == false
                  ? acoes.length >= 1
                      ? Container(
                          height: size.height * 0.23,
                          width: size.width,
                          child: ListView.builder(
                              itemCount: acoes.length,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Stock(
                                                dataStock: acoes[index]))),
                                    onLongPress: () {
                                      bottomSheet(
                                          size, acoes[index]["data"], context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.only(right: 8),
                                        width: size.width * 0.42,
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(9),
                                                          topRight:
                                                              Radius.circular(
                                                                  9)),
                                                  child: Container(
                                                    child: Image.network(
                                                      acoes[index]["data"]
                                                          ["logo"],
                                                      filterQuality:
                                                          FilterQuality.high,
                                                      fit: BoxFit.cover,
                                                      width: size.width * 0.42,
                                                      height:
                                                          size.height * 0.13,
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
                                                            BorderRadius
                                                                .circular(80)),
                                                    child: IconButton(
                                                      tooltip: "Excluir",
                                                      icon: Icon(
                                                        Icons.clear,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () async {
                                                        await excludeStock(
                                                            acoes[index]["data"]
                                                                ["ticker"]);
                                                      },
                                                    ))
                                              ],
                                            ),
                                            ListTile(
                                              title: Text(acoes[index]["data"]
                                                              ["nome"]
                                                          .toString()
                                                          .characters
                                                          .length >=
                                                      16
                                                  ? acoes[index]["data"]["nome"]
                                                          .toString()
                                                          .characters
                                                          .getRange(0, 14)
                                                          .toString() +
                                                      "..."
                                                  : acoes[index]["data"]
                                                      ["nome"]),
                                              subtitle: Text(acoes[index]
                                                  ["data"]["ticker"]),
                                              trailing: Text(
                                                "R\$" +
                                                    acoes[index]["data"]
                                                        ["valor_cota"],
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            )
                                          ],
                                        )));
                              }))
                      : Container(
                          margin: EdgeInsets.only(top: size.height * 0.2),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ))
                  : Container(
                      margin: EdgeInsets.only(top: size.height * 0.2),
                      child: TextButton(
                        child: Text("Crie uma carteira"),
                        onPressed: () {
                          print("Bora Criar então");
                        },
                      ),
                    )
            ]))));
  }

  Future excludeStock(String ticker) async {
    for (var x = 0; x < acoes.length; x++) {
      if (acoes[x]["data"]["ticker"] == ticker) {
        setState(() {
          acoes.removeAt(x);
        });
        break;
      }
    }
    final file = await getDirectory();
    file.writeAsStringSync(jsonEncode({"acoes": acoes}));
  }

  bottomSheet(Size size, Map acoes, BuildContext context) {
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
                      acoes["logo"],
                      fit: BoxFit.cover,
                      width: size.width * 0.5,
                      height: size.height * 0.15,
                    ),
                  ),
                ),
                Text(
                  acoes["nome"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  acoes["ticker"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Dividend Yield: ${acoes["dy"]} % a.a",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Preço Max no dia: R\$${acoes["preco_max_cota"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("|",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "Preço Min no dia: R\$${acoes["preco_min_cota"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "Valor da Cota: ${acoes["valor_cota"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Oscilação da cota no dia: ${acoes["oscilacao_cota"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Ultimo pagamento de DY: ${acoes["ultimo_pagamento"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  "Sobre a Empresa: ${acoes["info"]}",
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
