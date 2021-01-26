import 'package:flutter/material.dart';

Widget _text(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

bottomSheet(Size size, Map stock, BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40))),
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        width: size.width,
        height: size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                width: size.width * 0.1,
                height: 30,
                child: IconButton(
                  tooltip: "Sair da janela",
                  icon: Icon(
                    Icons.clear,
                    size: 28,
                    color: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  child: Image.network(
                    stock["logo"],
                    fit: BoxFit.cover,
                    width: size.width * 0.5,
                    height: size.height * 0.15,
                  ),
                ),
              ),
              _text(
                stock["nome"],
              ),
              _text(
                stock["ticker"],
              ),
              _text(
                "Dividend Yield: ${stock["dy"]} % a.a",
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _text("Preço Max no dia: R\$${stock["preco_max_cota"]}"),
                  _text("|"),
                  _text("Preço Min no dia: R\$${stock["preco_min_cota"]}"),
                ],
              ),
              _text("Valor da Cota: ${stock["valor_cota"]}"),
              _text("Oscilação da cota no dia: ${stock["oscilacao_cota"]}"),
              _text("Ultimo pagamento de DY: ${stock["ultimo_pagamento"]}"),
              Divider(
                color: Colors.white,
              ),
              _text("Sobre a Empresa: ${stock["info"]}"),
            ],
          ),
        ),
      );
    },
  );
}
