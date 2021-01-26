import 'package:Ibovespa/src/template/stock.dart';
import 'package:flutter/material.dart';

Widget stocks(Size size, Function getData, List stocks) {
  return RefreshIndicator(
      onRefresh: getData,
      child: Column(
        children: [
          Container(
              width: size.width,
              height: size.height * 0.75,
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
      text("Oscilação da cota no dia: ${ticker["data"]["oscilacao_cota"]}"),
      text("Divindend Yield: ${ticker["data"]["dy"]}% a.a"),
      text("Ultimo pagamento: ${ticker["data"]["ultimo_pagamento"]}"),
      Divider(
        color: Colors.transparent,
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
