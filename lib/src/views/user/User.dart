//---- Packages
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:Ibovespa/src/views/home/Home.dart';
import 'package:Ibovespa/src/views/user/widgets/listView.dart';
import 'package:Ibovespa/src/views/user/widgets/listViewGrid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//---- Widgets
import 'package:Ibovespa/src/views/user/widgets.dart';

//---- Screen
import 'package:Ibovespa/src/template/stock.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool error = false;
  bool grid = false;

  List nameWallets = [];
  List stocks = [];
  int qtdWallets = 0;

  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  snackBar(String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
      ),
    ));
  }

  Future getData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(directory.path + "/data.json");
      Map resposta;
      final datas = await jsonDecode(file.readAsStringSync());

      if (await datas["wallets"] == null) {
        print("Sem carteira(s)");
        setState(() => error = true);
        return;
      }

      for (var x = 0; x < await datas["wallets"].length; x++)
        await datas["wallets"][x].forEach((key, value) async {
          setState(() {
            stocks.add({key: value});
            nameWallets.add(key);
            qtdWallets = qtdWallets + 1;
          });
          //Faz um Loop na lista de Values(Tickers)
          for (var indexTicker = 0; indexTicker < value.length; indexTicker++) {
            http.Response response;
            response = await http.get(
                "https://dbf8f8ea650e.ngrok.io/?ticker=${value[indexTicker]["ticker"]}");
            resposta = await jsonDecode(response.body);
            setState(() {
              stocks[x][key][indexTicker] = resposta;
            });

            //print(stocks[x][key][indexTicker]);
          }
        });
    } catch (e) {
      setState(() => error = false);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    stocks.clear();
    ScaffoldMessenger.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.arrow_upward,
              color: Colors.black,
            ),
            onPressed: () {
              _scrollController.animateTo(0.0,
                  duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
            },
            backgroundColor: Colors.white),
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              width: size.width,
              height: size.height * 0.37,
              child: Stack(children: [
                Container(
                  width: size.width,
                  height: size.height * 0.25,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
                Positioned(
                    top: size.height * 0.16,
                    left: size.width * 0.34,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(240),
                        child: Container(
                          width: size.width * 0.36,
                          height: size.height * 0.18,
                          child: Image.network(
                            "https://cdn.pixabay.com/photo/2020/12/21/19/05/window-5850628__340.png",
                            fit: BoxFit.cover,
                          ),
                        ))),
                Positioned(
                    top: size.height * 0.345,
                    left: size.width * 0.32,
                    child: Text(
                      "Ramon Paolo Maran",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))
              ])),
          error == false
              ? nameWallets.length >= 1
                  ? Scrollbar(
                      radius: Radius.circular(30),
                      thickness: 20.0,
                      controller: _scrollController,
                      showTrackOnHover: true,
                      isAlwaysShown: true,
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        margin: EdgeInsets.only(top: 0),
                        width: size.width,
                        height: size.height * 0.6,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: nameWallets.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, indexWallets) {
                            return Container(
                                width: size.width,
                                height: grid
                                    ? size.height * 0.5
                                    : size.height * 0.28,
                                child: Column(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Colors.white,
                                        ),
                                        width: size.width * 0.9,
                                        height: size.height * 0.04,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "${nameWallets[indexWallets].toString().characters.replaceFirst(nameWallets[indexWallets].toString().characters.characterAt(0), nameWallets[indexWallets].toString().characters.characterAt(0).toUpperCase())}",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(Icons.grid_on),
                                                onPressed: () {
                                                  setState(() => grid = !grid);
                                                  grid
                                                      ? print("grid on")
                                                      : print("grid off");
                                                })
                                          ],
                                        )),
                                    Container(
                                        width: size.width,
                                        height: grid
                                            ? size.height * 0.44
                                            : size.height * 0.22,
                                        child: grid
                                            ? gridView(stocks, indexWallets,
                                                nameWallets, size)
                                            : listView(stocks, indexWallets,
                                                nameWallets, size))
                                  ],
                                ));
                          },
                        ),
                      ))
                  : Container(
                      margin: EdgeInsets.only(top: size.height * 0.2),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ))
              : Container(
                  margin: EdgeInsets.only(top: size.height * 0.2),
                  child: TextButton(
                      child: Text("Crie uma carteira"),
                      onPressed: () async =>
                          await getData() /*Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()))*/
                      ),
                )
        ])));
  }
}
