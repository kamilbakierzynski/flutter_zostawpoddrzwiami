import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import "package:zostawpoddrzwiami/models/request_model.dart";
import "package:zostawpoddrzwiami/services/database_service.dart";
import "package:shared_preferences/shared_preferences.dart";

import '../models/request_model.dart';

class CurrentRequest extends StatefulWidget {
  @override
  _CurrentRequestState createState() {
    _CurrentRequestState state = _CurrentRequestState();
    for (var i = 0; i <= 500; i++){
      state.checkbox_values.add(false);
    }
    return state;
  }
}

class _CurrentRequestState extends State<CurrentRequest> {
  bool isCarrier = true;
  String name = "Pani Janinka";
  String phoneNumber = "555 444 333";
  String street = "Osiedle Mazurskie";
  String strNumber = "16";
  String city = "Mrągowo";
  String flat = "15";
  CurrentUserRequest currentRequest = null;
  int rows = 10;
  List<bool> checkbox_values = [];
  String checkBoxString = "";
  String cachedID = "";
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i <=500; i++){
      checkbox_values.add(false);
    }
    _loadCachedData();
  }

  _loadCachedData() async {
    print("in loadcacheddata");
    prefs = await SharedPreferences.getInstance();
    setState(() {
      print("in set state");
       cachedID = (prefs.getString('cachedID') ?? "");
       print("got id from disc");
       print(cachedID);
       checkBoxString = (prefs.getString('checkBoxString') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {

    final User currentUser = Provider.of<User>(context);
    final List<CurrentUserRequest> allRequests =
        Provider.of<List<CurrentUserRequest>>(context);

    if (allRequests != null) {
      print("requests are not null");
      allRequests.forEach((CurrentUserRequest req) {
        if (!req.status) {
          currentRequest = req;
          print("assigned request");
        }
      });
    } else {
      return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(
            'Twoja obecna lista',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Column(
              children: <Widget>[
                Icon(Icons.insert_emoticon, size: 50,),
                Text(
                  "Nie masz obecnych zamowien",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (currentRequest == null) {
      print("current request null");
      return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(
            'Twoja obecna lista',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Column(
              children: <Widget>[
                Icon(Icons.insert_emoticon, size: 50,),
                Text(
                  "Nie masz obecnych zamowien",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (cachedID == currentRequest.requestId){
      print("id matches");
      for (var i = 0; i < checkBoxString.length;i++){
        if (checkBoxString[i] == "1"){
          checkbox_values[i] = true;
        }
        else{
          checkbox_values[i] = false;
        }
      }
    }
    else{
      print("id not matching");
      print(cachedID);
      print(currentRequest.requestId);
    }
    if (isCarrier) {
      print("in is carrier");

      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Twoja obecna lista',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            currentRequest.name,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 40,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                phoneNumber,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  launch("tel://$phoneNumber");
                                },
                                child: Icon(Icons.phone),
                              )
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      Container(
                        child: Column(children: <Widget>[
                          FittedBox(
                            child: Text(
                              currentRequest.address,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "$strNumber/$flat",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                              FlatButton(
                                onPressed: () {
                                  _launchMapsUrl();
                                },
                                child: const Icon(Icons.location_on),
                              ),
                            ],
                          ),
                        ], crossAxisAlignment: CrossAxisAlignment.start),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: currentRequest.request.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          child: Card(
                            child: CheckboxListTile(
                              value: checkbox_values[index],
                              title: Column(
                                children: <Widget>[
                                  Text(currentRequest.request[index].name),
                                  Text(currentRequest.request[index].quantity
                                          .toString() +
                                      currentRequest.request[index].unit),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  checkbox_values[index] = value;
                                  syncWithCache();
                                });
                              },
                              secondary: const Icon(Icons.shopping_basket),
                              //trailing: Icon(Icons.more_vert),
                            ),
                          ),
                        );
                      }),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 6, right: 3),
                      width: 195,
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          print("pressed decline");
                          _showResignDialog(currentUser);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 3, right: 6),
                      width: 195,
                      child: RaisedButton(
                        color: Colors.lightGreen,
                        onPressed: () {
                          print("pressed finnished");
                          _showRequestFinishedDialog();
                        },
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Twoja obecna lista',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 30, top: 40, right: 30),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 40,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                phoneNumber,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  launch("tel://$phoneNumber");
                                },
                                child: Icon(Icons.phone),
                              )
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: rows,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          child: Card(
                            child: CheckboxListTile(
                              value: checkbox_values[index],
                              title: Column(
                                children: <Widget>[
                                  Text(currentRequest.request[index].name),
                                  Text(currentRequest.request[index].quantity
                                          .toString() +
                                      currentRequest.request[index].unit),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  checkbox_values[index] = value;
                                  syncWithCache();
                                });
                              },
                              secondary: const Icon(Icons.shopping_basket),
                              //trailing: Icon(Icons.more_vert),
                            ),
                          ),
                        );
                      }),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ));
    }
  }

  void checkbox(bool b) {
    rows -= 1;
    print(rows);
    return;
  }

  void _launchMapsUrl() async {
    print("in url func");
    final url =
        'https://www.google.com/maps/search/?api=1&query=$street,$strNumber,$city';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showResignDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content: new Text(
              "Czy na pewno chcesz zrezygnowac z obecnego zamowienia?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Nie"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Tak"),
              onPressed: () {
                DatabaseService(uid: user.uid).returnRequest(currentRequest);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRequestFinishedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content: new Text(
              "Czy na pewno chcesz oznaczyc zamowienie jako wykonane?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Nie"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Tak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void syncWithCache() async {
    prefs = await SharedPreferences.getInstance();
    String newCheckboxString = "";
    for(var i = 0; i < currentRequest.request.length; i++){
      if (checkbox_values[i] == false){
        newCheckboxString += "0";
      }
      else{
        newCheckboxString += "1";
      }
    }
    prefs.setString("checkBoxString", newCheckboxString);
    prefs.setString("cachedID", currentRequest.requestId);
    cachedID = currentRequest.requestId;
  }
}
