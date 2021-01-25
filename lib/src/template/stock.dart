import 'package:flutter/material.dart';

class Stock extends StatefulWidget {
  Stock({Key key, this.dataStock}) : super(key: key);
  final Map dataStock;
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  var _snack = GlobalKey<ScaffoldState>();

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.2,
                    child: Image.network(
                      widget.dataStock["data"]["logo"],
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                )
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
