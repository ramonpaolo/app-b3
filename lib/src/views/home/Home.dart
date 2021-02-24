//---- Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//---- Widgets
import 'package:Ibovespa/src/views/home/widgets.dart';

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

  Future getData() async {
    acoes.clear();
    Map resposta;
    http.Response response;
    List stocks = [
      "taee4",
      "taee3",
      "itub4",
      "enbr3",
      "sapr4",
      "bidi4",
      "egie3",
      "mdia3",
      "bcff11",
      "hfof11",
      "abcp11",
      "bpff11",
      "ivvb11",
      "nvdc34",
    ];
    try {
      for (var x = 0; x < stocks.length; x++) {
        response =
            await http.get("http://dbf8f8ea650e.ngrok.io/?ticker=${stocks[x]}");
        resposta = await jsonDecode(response.body);

        if (resposta["data"]["valor_cota"] == "AÇÕES") {
          response =
              await http.get("http://dbf8f8ea650e.ngrok.io/?fii=${stocks[x]}");
          resposta = await jsonDecode(response.body);

          if (resposta["data"]["ticker"].toString().endsWith("34")) {
            response = await http
                .get("http://dbf8f8ea650e.ngrok.io/?bdrs=${stocks[x]}");
            resposta = await jsonDecode(response.body);
          } else if (resposta["data"]["valor_cota"] == "AÇÕES") {
            response = await http
                .get("http://dbf8f8ea650e.ngrok.io/?etfs=${stocks[x]}");
            resposta = await jsonDecode(response.body);
          }
        }
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
    Map resposta = {};
    try {
      http.Response response;
      response = await http.get(
          "http://dbf8f8ea650e.ngrok.io/?ticker=${_controllerTicker.text.toLowerCase()}");
      resposta = await jsonDecode(response.body);
      if (resposta["data"]["valor_cota"] == "AÇÕES") {
        response = await http.get(
            "http://dbf8f8ea650e.ngrok.io/?fii=${_controllerTicker.text.toLowerCase()}");
        resposta = await jsonDecode(response.body);

        if (resposta["data"]["ticker"].toString().endsWith("34")) {
          response = await http.get(
              "http://dbf8f8ea650e.ngrok.io/?bdrs=${_controllerTicker.text.toLowerCase()}");
          resposta = await jsonDecode(response.body);
        } else if (resposta["data"]["valor_cota"] == "AÇÕES") {
          response = await http.get(
              "http://dbf8f8ea650e.ngrok.io/?etfs=${_controllerTicker.text.toLowerCase()}");
          resposta = await jsonDecode(response.body);
          resposta["data"]["dy"] = "0.01";
        }
      }
      setState(() {
        ticker = resposta;
      });
      return ticker;
    } catch (e) {
      print(e);
      return;
    }
  }

  snackBar(String text) {
    _snack.currentState.removeCurrentSnackBar();
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
                          width: size.width * 0.81,
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
                            ? stocks(size, getData, acoes)
                            : Container(
                                margin: EdgeInsets.only(top: size.height * 0.3),
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
                    : searchedStock(size, ticker)
              ]),
            )));
  }
}
