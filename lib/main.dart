import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//TODO Add your api key here
// you can get it here https://hgbrasil.com/status/finance
const String key = "";

const request = "https://api.hgbrasil.com/finance?key=${key}";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber[200])),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;
  double bitcoin;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  void realChanged(String text) {
    if (text.isNotEmpty) {
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
      bitcoinController.text = (real / bitcoin).toStringAsFixed(7);
    } else {
      euroController.text = "";
      dolarController.text = "";
      bitcoinController.text = "";
    }
  }

  void dolarChanged(String text) {
    if (text.isNotEmpty) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
      bitcoinController.text =
          (dolar * this.dolar / bitcoin).toStringAsFixed(7);
    } else {
      realController.text = "";
      euroController.text = "";
      bitcoinController.text = "";
    }
  }

  void euroChanged(String text) {
    if (text.isNotEmpty) {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
      bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(7);
    } else {
      realController.text = "";
      dolarController.text = "";
      bitcoinController.text = "";
    }
  }

  void bitcoinChanged(String text) {
    if (text.isNotEmpty) {
      double bitcoin = double.parse(text);
      realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
      dolarController.text =
          (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
      euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);
    } else {
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Currency Converter"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Loading Data...",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                  break;
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Error while loading Data",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 40,
                        )
                      ],
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin =
                        snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          Divider(),
                          buildTextField("R\$", realController, realChanged),
                          Divider(),
                          buildTextField("US\$", dolarController, dolarChanged),
                          Divider(),
                          buildTextField("€", euroController, euroChanged),
                          Divider(),
                          buildTextField(
                              "₿", bitcoinController, bitcoinChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: prefix,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25),
      border: OutlineInputBorder(),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
