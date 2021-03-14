import 'dart:convert';
import 'dart:io';

import 'package:Ibovespa/src/template/stock.page.dart';
import 'package:Ibovespa/src/views/user/widgets/bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListGridView extends StatefulWidget {
  ListGridView(
      {Key key, this.stocks, this.indexWallets, this.nameWallets, this.size})
      : super(key: key);
  final List stocks;
  final int indexWallets;
  final List nameWallets;
  final Size size;
  @override
  _ListGridViewState createState() => _ListGridViewState();
}

class _ListGridViewState extends State<ListGridView> {
  List stocks;
  int indexWallets;
  List nameWallets;
  Size size;

  @override
  void initState() {
    stocks = widget.stocks;
    indexWallets = widget.indexWallets;
    nameWallets = widget.nameWallets;
    size = widget.size;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(0),
        itemCount: stocks[indexWallets]
                [nameWallets[indexWallets].toString().toLowerCase()]
            .length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 2),
        itemBuilder: (context, index) {
          if (stocks[indexWallets]
                      [nameWallets[indexWallets].toString().toLowerCase()]
                  [index]["data"] ==
              null) {
            return Container(
                width: size.width * 0.44,
                height: size.height * 0.2,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
          } else {
            return GestureDetector(
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
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
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
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.only(
                                    left: size.width * 0.35, top: 4),
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
                                        stocks[indexWallets]
                                            [nameWallets[indexWallets]],
                                        nameWallets[indexWallets]);
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
                    )));
          }
        });
  }

  Future excludeStock(String ticker, List stocks, String wallet) async {
    setState(() {
      stocks.removeWhere((element) => element["data"]["ticker"] == ticker);
    });
    //print(stocks);
    final directory = await getApplicationDocumentsDirectory();
    final file = File(directory.path + "/data.json");
    final data = await jsonDecode(file.readAsStringSync());
    int x = 0;
    data["wallets"].forEach((element) {
      element.forEach((key, value) {
        if (key == wallet) {
          data["wallets"][x][key] = stocks;
        }
      });
      x = x + 1;
    });
    print(await data["wallets"]);
    file.writeAsStringSync(jsonEncode(await data));
    print("Removido: $ticker de $wallet");
  }
}
