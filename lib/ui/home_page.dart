import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _BASE_URL =
    "https://api.giphy.com/v1/gifs/trending?api_key=ZZZf2FTnbTsAfPOLrBP7ymjm6Fw6VJ1b&limit=20&rating=G";
  String _search, _offset;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search != null) {
      response = await http.get("https://api.giphy.com/v1/gifs/search"
          "?api_key=ZZZf2FTnbTsAfPOLrBP7ymjm6Fw6VJ1b"
          "&q=$_search"
          "&limit=20"
          "&offset=$_offset"
          "&rating=G&lang=pt"
      );
      return json.decode(response.body);
    }

    response = await http.get(_BASE_URL);
    return json.decode(response.body);
  }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: snapshot.data['data'].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(
            snapshot.data['data'][index]['images']['fixed_height']['url'],
            height: 300.0,
            fit: BoxFit.cover,
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    return snapshot.hasError
                      ? Container()
                      : _createGitTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}