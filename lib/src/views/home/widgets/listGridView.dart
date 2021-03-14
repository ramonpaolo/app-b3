import 'package:Ibovespa/src/template/stock.page.dart';
import 'package:flutter/material.dart';

Widget listGrid(Size size, Function getData, List stocks) {
  return RefreshIndicator(
      onRefresh: getData,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              width: size.width,
              height: size.height * 0.8,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.9),
                  itemCount: stocks.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(
                          bottom: 8,
                        ),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Stock(
                                          dataStock: stocks[index]["data"],
                                        ))),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Container(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.all(0),
                                      width: size.width * 0.5,
                                      height: size.height * 0.15,
                                      child: Image.network(
                                        stocks[index]["data"]["logo"],
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      )),
                                ),
                                Expanded(
                                    child: ListTile(
                                        title: Text(stocks[index]["data"]
                                                        ["nome"]
                                                    .toString()
                                                    .characters
                                                    .length <=
                                                15
                                            ? "${stocks[index]["data"]["nome"]}"
                                            : "${stocks[index]["data"]["nome"].toString().characters.getRange(0, 14)}..."),
                                        subtitle: Text(
                                            stocks[index]["data"]["ticker"]),
                                        trailing: Container(
                                            width: size.width * 0.21,
                                            height: size.height * 0.06,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                stocks[index]["data"][
                                                                "oscilacao_cota"]
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
                            )));
                  })),
        ],
      ));
}

/*

GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Stock(
                                      dataStock: stocks[index]["data"],
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
                      )

 */
