import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const TRENDING_URL =
    'https://api.giphy.com/v1/gifs/trending?api_key=paTrAWhCgD0PXwsZNmLQHAw8hhk9cOVQ&limit=25&rating=G';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(TRENDING_URL);
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=paTrAWhCgD0PXwsZNmLQHAw8hhk9cOVQ&q=$_search&limit=20&offset=$_offset&rating=G&lang=pt');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
