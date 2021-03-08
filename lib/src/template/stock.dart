//---- Packages
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:draw_graph/widgets/lineGraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:path_provider/path_provider.dart';

class Stock extends StatefulWidget {
  Stock({Key key, @required this.dataStock}) : super(key: key);
  final Map dataStock;
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  Map wallet;

  bool checkboxWallet = false;

  String selectedWallet = "";

  Map carteira = {};
  List carteiras = [];

  selectWallet(Size size, List allWallets) async {
    List qtdCarteiras = [];
    for (var x = 0; x < allWallets.length; x++) {
      allWallets[x].forEach((key, value) {
        setState(() {
          qtdCarteiras.add({"name": key, "lengthStocks": value.length});
        });
      });
    }

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
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
                            itemCount: qtdCarteiras.length,
                            itemBuilder: (context, index) => Container(
                                width: size.width,
                                height: size.height * 0.08,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedWallet =
                                          qtdCarteiras[index]["name"];
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title:
                                        Text("${qtdCarteiras[index]["name"]}"),
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
  }

  Future saveData(Size size) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(directory.path + "/data.json");
    var data;

    bool notSearchMore = false;

    try {
      data = await jsonDecode(file.readAsStringSync());
    } catch (e) {
      print("Criando arquivo....");
      file.writeAsStringSync(jsonEncode({
        "wallets": [
          {"dividendos": []},
          {"oscilações": []}
        ]
      }));
      data = await jsonDecode(file.readAsStringSync());
      print("Arquivo Criado com Sucesso....");
    }

    //print(data);

    await selectWallet(size, data["wallets"]);
    print("Carteira Selecionada: " + selectedWallet);

    for (var y = 0; y < data["wallets"].length; y++) {
      data["wallets"][y].forEach((key, value) {
        if (key == selectedWallet) {
          for (var x = 0; x < data["wallets"][y][key].length; x++) {
            if (data["wallets"][y][key][x]["ticker"].toString().toLowerCase() ==
                widget.dataStock["ticker"].toString().toLowerCase()) {
              print(
                  "Ticker igual: ${data["wallets"][y][key][x]["ticker"].toString().toLowerCase()}");
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Ação já existe em carteira"),
                duration: Duration(seconds: 2),
              ));
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
          print(widget.dataStock["ticker"]);
          });
          print(data["wallets"][y][key]);*/
            data["wallets"][y][key].add({
              "ticker": widget.dataStock["ticker"].toString().toLowerCase()
            });
            file.writeAsStringSync(jsonEncode(data));
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${widget.dataStock["ticker"]} adicionado em $key"),
              duration: Duration(seconds: 2),
            ));
            return;
          }
        });
      }
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
                child: Column(
              children: [
                Divider(
                  color: Colors.transparent,
                  height: size.height * 0.1,
                ),
                Stack(
                  alignment: Alignment(0.8, -0.9),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: size.width * 0.6,
                        height: size.height * 0.2,
                        child: Image.network(
                          widget.dataStock["logo"],
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async => await saveData(size),
                      ),
                      width: 38,
                      height: 38,
                    )
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                _text("${widget.dataStock["nome"]}", size),
                _text("${widget.dataStock["ticker"]}", size),
                _text(
                    "Valor cota: R\$${double.parse(widget.dataStock["valor_cota"].replaceFirst(",", ".")).toStringAsFixed(2)}",
                    size),
                widget.dataStock["ultimo_pagamento"] == null
                    ? _text("*ETFs não pagam DY*", size)
                    : _text(
                        "DY 12 meses: ${widget.dataStock["dy"]}%.a.a", size),
                widget.dataStock["ultimo_pagamento"] == null
                    ? _text("*ETFs não pagam DY*", size)
                    : _text(
                        "Pagamento DY 12 últimos meses: ${widget.dataStock["ultimo_pagamento"]}",
                        size),
                _text(
                    "Preço Min em 12 meses: R\$${widget.dataStock["preco_min_cota"]}",
                    size),
                _text(
                    "Preço Max em 12 meses: R\$${widget.dataStock["preco_max_cota"]}",
                    size),
                _text("Oscilação: ${widget.dataStock["oscilacao_cota"]}", size),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _text(
                      "Sobre A Empresa: ${widget.dataStock["info"]}", size),
                ), /*
                Text(
                  "D* = Oscilação",
                  style: TextStyle(color: Colors.white),
                ),
                LineGraph(
                  size: Size(size.width, size.height * 0.3),
                  labelX: ['D1', 'D2', 'D3', 'D4', 'D5'],
                  labelY: ['1%', '5%', '10%', '20%', '40%'],
                  showDescription: true,
                  graphColor: Colors.white,
                  features: [
                    Feature(
                        data: [0.0, 0.1, 0.2, 0.3, -0.3],
                        color: Colors.red,
                        title: "Eae"),
                  ],
                ),
                Container(
                    width: size.width * 0.9,
                    height: size.height * 0.2,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Sparkline(
                        lineWidth: 2,
                        lineGradient: LinearGradient(
                            colors: [Colors.black, Colors.white]),
                        fillGradient: LinearGradient(
                            colors: [Colors.white, Colors.black],
                            begin: Alignment.bottomLeft),
                        fillMode: FillMode.below,
                        fillColor: Colors.black,
                        data: [0.1, 0.2, 0.13, 0.3, 0.12],
                        lineColor: Colors.white,
                        pointColor: Colors.white,
                        sharpCorners: true,
                        pointSize: 16,
                        pointsMode: PointsMode.all))*/
              ],
            ))));
  }

  Widget _text(String text, Size size) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
