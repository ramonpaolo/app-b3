//---- Packages
import 'dart:convert';
import 'package:Ibovespa/src/template/stock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//---- Widgets
import 'package:Ibovespa/src/views/home/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _campSearch = false, err = false;

  double dolar = 0.0, euro = 0.0;

  List acoes = [];

  Map ticker = {
    "data": {"dy": null}
  };

  TextEditingController _controllerTicker = TextEditingController();

  Future getMoney() async {
    try {
      String url = "https://api.hgbrasil.com/finance/?key=f805f342";
      http.Response response = await http.get(url);
      Map value = await jsonDecode(response.body);
      setState(() {
        //dolar = value["results"]["currencies"]["USD"]["buy"];
        //euro = value["results"]["currencies"]["EUR"]["buy"];
        dolar = 2.0;
        euro = 3.0;
      });
    } catch (e) {
      print(e);
    }
  }

  Future getData() async {
    await getMoney();
    //List stocks = ["taee4", "sapr4", "egie3", "bcff11", "ivvb11", "nvdc34"];
    List stocks = ["taee4"];
    acoes.clear();
    Map resposta;
    http.Response response;
    try {
      for (var x = 0; x < stocks.length; x++) {
        response = await http
            .get("https://dbf8f8ea650e.ngrok.io/?ticker=${stocks[x]}");
        resposta = await jsonDecode(response.body);
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
          "https://dbf8f8ea650e.ngrok.io/?ticker=${_controllerTicker.text.toLowerCase()}");
      resposta = await jsonDecode(response.body);
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
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
  void dispose() {
    // TODO: implement dispose
    _controllerTicker.dispose();
    ScaffoldMessenger.of(context).dispose();
    acoes.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[900],
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
                            margin: EdgeInsets.only(right: size.width * 0.13),
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
                          width: size.width * 0.7,
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
                                left: size.width * 0.23,
                                top: size.height * 0.02),
                            child: Text(
                                "Dólar: R\$${dolar.toString().characters.getRange(0, 4)} Euro: R\$${euro.toString().characters.getRange(0, 4)}",
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
                    : searchedStock(size, ticker["data"], context)
              ]),
            )));
  }
}
