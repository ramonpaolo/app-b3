import 'package:Ibovespa/src/template/stock.dart';
import 'package:Ibovespa/src/views/user/widgets.dart';
import 'package:flutter/material.dart';

Widget gridView(List stocks, int indexWallets, List nameWallets, Size size) {
  return GridView.builder(
    itemCount: stocks[indexWallets]
            [nameWallets[indexWallets].toString().toLowerCase()]
        .length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 2),
    itemBuilder: (context, index) {
      return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Stock(
                      dataStock: stocks[indexWallets][nameWallets[indexWallets]
                          .toString()
                          .toLowerCase()][index]["data"]))),
          onLongPress: () {
            bottomSheet(
                size,
                stocks[indexWallets]
                        [nameWallets[indexWallets].toString().toLowerCase()]
                    [index]["data"],
                context);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(right: 8, bottom: 8),
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
                            width: size.width * 0.5,
                            height: size.height * 0.13,
                          ),
                        ),
                      ),
                      Container(
                          margin:
                              EdgeInsets.only(left: size.width * 0.35, top: 4),
                          width: size.width * 0.095,
                          height: size.height * 0.046,
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
                                  stocks[nameWallets[indexWallets]][index]
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
                    subtitle: Text(stocks[indexWallets]
                            [nameWallets[indexWallets].toString().toLowerCase()]
                        [index]["data"]["ticker"]),
                    trailing: Text(
                      "R\$" +
                          stocks[indexWallets][nameWallets[indexWallets]
                              .toString()
                              .toLowerCase()][index]["data"]["valor_cota"],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  )
                ],
              )));
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
