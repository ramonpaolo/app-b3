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
  bool checkboxWallet = false, createdWallet = false;

  String selectedWallet = "";

  Map wallet;

  TextEditingController _controllerTextWallet = TextEditingController(text: "");

  void createWallet(Size size) async {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => Container(
                  padding: EdgeInsets.only(top: 32, left: 32),
                  width: size.width,
                  height: size.height * 0.2,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Digite o Nome da sua carteira"),
                    controller: _controllerTextWallet,
                    onChanged: (c) {
                      print(_controllerTextWallet.text);
                    },
                    onSubmitted: (s) async {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final file = File(directory.path + "/data.json");
                      var data;
                      try {
                        data = await jsonDecode(file.readAsStringSync());
                        await data["wallets"].add(
                            {_controllerTextWallet.text.toLowerCase(): []});
                        await file.writeAsString(jsonEncode(await data));
                      } catch (e) {
                        data = await file.writeAsString(jsonEncode({
                          "wallets": [
                            {"${_controllerTextWallet.text}": []}
                          ]
                        }));
                        setState(() => createdWallet = true);
                        print("CATCH------------------------");
                      }

                      setState(() {
                        _controllerTextWallet.clear();
                      });
                      if (data["wallets"].length == 1) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                      await saveData(size);
                    },
                  ),
                )));
    /* return await showMenu(
        context: context,
        initialValue: "",
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0.0,
        position: RelativeRect.fromLTRB(0, 0, 0, 0),
        //position: RelativeRect.fromLTRB(0, size.height * 0.3, 0, 0),
        //position: RelativeRect.fromLTRB(110, 120, 110, 0),
        items: [
          PopupMenuItem(
            value: _controllerTextWallet.text,
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: "Digite o Nome da sua carteira"),
              controller: _controllerTextWallet,
              onChanged: (c) {
                print(_controllerTextWallet.text);
              },
              onSubmitted: (s) async {
                final directory = await getApplicationDocumentsDirectory();
                final file = File(directory.path + "/data.json");
                var data;
                try {
                  data = await jsonDecode(file.readAsStringSync());
                  await data["wallets"]
                      .add({_controllerTextWallet.text.toLowerCase(): []});
                  await file.writeAsString(jsonEncode(await data));
                } catch (e) {
                  data = await file.writeAsString(jsonEncode({
                    "wallets": [
                      {"${_controllerTextWallet.text}": []}
                    ]
                  }));
                  setState(() => createdWallet = true);
                  print("CATCH------------------------");
                }

                setState(() {
                  _controllerTextWallet.clear();
                });
                if (data["wallets"].length == 1) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                await saveData(size);
              },
            ),
          )
        ]);*/
  }

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
                padding: EdgeInsets.only(top: 32),
                width: size.width,
                height: size.height * 0.4,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Selecione uma carteira ou",
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                            tooltip: "Criar Carteira",
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              await createWallet(size);
                            })
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
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
                                    title: Text(
                                        "${qtdCarteiras[index]["name"].toString().characters.replaceFirst(qtdCarteiras[index]["name"].toString().characters.characterAt(0), qtdCarteiras[index]["name"].toString().characters.characterAt(0).toUpperCase())}"),
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
      file.writeAsStringSync(jsonEncode({"wallets": []}));
      data = await jsonDecode(file.readAsStringSync());
      print("Arquivo Criado com Sucesso....");
    }

    await data["wallets"].length >= 1
        ? await selectWallet(size, await data["wallets"])
        : await createWallet(size);

    print("Carteira Selecionada: " + selectedWallet);

    for (var y = 0; y < await data["wallets"].length; y++) {
      await data["wallets"][y].forEach((key, value) async {
        if (key == selectedWallet) {
          for (var x = 0; x < await data["wallets"][y][key].length; x++) {
            if (data["wallets"][y][key][x]["ticker"] ==
                widget.dataStock["ticker"].toString().toLowerCase()) {
              print("Ticker igual: ${data["wallets"][y][key][x]["ticker"]}");
              showSnackBar("Ação já existe em carteira");
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
      for (var y = 0; y < await data["wallets"].length; y++) {
        await data["wallets"][y].forEach((key, value) async {
          if (key == selectedWallet) {
            await data["wallets"][y][key].add({
              "ticker": widget.dataStock["ticker"].toString().toLowerCase()
            });
            file.writeAsStringSync(jsonEncode(await data));
            showSnackBar("${widget.dataStock["ticker"]} adicionado em $key");
            return;
          }
        });
      }
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$text"),
      duration: Duration(seconds: 2),
    ));
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
                  height: size.height * 0.05,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 38,
                        ),
                        onPressed: () => Navigator.pop(context)),
                  ],
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
                ),

                /*
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
