//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:Ibovespa/src/template/stock.dart';

Widget stocks(Size size, Function getData, List stocks) {
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
                                      dataStock: stocks[index],
                                    ))),
                        child: Card(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(3),
                                    topLeft: Radius.circular(3)),
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

Widget searchedStock(Size size, Map ticker) {
  return Column(
    children: [
      Divider(
        height: size.height * 0.05,
        color: Colors.transparent,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            width: size.width * 0.65,
            height: size.height * 0.25,
            child: Image.network(
              ticker["data"]["logo"],
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            )),
      ),
      Divider(
        color: Colors.transparent,
      ),
      text("${ticker["data"]["nome"]}"),
      text("${ticker["data"]["ticker"]}"),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ticker["data"]["oscilacao_cota"].toString().characters.first == "-"
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
        "Valor cota: R\$${double.parse(ticker["data"]["valor_cota"].replaceFirst(",", ".")).toStringAsFixed(2)}",
      ),
      ticker["data"]["ultimo_pagamento"] == null
          ? text("*ETFs não pagam DY*")
          : text(
              "DY 12 meses: ${ticker["data"]["dy"]}%.a.a",
            ),
      ticker["data"]["ultimo_pagamento"] == null
          ? text("*ETFs não pagam DY*")
          : text(
              "Pagamento DY 12 últimos meses: ${ticker["data"]["ultimo_pagamento"].replaceAll(new RegExp(r'\s+'), '')}",
            ),
      text(
        "Preço Min em 12 meses: R\$${ticker["data"]["preco_min_cota"]}",
      ),
      text("Preço Max em 12 meses: R\$${ticker["data"]["preco_max_cota"]}"),
      text(
        "Oscilação: ${ticker["data"]["oscilacao_cota"]}",
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: text("${ticker["data"]["info"]}"),
      )
    ],
  );
}

Widget text(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 16),
  );
}
