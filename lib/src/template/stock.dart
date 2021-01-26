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
  Stock({Key key, this.dataStock}) : super(key: key);
  final Map dataStock;
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  var _snack = GlobalKey<ScaffoldState>();

  Future<File> getDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + "/data.json");
  }

  Future saveData() async {
    final file = await getDirectory();
    try {
      final data = await jsonDecode(file.readAsStringSync());
      for (var x = 0; x < data["acoes"].length; x++) {
        if (data["acoes"][x]["ticker"] == widget.dataStock["data"]["ticker"]) {
          _snack.currentState.removeCurrentSnackBar();
          _snack.currentState.showSnackBar(SnackBar(
            content: Text("Já está na sua carteira"),
          ));
          return null;
        }
      }
      List acoes = data["acoes"];
      acoes.add({
        "ticker": widget.dataStock["data"]["ticker"],
        "nome": widget.dataStock["data"]["nome"],
        "info": widget.dataStock["data"]["info"],
        "logo": widget.dataStock["data"]["logo"]
      });
      data["acoes"] = acoes;
      print(await data);
      await file.writeAsStringSync(jsonEncode(data));

      _snack.currentState.removeCurrentSnackBar();
      _snack.currentState.showSnackBar(SnackBar(
        content: Text("Adicionado na carteira"),
      ));
    } catch (e) {
      await file.writeAsStringSync(jsonEncode({
        "acoes": [
          {
            "ticker": widget.dataStock["data"]["ticker"],
            "nome": widget.dataStock["data"]["nome"],
            "info": widget.dataStock["data"]["info"],
            "logo": widget.dataStock["data"]["logo"]
          }
        ]
      }));
      _snack.currentState.removeCurrentSnackBar();
      _snack.currentState.showSnackBar(SnackBar(
        content: Text("Adicionado na carteira"),
      ));
    }
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
                          widget.dataStock["data"]["logo"],
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
                        onPressed: () async => await saveData(),
                      ),
                      width: 38,
                      height: 38,
                    )
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                _contructText("${widget.dataStock["data"]["nome"]}", size),
                _contructText("${widget.dataStock["data"]["ticker"]}", size),
                _contructText(
                    "Valor cota: R\$${double.parse(widget.dataStock["data"]["valor_cota"].replaceFirst(",", ".")).toStringAsFixed(2)}",
                    size),
                _contructText(
                    "DY 12 meses: ${widget.dataStock["data"]["dy"]}%.a.a",
                    size),
                _contructText(
                    "Data do pagamento: ${widget.dataStock["data"]["ultimo_pagamento"]}",
                    size),
                _contructText(
                    "Preço Min no dia: R\$${widget.dataStock["data"]["preco_min_cota"]}",
                    size),
                _contructText(
                    "Preço Max no dia: R\$${widget.dataStock["data"]["preco_max_cota"]}",
                    size),
                _contructText(
                    "Oscilação: ${widget.dataStock["data"]["oscilacao_cota"]}",
                    size),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _contructText(
                      "Sobre A Empresa: ${widget.dataStock["data"]["info"]}",
                      size),
                ),
                Text(
                  "D* = Oscilação",
                  style: TextStyle(color: Colors.white),
                ),
                /*LineGraph(
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
                ) */
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
                        pointsMode: PointsMode.all))
              ],
            ))));
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
