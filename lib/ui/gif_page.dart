import 'package:flutter/material.dart';
import 'package:buscagifs/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    String url = _gifData["images"]["fixed_height"]["url"];
    String name = _gifData["title"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              await ShareUtil.shareFromURL(url, name);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(child: Image.network(url)),
    );
  }
}
