import 'package:buscagifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

const LIMIT = 18;

///[en, pt, es, fr, id]
const SEARCH_LANG = 'en';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    String url = "";

    if (_search == null || _search.isEmpty) {
      url = _getUrl('trending', '&limit=$LIMIT&rating=G&offset=$_offset');
    } else {
      url = _getUrl('search',
          '&q=$_search&limit=$LIMIT&offset=$_offset&rating=G&lang=$SEARCH_LANG');
    }

    response = await http.get(url);

    return json.decode(response.body);
  }

  String _getUrl(String module, String queryParams) {
    return 'https://api.giphy.com/v1/gifs/' +
        module +
        '?api_key=paTrAWhCgD0PXwsZNmLQHAw8hhk9cOVQ' +
        queryParams;
  }

  @override
  void initState() {
    super.initState();

    _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisa",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                if (_search != value) {
                  setState(() {
                    _offset = 0;
                    _search = value;
                  });
                  _getGifs();
                }
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: _getGifs(),
            builder: _buildList,
          ))
        ],
      ),
    );
  }

  Widget _buildList(context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
      case ConnectionState.none:
        return Container(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 5.0,
          ),
          alignment: Alignment.center,
          width: 200.0,
          height: 200.0,
        );
      default:
        if (snapshot.hasError) {
          return Container();
        } else {
          return _createGifTable(context, snapshot);
        }
    }
  }

  Widget _createGifTable(context, snapshot) {
    List dados = snapshot.data["data"];

    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: dados.length,
        itemBuilder: (context, index) {
          if (index < dados.length - 1) {
            String url = dados[index]["images"]["fixed_height"]["url"];

            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: url,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GifPage(dados[index])));
              },
              onLongPress: () {
                Share.share(url);
              },
            );
          } else {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 70.0,
                    color: Colors.white,
                  ),
                  Text(
                    "Carregar mais",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += (LIMIT - 1);
                });
              },
            );
          }
        });
  }
}
