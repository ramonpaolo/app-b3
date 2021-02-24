//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//---- Widgets
import 'package:Ibovespa/src/views/user/widgets.dart';

//---- Screen
import 'package:Ibovespa/src/template/stock.dart';

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
      Map resposta;
      final file = await getDirectory();
      final datas = await jsonDecode(file.readAsStringSync());
      await datas["acoes"].length == 0 ? setState(() => error = true) : null;

      for (var x = 0; x < await datas["acoes"].length; x++) {
        http.Response response;

        response = await http.get(
            "http://dbf8f8ea650e.ngrok.io/?ticker=${datas["acoes"][x]["ticker"]}");
        resposta = await jsonDecode(response.body);

        if (resposta["data"]["valor_cota"] == "AÇÕES") {
          response = await http.get(
              "http://dbf8f8ea650e.ngrok.io/?fii=${datas["acoes"][x]["ticker"]}");
          resposta = await jsonDecode(response.body);

          if (resposta["data"]["ticker"].toString().endsWith("34")) {
            response = await http.get(
                "http://dbf8f8ea650e.ngrok.io/?bdrs=${datas["acoes"][x]["ticker"]}");
            resposta = await jsonDecode(response.body);
          } else if (resposta["data"]["valor_cota"] == "AÇÕES") {
            response = await http.get(
                "http://dbf8f8ea650e.ngrok.io/?etfs=${datas["acoes"][x]["ticker"]}");
            resposta = await jsonDecode(response.body);
          }
        }

        setState(() {
          acoes.add(resposta);
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
}
