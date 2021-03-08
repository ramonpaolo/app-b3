import 'package:Ibovespa/src/template/stock.dart';
import 'package:Ibovespa/src/views/user/widgets.dart';
import 'package:flutter/material.dart';

Widget listView(List stocks, int indexWallets, List nameWallets, Size size) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: stocks[indexWallets]
            [nameWallets[indexWallets].toString().toLowerCase()]
        .length,
    itemBuilder: (context, index) {
      if (stocks[indexWallets]
                  [nameWallets[indexWallets].toString().toLowerCase()][index]
              ["data"] ==
          null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
            width: size.width * 0.44,
            height: size.height * 0.2,
            child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Stock(
                            dataStock: stocks[indexWallets][
                                nameWallets[indexWallets]
                                    .toString()
                                    .toLowerCase()][index]["data"]))),
                onLongPress: () {
                  bottomSheet(
                      size,
                      stocks[indexWallets][nameWallets[indexWallets]
                          .toString()
                          .toLowerCase()][index]["data"],
                      context);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 8),
                    width: size.width * 0.42,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(9),
                                  topRight: Radius.circular(9)),
                              child: Container(
                                child: Image.network(
                                  stocks[indexWallets][nameWallets[indexWallets]
                                      .toString()
                                      .toLowerCase()][index]["data"]["logo"],
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  width: size.width * 0.43,
                                  height: size.height * 0.13,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: size.width * 0.3, top: 4),
                                width: size.width * 0.095,
                                height: size.height * 0.045,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(80)),
                                child: IconButton(
                                  tooltip: "Excluir",
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await excludeStock(
                                        stocks[indexWallets][
                                                nameWallets[indexWallets]
                                                    .toString()
                                                    .toLowerCase()][index]
                                            ["data"]["ticker"],
                                        stocks);
                                  },
                                ))
                          ],
                        ),
                        ListTile(
                          title: Text(stocks[indexWallets]
                                              [nameWallets[indexWallets].toString().toLowerCase()]
                                          [index]["data"]["nome"]
                                      .toString()
                                      .characters
                                      .length >=
                                  16
                              ? stocks[indexWallets]
                                              [nameWallets[indexWallets].toString().toLowerCase()]
                                          [index]["data"]["nome"]
                                      .toString()
                                      .characters
                                      .getRange(0, 14)
                                      .toString() +
                                  "..."
                              : stocks[indexWallets]
                                      [nameWallets[indexWallets].toString().toLowerCase()]
                                  [index]["data"]["nome"]),
                          subtitle: Text(stocks[indexWallets][
                              nameWallets[indexWallets]
                                  .toString()
                                  .toLowerCase()][index]["data"]["ticker"]),
                          trailing: Text(
                            "R\$" +
                                stocks[indexWallets][nameWallets[indexWallets]
                                        .toString()
                                        .toLowerCase()][index]["data"]
                                    ["valor_cota"],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        )
                      ],
                    ))));
      }

      //  stocks[indexWallets][nameWallets[indexWallets].toString().toLowerCase()][index]
    },
  );
}

Future excludeStock(String ticker, List stocks) async {
  for (var x = 0; x < stocks.length; x++) {
    if (stocks[x]["data"]["ticker"] == ticker) {
      stocks.removeAt(x);

      break;
    }
  }
  //final file = await getDirectory();
  //file.writeAsStringSync(jsonEncode({"acoes": acoes}));
}
