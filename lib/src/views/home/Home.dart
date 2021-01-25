import 'dart:convert';
import 'dart:io';
import 'package:Ibovespa/src/template/stock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.dataHome}) : super(key: key);
  final Map dataHome;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _campSearch = false;
  bool err = false;

  List acoes = [];

  var _snack = GlobalKey<ScaffoldState>();

  Map ticker = {
    "data": {"dy": null}
  };

  TextEditingController _controllerTicker = TextEditingController();

  Future<File> getDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + "/data.json");
  }

  Future saveData(Map dataHomes) async {
    final file = await getDirectory();
    try {
      final data = await jsonDecode(file.readAsStringSync());
      List acoes = data["acoes"];
      acoes.add({
        "ticker": dataHomes["ticker"],
        "nome": dataHomes["nome"],
        "info": dataHomes["info"],
        "logo": dataHomes["logo"]
      });
      data["acoes"] = acoes;
      print(await data);
      file.writeAsStringSync(jsonEncode(data));
    } catch (e) {
      file.writeAsStringSync(jsonEncode({
        "acoes": [
          {
            "ticker": dataHomes["ticker"],
            "nome": dataHomes["nome"],
            "info": dataHomes["info"],
            "logo": dataHomes["logo"]
          }
        ]
      }));
    }
  }

  Future getData() async {
    List a = ["taee11", "taee4", "taee3", "itub4", "itsa4", "enbr3"];
    try {
      for (var x = 0; x < a.length; x++) {
        http.Response response =
            await http.get("http://192.168.100.106:3000/?ticker=${a[x]}");
        Map resposta = await jsonDecode(response.body);
        print(resposta);
        setState(() {
          acoes.add(resposta);
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        err = true;
      });
      return;
    }
  }

  Future searchTicker() async {
    try {
      http.Response response = await http.get(
          "http://192.168.100.106:3000/?ticker=${_controllerTicker.text.toLowerCase()}");
      print(await jsonDecode(response.body));
      setState(() {
        ticker = jsonDecode(response.body);
      });
      return ticker;
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
                Divider(
                  height: size.height * 0.06,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Eae");
                          setState(() {
                            _campSearch = !_campSearch;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: size.width * 0.02),
                            width: size.width * 0.12,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(140)),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            )),
                      ),
                      AnimatedCrossFade(
                        firstChild: Container(
                          width: size.width * 0.82,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(40)),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _controllerTicker,
                            onSubmitted: (c) async {
                              if (_controllerTicker.text.length >= 5 &&
                                  _controllerTicker.text.length <= 7) {
                                await searchTicker();
                              } else if (_controllerTicker.text.length < 5) {
                                snackBar("Ticker menor que 5 caracteres");
                              } else if (_controllerTicker.text.length > 7) {
                                snackBar("Ticker maior que 7 caracteres");
                              }
                            },
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, top: 14),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      ticker["data"]["dy"] = null;
                                      _controllerTicker.clear();
                                    });
                                  },
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 24),
                                border: InputBorder.none),
                          ),
                        ),
                        secondChild: Container(
                            margin: EdgeInsets.only(
                                left: size.width * 0.3,
                                top: size.height * 0.02),
                            child: Text("Dólar: R\$5.28 Euro: R\$6.99",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ))),
                        duration: Duration(milliseconds: 700),
                        crossFadeState: _campSearch
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ],
                  ),
                ),
                ticker["data"]["dy"] == null
                    ? err == false
                        ? acoes.length >= 1
                            ? RefreshIndicator(
                                onRefresh: getData,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Container(
                                        width: size.width,
                                        height: size.height,
                                        child: ListView.builder(
                                          itemCount: acoes.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                                width: size.width * 0.3,
                                                height: size.height * 0.12,
                                                child: GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Stock(
                                                                dataStock:
                                                                    acoes[
                                                                        index],
                                                              ))),
                                                  child: Card(
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          3),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          3)),
                                                          child: Container(
                                                              width:
                                                                  size.width *
                                                                      0.3,
                                                              height:
                                                                  size.height *
                                                                      0.12,
                                                              child:
                                                                  Image.network(
                                                                acoes[index]
                                                                        ["data"]
                                                                    ["logo"],
                                                                fit: BoxFit
                                                                    .cover,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                              )),
                                                        ),
                                                        Expanded(
                                                            child: ListTile(
                                                                title: Text(acoes[index]["data"]["nome"]
                                                                            .toString()
                                                                            .characters
                                                                            .length <=
                                                                        15
                                                                    ? "${acoes[index]["data"]["nome"]}"
                                                                    : "${acoes[index]["data"]["nome"].toString().characters.getRange(0, 14)}..."),
                                                                subtitle: Text(acoes[
                                                                            index]
                                                                        ["data"]
                                                                    ["ticker"]),
                                                                trailing:
                                                                    Container(
                                                                        width: size.width *
                                                                            0.4,
                                                                        height: size.height *
                                                                            0.06,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            acoes[index]["data"]["oscilacao_cota"].toString().characters.first == "-"
                                                                                ? Icon(
                                                                                    Icons.arrow_downward,
                                                                                    color: Colors.red,
                                                                                  )
                                                                                : Icon(
                                                                                    Icons.arrow_upward,
                                                                                    color: Colors.blue,
                                                                                  ),
                                                                            Text("R\$${acoes[index]["data"]["valor_cota"]}")
                                                                          ],
                                                                        ))))
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        )),
                                  ],
                                )))
                            : Container(
                                margin: EdgeInsets.only(top: size.height * 0.5),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ))
                        : Container(
                            margin: EdgeInsets.only(top: size.height * 0.5),
                            child: Center(
                                child: Center(
                              child: Text(
                                "Error",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            )))
                    : Column(
                        children: [
                          Divider(
                            height: size.height * 0.1,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                width: size.width * 0.5,
                                height: size.height * 0.2,
                                child: Image.network(
                                  ticker["data"]["logo"],
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                )),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          text(ticker["data"]["nome"]
                                      .toString()
                                      .characters
                                      .length <=
                                  15
                              ? "${ticker["data"]["nome"]}"
                              : "${ticker["data"]["nome"].toString().characters.getRange(0, 15)}"),
                          text("${ticker["data"]["ticker"]}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ticker["data"]["oscilacao_cota"]
                                          .toString()
                                          .characters
                                          .first ==
                                      "-"
                                  ? Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                    ),
                              text("R\$${ticker["data"]["valor_cota"]}"),
                            ],
                          ),
                          text(
                              "Oscilação da cota no dia: ${ticker["data"]["oscilacao_cota"]}"),
                          text("Divindend Yield: ${ticker["data"]["dy"]}% a.a"),
                          text(
                              "Ultimo pagamento: ${ticker["data"]["ultimo_pagamento"]}"),
                          Divider(
                            color: Colors.transparent,
                          ),
                          text("${ticker["data"]["info"]}"),
                        ],
                      ),
              ]),
            )));
  }

  Widget text(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
