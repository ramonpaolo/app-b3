import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _campSearch = false;

  Map ticker = {
    "data": {"dy": null}
  };

  TextEditingController _controllerTicker = TextEditingController();

  var _snack = GlobalKey<ScaffoldState>();

  Future getData() async {
    try {
      http.Response response =
          await http.get("http://192.168.100.102:3000/?ticker=itsa4");
      print(await jsonDecode(response.body));
      return await jsonDecode(response.body);
    } catch (e) {
      print(e);
      return;
    }
  }

  Future searchTicker() async {
    try {
      http.Response response = await http.get(
          "http://192.168.100.102:3000/?ticker=${_controllerTicker.text.toLowerCase()}");
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[900],
        key: _snack,
        body: Container(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: size.height * 0.06,
                    left: size.width * 0.02,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(140)),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _campSearch = !_campSearch;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.06,
                    left: size.width * 0.16,
                    child: AnimatedCrossFade(
                      firstChild: Container(
                        width: size.width * 0.83,
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 24),
                              border: InputBorder.none),
                        ),
                      ),
                      secondChild: Container(
                          margin: EdgeInsets.only(
                              left: size.width * 0.3, top: size.height * 0.02),
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
                  ),
                  ticker["data"]["dy"] == null
                      ? RefreshIndicator(
                          onRefresh: getData,
                          child: FutureBuilder(
                            future: getData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                    child: Column(
                                  children: [
                                    Divider(
                                      height: size.height * 0.16,
                                    ),
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Container(
                                            width: size.width * 0.8,
                                            height: size.height * 0.4,
                                            child: Image.network(
                                              snapshot.data["data"]["logo"],
                                              filterQuality: FilterQuality.high,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.65,
                                              top: 10,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_box_outlined,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                snackBar("Adicionado");
                                              },
                                            )),
                                      ],
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional(0, 1),
                                      children: [
                                        Positioned(
                                          top: size.height * 0.001,
                                          child: _contructText(
                                              "${snapshot.data["data"]["nome"]}",
                                              size),
                                        ),
                                        Positioned(
                                          top: size.height * 0.022,
                                          child: _contructText(
                                              "${snapshot.data["data"]["ticker"]}",
                                              size),
                                        ),
                                        Positioned(
                                          top: size.height * 0.044,
                                          child: _contructText(
                                              "Valor cota: R\$${double.parse(snapshot.data["data"]["valor_cota"].toString().replaceFirst(",", ".")).toStringAsFixed(2)}",
                                              size),
                                        ),
                                        Positioned(
                                            top: size.height * 0.066,
                                            child: _contructText(
                                                "DY 12 meses: ${snapshot.data["data"]["dy"]}%.a.a",
                                                size)),
                                        Positioned(
                                          top: size.height * 0.088,
                                          child: _contructText(
                                              "Data do pagamento: ${snapshot.data["data"]["ultimo_pagamento"]}",
                                              size),
                                        ),
                                        Positioned(
                                          top: size.height * 0.11,
                                          child: _contructText(
                                              "Preço Min no dia: R\$${snapshot.data["data"]["preco_min_cota_dia"]}",
                                              size),
                                        ),
                                        Positioned(
                                          top: size.height * 0.132,
                                          child: _contructText(
                                              "Preço Max no dia: R\$${snapshot.data["data"]["preco_max_cota_dia"]}",
                                              size),
                                        ),
                                        Positioned(
                                          top: size.height * 0.155,
                                          child: _contructText(
                                              "Oscilação: ${snapshot.data["data"]["oscilacao_cota_dia"]}",
                                              size),
                                        ),
                                        Container(
                                            width: size.width,
                                            height: size.height * 0.368,
                                            child: DraggableScrollableSheet(
                                              minChildSize: 0.08,
                                              initialChildSize: 0.08,
                                              builder:
                                                  (context, scrollController) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      bottom: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  child: SingleChildScrollView(
                                                    controller:
                                                        scrollController,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              top: size.height *
                                                                  0.008,
                                                              bottom:
                                                                  size.height *
                                                                      0.008),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[900],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                          ),
                                                          width:
                                                              size.width * 0.1,
                                                          height: size.height *
                                                              0.012,
                                                        ),
                                                        Text(
                                                          "Sobre a Empresa",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                            "${snapshot.data["data"]["info"]}"),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ))
                                      ],
                                    ),
                                  ],
                                ));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    margin:
                                        EdgeInsets.only(top: size.height * 0.5),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    ));
                              } else {
                                return Container(
                                    margin:
                                        EdgeInsets.only(top: size.height * 0.5),
                                    child: Center(
                                        child: Center(
                                      child: Text(
                                        "Error",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                    )));
                              }
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                          children: [
                            Divider(
                              height: size.height * 0.16,
                            ),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    width: size.width * 0.8,
                                    height: size.height * 0.4,
                                    child: Image.network(
                                      ticker["data"]["logo"],
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                      left: size.width * 0.65,
                                      top: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_box_outlined,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        snackBar("Adicionado");
                                      },
                                    )),
                              ],
                            ),
                            Stack(
                              alignment: AlignmentDirectional(0, 1),
                              children: [
                                Positioned(
                                  top: size.height * 0.001,
                                  child: _contructText(
                                      "${ticker["data"]["nome"]}", size),
                                ),
                                Positioned(
                                  top: size.height * 0.022,
                                  child: _contructText(
                                      "${ticker["data"]["ticker"]}", size),
                                ),
                                Positioned(
                                  top: size.height * 0.044,
                                  child: _contructText(
                                      "Valor cota: R\$${double.parse(ticker["data"]["valor_cota"].toString().replaceFirst(",", ".")).toStringAsFixed(2)}",
                                      size),
                                ),
                                Positioned(
                                    top: size.height * 0.066,
                                    child: _contructText(
                                        "DY 12 meses: ${ticker["data"]["dy"]}%",
                                        size)),
                                Positioned(
                                  top: size.height * 0.088,
                                  child: _contructText(
                                      "Data do pagamento: ${ticker["data"]["ultimo_pagamento"]}",
                                      size),
                                ),
                                Positioned(
                                  top: size.height * 0.11,
                                  child: _contructText(
                                      "Preço Min no dia: R\$${ticker["data"]["preco_min_cota_dia"]}",
                                      size),
                                ),
                                Positioned(
                                  top: size.height * 0.132,
                                  child: _contructText(
                                      "Preço Max no dia: R\$${ticker["data"]["preco_max_cota_dia"]}",
                                      size),
                                ),
                                Positioned(
                                  top: size.height * 0.155,
                                  child: _contructText(
                                      "Oscilação: ${ticker["data"]["oscilacao_cota_dia"]}",
                                      size),
                                ),
                                Container(
                                    width: size.width,
                                    height: size.height * 0.368,
                                    child: DraggableScrollableSheet(
                                      minChildSize: 0.08,
                                      initialChildSize: 0.08,
                                      builder: (context, scrollController) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.height * 0.008,
                                                      bottom:
                                                          size.height * 0.008),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[900],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                  ),
                                                  width: size.width * 0.1,
                                                  height: size.height * 0.012,
                                                ),
                                                Text(
                                                  "Sobre a Empresa",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                    "${ticker["data"]["info"]}"),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ))
                              ],
                            ),
                          ],
                        ))
                ],
              ),
            )));
  }

  Widget _contructText(String text, Size size) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Divider(
          height: size.height * 0.01,
        )
      ],
    );
  }
}
