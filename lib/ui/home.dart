import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:unsplah_clone/utils/utils.dart' as util;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchQuery = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Unsplash Wallpaper"),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: new TextField(
                      controller: searchQuery,
//                      autofocus: true,
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                      decoration:
                          new InputDecoration(hintText: "Search Photos"),
                    ),
                  ),
                ),
                new RaisedButton(
                  onPressed: () => setState(() => debugPrint("Hello")),
                  child: new Text(
                    "Search",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.blueAccent,
                )
              ],
            ),
          ),
          updateTempWidget(),
        ],
      ),
    );
  }

  Widget updateTempWidget() {
    return new FutureBuilder(
        future: getImages(util.accessKey),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          try {
            Map content = snapshot.data;
            debugPrint(content.toString());
            return new Expanded(
                child: new OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                // Create a grid with 2 columns in portrait mode, or 3 columns in
                // landscape mode.
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                // Generate 100 Widgets that display their index in the List
                children: List.generate(int.parse(content["results"].length.toString()), (index) {
                  return Card(
                    elevation: 0.0,
                    child: Center(
                      child: Image.network(
                        content["results"][index]["urls"]["thumb"].toString(),
                      )
                    ),
                  );
                }),
              );
            }));
          } catch (e) {
            return new Text(
              "Error Fetching Data",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              ),
            );
          }
        });
  }

  Future<Map> getImages(String accessKey) async {
    String apiUrl = Uri.https("api.unsplash.com", "/search/photos",
        {"client_id": "$accessKey","per_page": "30", "query": "nature"}).toString();
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }
}
