import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  var _parcelId = new TextEditingController();
  bool _validate = false;
  String barcode = "";
  bool _isLoading = false;
  var id;
  var api =
      "http://trackhal.com/cgi-bin/GInfo.dll?EmsApiTrack&ntype=10000&cno=";
  String url = '';
  List data;
  List des;

//85600053564

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _parcelId.dispose();
    super.dispose();
  }

  Future<dynamic> getJsonData() async {
    http.Response res = await http.get(Uri.encodeFull(url));
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ກວດສອບສະຖານະພັດສະດຸ"),
        backgroundColor: Colors.red[600],
        centerTitle: true,
      ),
      body: _isLoading
          ? new LoadingPage()
          : Column(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                  child: new Container(
                    child: new Center(
                        child: new Column(children: [
                      new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0)),
                      new Image.asset('assets/logo.png'),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new TextFormField(
                          controller: _parcelId,
                          decoration: new InputDecoration(
                            labelText: "ເລກໃບບິນ",
                            labelStyle: TextStyle(
                                color: Colors.amber[900], fontSize: 25.0),
                            errorText:
                                _validate ? 'ກະລຸນາປ້ອນເລກໃບບິນໃສ່ກ່ອນ' : null,
                            fillColor: Colors.white,

                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),

                            //fillColor: Colors.green
                          ),
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
                          onPressed: () async {
                            id = _parcelId.text;
                            if (_parcelId.text.isEmpty) {
                              _validate = true;
                            } else {
                              setState(() {
                                _isLoading = true;
                              });
                              url = api + id;
                              var res = await this.getJsonData();
                              setState(() {
                                data = res['trackingEventList'];
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new DetailPage(
                                                data: data,
                                                trackInfo: res['Response_Info'])));
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              });
                            }
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
                  ),
                )),
              ],
            ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DetailPage extends StatefulWidget {
  List data;
  var trackInfo;

  DetailPage({Key key, this.data, Key info, this.trackInfo}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState(data, trackInfo);
}

class _DetailPageState extends State<DetailPage> {
  List data;
  var trackInfo;

  _DetailPageState(this.data, this.trackInfo);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red[600],
      appBar: new AppBar(
        title: Text('ລາຍລະອຽດຂອບພັດສະດຸ'),
        backgroundColor: Colors.red[600],
        elevation: 0.0,
      ),
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 15.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "ຈາກ",
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              trackInfo['From'],
                              style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2.0,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(''),
                            SizedBox(
                              height: 10.0,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.red[600],
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "ເຖິງ",
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Luangprabang",
                              style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2.0,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                new Divider(
                  color: Colors.red,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data == null ? 0 : data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Padding(
                              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data[index]['date'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      data[index]['details'],
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    new Divider(
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
