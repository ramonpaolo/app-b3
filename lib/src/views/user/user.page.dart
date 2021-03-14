//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//---- Widgets
import 'package:Ibovespa/src/views/user/widgets/listView.dart';
import 'package:Ibovespa/src/views/user/widgets/listViewGrid.dart';

//---- Screen
import 'package:Ibovespa/src/nav.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool error = true;
  bool grid = false;

  List nameWallets = [];
  List stocks = [];

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
      final datas = await jsonDecode(file.readAsStringSync());

      Map answerServer;
      http.Response response;

      for (var x = 0; x < await datas["wallets"].length; x++)
        await datas["wallets"][x].forEach((key, value) async {
          setState(() {
            error = false;
            stocks.add({key: value});
            nameWallets.add(key);
          });
          //Faz um Loop na lista de Values(Tickers)
          for (var indexTicker = 0; indexTicker < value.length; indexTicker++) {
            response = await http.get(
                "https://dbf8f8ea650e.ngrok.io/?ticker=${value[indexTicker]["ticker"]}");
            answerServer = await jsonDecode(response.body);
            setState(() {
              stocks[x][key][indexTicker] = answerServer;
            });
          }
        });
    } catch (e) {
      setState(() => error = true);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
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
              height: size.height * 0.32,
              child: Stack(children: [
                Container(
                  width: size.width,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
                Positioned(
                  top: size.height * 0.14,
                  left: size.width * 0.75,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 32,
                          ),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(
                            Icons.verified_user,
                            color: Colors.black,
                            size: 32,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
                Positioned(
                    top: size.height * 0.11,
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
                    top: size.height * 0.29,
                    left: size.width * 0.32,
                    child: Text(
                      "Ramon Paolo Maran",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))
              ])),
          if (error)
            Container(
              margin: EdgeInsets.only(top: size.height * 0.2),
              child: TextButton(
                  child: Text("Crie uma carteira"),
                  onPressed: () async => await Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Nav()))),
            )
          else if (nameWallets.length >= 1)
            Scrollbar(
                radius: Radius.circular(30),
                thickness: 20.0,
                controller: _scrollController,
                showTrackOnHover: true,
                isAlwaysShown: true,
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  width: size.width,
                  height: size.height * 0.655,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    controller: _scrollController,
                    itemCount: nameWallets.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, indexWallets) {
                      return Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          width: size.width,
                          height: grid ? size.height * 0.5 : size.height * 0.28,
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
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
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.only(top: 4),
                                  width: size.width,
                                  height: grid
                                      ? size.height * 0.44
                                      : size.height * 0.23,
                                  child: grid
                                      ? ListGridView(
                                          stocks: stocks,
                                          indexWallets: indexWallets,
                                          nameWallets: nameWallets,
                                          size: size)
                                      : ListViewRow(
                                          stocks: stocks,
                                          indexWallets: indexWallets,
                                          nameWallets: nameWallets,
                                          size: size))
                            ],
                          ));
                    },
                  ),
                ))
          else
            Container(
                margin: EdgeInsets.only(top: size.height * 0.2),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ))
        ])));
  }
}
