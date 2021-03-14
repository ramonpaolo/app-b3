//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

//---- Screens
import 'package:Ibovespa/src/template/stock.page.dart';

Widget listView(Size size, Function getData, List stocks) {
  return RefreshIndicator(
      onRefresh: getData,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: size.height * 0.01),
              width: size.width,
              height: size.height * 0.8,
              child: ListView.builder(
                itemCount: stocks.length,
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return Container(
                      width: size.width * 0.3,
                      height: size.height * 0.12,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Stock(
                                      dataStock: stocks[index]["data"],
                                    ))),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(12),
                                  topLeft: Radius.circular(12))),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                    width: size.width * 0.3,
                                    height: size.height * 0.12,
                                    child: Image.network(
                                      stocks[index]["data"]["logo"],
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    )),
                              ),
                              Expanded(
                                  child: ListTile(
                                      title: Text(stocks[index]["data"]["nome"]
                                                  .toString()
                                                  .characters
                                                  .length <=
                                              15
                                          ? "${stocks[index]["data"]["nome"]}"
                                          : "${stocks[index]["data"]["nome"].toString().characters.getRange(0, 14)}..."),
                                      subtitle:
                                          Text(stocks[index]["data"]["ticker"]),
                                      trailing: Container(
                                          width: size.width * 0.4,
                                          height: size.height * 0.06,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              stocks[index]["data"]
                                                              ["oscilacao_cota"]
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
                                                      color: Colors.blue,
                                                    ),
                                              Text(
                                                  "R\$${stocks[index]["data"]["valor_cota"]}")
                                            ],
                                          ))))
                            ],
                          ),
                        ),
                      ));
                },
              )),
        ],
      ));
}

Widget searchedStock(Size size, Map ticker, BuildContext context) {
  String selectedWallet = "";
  return StatefulBuilder(
      builder: (context, setState) => Column(
            children: [
              Divider(
                height: size.height * 0.05,
                color: Colors.transparent,
              ),
              Stack(
                alignment: Alignment(1, -1),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        width: size.width * 0.65,
                        height: size.height * 0.25,
                        child: Image.network(
                          ticker["logo"],
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black,
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final file = File(directory.path + "/data.json");
                          var data;

                          bool notSearchMore = false;

                          try {
                            data = await jsonDecode(file.readAsStringSync());
                          } catch (e) {
                            print("Criando arquivo....");
                            file.writeAsStringSync(jsonEncode({
                              "wallets": [
                                {"Dividendos": []},
                                {
                                  "Oscilações": [
                                    {"ticker": "bidi4"},
                                    {"ticker": "wizs3"}
                                  ]
                                }
                              ]
                            }));
                            data = await jsonDecode(file.readAsStringSync());
                            print("Arquivo Criado com Sucesso....");
                          }

                          //print(data);

                          List qtdCarteiras = [];
                          for (var x = 0; x < data["wallets"].length; x++) {
                            data["wallets"][x].forEach((key, value) {
                              setState(() {
                                qtdCarteiras.add({
                                  "name": key,
                                  "lengthStocks": value.length
                                });
                              });
                            });
                          }

                          await showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                      padding: EdgeInsets.all(32),
                                      width: size.width,
                                      height: size.height * 0.4,
                                      child: Column(
                                        children: [
                                          Text("Selecione uma carteira"),
                                          Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      qtdCarteiras.length,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      Container(
                                                          width: size.width,
                                                          height: size.height *
                                                              0.08,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedWallet =
                                                                    qtdCarteiras[
                                                                            index]
                                                                        [
                                                                        "name"];
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: ListTile(
                                                              title: Text(
                                                                  "${qtdCarteiras[index]["name"]}"),
                                                              subtitle: Text(
                                                                  "Quantidade de ações: ${qtdCarteiras[index]["lengthStocks"]}"),
                                                            ),
                                                          ))))
                                        ],
                                      ));
                                },
                              );
                            },
                          );

                          print("Carteira Selecionada: " + selectedWallet);

                          for (var y = 0; y < data["wallets"].length; y++) {
                            data["wallets"][y].forEach((key, value) {
                              if (key == selectedWallet) {
                                for (var x = 0;
                                    x < data["wallets"][y][key].length;
                                    x++) {
                                  if (data["wallets"][y][key][x]["ticker"]
                                          .toString()
                                          .toLowerCase() ==
                                      ticker["ticker"]
                                          .toString()
                                          .toLowerCase()) {
                                    print(
                                        "Ticker igual: ${data["wallets"][y][key][x]["ticker"].toString().toLowerCase()}");
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Ação já existe em carteira")));
                                    setState(() {
                                      notSearchMore = true;
                                    });
                                    break;
                                  }
                                }
                              }
                            });
                          }

                          if (!notSearchMore)
                            for (var y = 0; y < data["wallets"].length; y++) {
                              data["wallets"][y].forEach((key, value) {
                                if (key == selectedWallet) {
                                  /*print(data["wallets"][y][key]);
          print(widget.dataStock["data"]["ticker"]);
          });
          print(data["wallets"][y][key]);*/
                                  data["wallets"][y][key].add({
                                    "ticker": ticker["ticker"]
                                        .toString()
                                        .toLowerCase()
                                  });
                                  file.writeAsStringSync(jsonEncode(data));
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "${ticker["ticker"]} adicionado em $key"),
                                    duration: Duration(seconds: 5),
                                  ));
                                  return;
                                }
                              });
                            }
                        }),
                    width: 38,
                    height: 38,
                  )
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              text("${ticker["nome"]}"),
              text("${ticker["ticker"]}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ticker["oscilacao_cota"].toString().characters.first == "-"
                      ? Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                  text("R\$${ticker["valor_cota"]}"),
                ],
              ),
              text(
                "Valor cota: R\$${double.parse(ticker["valor_cota"].replaceFirst(",", ".")).toStringAsFixed(2)}",
              ),
              ticker["ultimo_pagamento"] == null
                  ? text("*ETFs não pagam DY*")
                  : text(
                      "DY 12 meses: ${ticker["dy"]}%.a.a",
                    ),
              ticker["ultimo_pagamento"] == null
                  ? text("*ETFs não pagam DY*")
                  : text(
                      "Pagamento DY 12 últimos meses: ${ticker["ultimo_pagamento"].replaceAll(new RegExp(r'\s+'), '')}",
                    ),
              text(
                "Preço Min em 12 meses: R\$${ticker["preco_min_cota"]}",
              ),
              text("Preço Max em 12 meses: R\$${ticker["preco_max_cota"]}"),
              text(
                "Oscilação: ${ticker["oscilacao_cota"]}",
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: text("${ticker["info"]}"),
              )
            ],
          ));
}

Widget text(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 16),
  );
}
