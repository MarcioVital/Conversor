import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Uri request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json-cors&key=5a1660dc");

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double dolar;
  late double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void getReal(String texto) {
    double real = double.parse(texto);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void getDolar(String texto) {
    double dolar = double.parse(texto);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void getEuro(String texto) {
    double euro = double.parse(texto);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  /*void _realChanged(String text) {
    print(text);
  }

  void _dolarChanged(String text) {
    print(text);
  }

  void _euroChanged(String text) {
    print(text);
  }*/

  void _refresh() {
    setState(() {
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "Conversor",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar Dados :(",
                    style: TextStyle(fontSize: 25, color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      // buildTextField("Reais", "R\$ ", realController),
                      TextField(
                        onChanged: getReal,
                        controller: realController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "R\$ ",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                      Divider(),
                      TextField(
                        onChanged: getDolar,
                        controller: dolarController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Dólares",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "US\$ ",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                      //buildTextField("Dólares", "US\$ ", dolarController),
                      Divider(),
                      //buildTextField("Euros", "€ ", euroController),
                      TextField(
                        onChanged: getEuro,
                        controller: euroController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "EUR ",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

/*Widget buildTextField(String label, String prefix, TextEditingController c) {
  return TextField(
    controller: c,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
  );
}*/
