import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  var _parcelId = new TextEditingController();
  var id;
  var api =
      "http://trackhal.com/cgi-bin/GInfo.dll?EmsApiTrack&ntype=10000&cno=";
  String url = '';
  List data;

//85600053564

  @override
  void initState() {
    super.initState();
  }

  Future<String> getJsonData() async {
    http.Response res = await http.get(
      Uri.encodeFull(url),
    );
    print(utf8.decode(res.bodyBytes));
    setState(() {
      var convertToJson = jsonDecode(utf8.decode(res.bodyBytes));
      data = convertToJson['trackingEventList'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("ກວດສອບສະຖານະພັດສະດຸ"),
        backgroundColor: Colors.red[600],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: new Container(
            child: new Center(
                child: new Column(children: [
              new Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0)),
              new Image.asset('assets/logo.png'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: new TextFormField(
                  controller: _parcelId,
                  decoration: new InputDecoration(
                    labelText: "ເລກໃບບິນ",
                    labelStyle:
                        TextStyle(color: Colors.amber[900], fontSize: 25.0),
                    fillColor: Colors.white,

                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "ກະລຸນາປ້ອນເລກໃບ້ບິນ";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new RaisedButton(
                  padding: EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 15.0),
                  textColor: Colors.white,
                  color: Colors.red[600],
                  onPressed: () {
                    id = _parcelId.text;

                    setState(() {
                      url = api + id;
                      this.getJsonData();
                    });
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetailPage(data: data),
                    );
                    Navigator.of(context).push(route);
//                    return showDialog(
//                            context: context,
//                            builder: (context){
//                            return AlertDialog(
//
//                              content: Text(url),
//                            );
//                          }
//                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(17.0)),
                  child: new Text(
                    "ກວດສອບ",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ])),
          )),

//        Expanded(
//      child: new ListView.builder(
//      itemCount: data == null ? 0 : data.length,
//      itemBuilder: (BuildContext context, int index){
//
//          return new Container(
//
//            child: new Center(
//              child: new Column(
//
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//
//                children: <Widget>[
//
//                  new Card(
//                    child: new Container(
//                      child: new Text(data[index]['date']),
//                      padding: const EdgeInsets.all(20.0),
//                    ),
//                  ),
//                  new Card(
//                    child: new Container(
//                      child: new Text(data[index]['details']),
//                      padding: const EdgeInsets.all(20.0),
//                    ),
//                  ),
//
//                ],
//
//
//
//
//              ),
//            ),
//          );
//      },
//    ),
//
//        ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  List data;

  DetailPage({Key key, this.data}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState(data);
}

class _DetailPageState extends State<DetailPage> {
  List data;

  _DetailPageState(
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('ລາຍລະອຽດຂອບພັດສະດຸ'),
        backgroundColor: Colors.red[600],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: new Center(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Card(
                          child: new Container(
                            child: new Text(data[index]['date']),
                            padding: const EdgeInsets.all(20.0),
                          ),
                        ),
                        new Card(
                          child: new Container(
                            child: new Text(data[index]['details']),
                            padding: const EdgeInsets.all(20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
