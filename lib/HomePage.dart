import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({
    Key key,
    @required this.title,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List usersData;
  bool isLoading = true;
  final String url = "https://api.covid19india.org/data.json";
  Future getdata() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': 'application/json'});

    List data = jsonDecode(response.body)['statewise'];

    setState(() {
      usersData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: usersData == null ? 0 : usersData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20.0),
                            child: Image(
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.contain,
                              image: AssetImage('images/Covid1.jpg'),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Active: ${usersData[index]['active']}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("State: ${usersData[index]['state']}"),
                              Text(
                                  "Confirmed: ${usersData[index]['confirmed']}"),
                              Text("Deaths: ${usersData[index]['deaths']}"),
                              Text(
                                  "Recovered: ${usersData[index]['recovered']}"),
                              Text(
                                  "Updatedtime: ${usersData[index]['lastupdatedtime']}"),
                            ],
                          )),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
