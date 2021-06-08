import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Uri request =
    Uri.parse('https://api.hgbrasil.com/finance?format=json-cors&key=5a1660dc');

void main() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body)["results"]["currencies"]["USD"]);

  runApp(
    MaterialApp(
      home: Container(
          color: Colors.blue,
          child: SingleChildScrollView(
            child: Text(
              "${json.decode(response.body)["results"]["currencies"]["USD"]}",
              style: TextStyle(fontSize: 30.0, color: Colors.amber),
            ),
          )),
    ),
  );
}
