import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zostawpoddrzwiami/models/confirm_request.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import "package:zostawpoddrzwiami/models/request_model.dart";
import 'package:zostawpoddrzwiami/screens/request_completing_screen.dart';
import "package:zostawpoddrzwiami/services/database_service.dart";
import "package:shared_preferences/shared_preferences.dart";

import '../models/request_model.dart';

class CurrentRequest extends StatefulWidget {
  @override
  _CurrentRequestState createState() {
    _CurrentRequestState state = _CurrentRequestState();
    for (var i = 0; i <= 500; i++) {
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
    for (var i = 0; i <= 500; i++) {
      checkbox_values.add(false);
    }
    _loadCachedData();
  }

  _loadCachedData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cachedID = (prefs.getString('cachedID') ?? "");
      checkBoxString = (prefs.getString('checkBoxString') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<User>(context);
    final List<CurrentUserRequest> allRequests =
        Provider.of<List<CurrentUserRequest>>(context);

    if (allRequests != null) {
      allRequests.forEach((CurrentUserRequest req) {
        currentRequest = req;
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
                Icon(
                  Icons.insert_emoticon,
                  size: 50,
                ),
                Text(
                  "Nie masz obecnych zamowien",
                  style: TextStyle(
                    color: Colors.white,
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
        backgroundColor: Colors.white,
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
                Icon(
                  Icons.insert_emoticon,
                  size: 50,
                ),
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
    if (cachedID == currentRequest.requestId) {
      for (var i = 0; i < checkBoxString.length; i++) {
        if (checkBoxString[i] == "1") {
          checkbox_values[i] = true;
        } else {
          checkbox_values[i] = false;
        }
      }
    }
    if (currentUser.uid != currentRequest.customer) {
      print("in is carrier");

      street = currentRequest.address;
      print(street);
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Twoja obecna lista',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _showResignDialog(currentUser);
                  })
            ],
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _showRequestFinishedDialogTaker(currentUser, currentRequest);
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            label: Text('Potwierdź dostarczenie'),
            backgroundColor: Colors.green,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                currentRequest.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                currentRequest.requestId,
                                style: TextStyle(color: Colors.grey[400]),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.green[600],
                                ),
                                onPressed: () => launch("tel://$phoneNumber"),
                              ),
                              Text(
                                currentRequest.phoneNumber,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.red[700],
                                ),
                                onPressed: () => _launchMapsUrl(),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: AutoSizeText(
                                  street,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.info),
                                onPressed: null,
                              ),
                              Text(
                                currentRequest.description,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: currentRequest.request.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: index == (currentRequest.request.length - 1)
                              ? const EdgeInsets.only(
                                  bottom: 60.0, left: 10.0, right: 10.0)
                              : const EdgeInsets.symmetric(horizontal: 10.0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: checkbox_values[index]
                                    ? Colors.grey[100]
                                    : Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                      offset: Offset(3, 4))
                                ]),
                            child: CheckboxListTile(
                              value: checkbox_values[index],
                              activeColor: Colors.green[600],
                              title: Text(
                                currentRequest.request[index].name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                currentRequest.request[index].quantity
                                        .toString() +
                                    " " +
                                    currentRequest.request[index].unit,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  checkbox_values[index] = value;
                                  syncWithCache();
                                });
                              },
                              dense: true,
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
    } else {
      print(currentRequest.status);
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Twoja obecna prośba',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
          floatingActionButton: currentRequest.status
              ? FloatingActionButton.extended(
                  onPressed: () {
//                        _showRequestFinishedDialogMaker(currentRequest.requestId);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CompleteRequest(currentRequest.requestId)),
                        ModalRoute.withName('/'));
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  label: Text('Potwierdź odebranie'),
                  backgroundColor: Colors.green[600],
                )
              : FloatingActionButton.extended(
                  onPressed: () {
                    _showCancelDialog(currentUser);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  label: Text('Anuluj'),
                  backgroundColor: Colors.red[600],
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                phoneNumber,
//                                style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 20
//                                ),
//                              ),
//                              FlatButton(
//                                onPressed: () {
//                                  launch("tel://$phoneNumber");
//                                },
//                                child: Icon(Icons.phone, color: Colors.green[600],),
//                              )
//                            ],
//                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: currentRequest.request.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          child: Card(
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon(Icons.shopping_basket),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            currentRequest.request[index].name),
                                        Text(currentRequest
                                                .request[index].quantity
                                                .toString() +
                                            currentRequest.request[index].unit),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                  ),
                                ],
                              ),
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
              "Czy na pewno chcesz zrezygnowac z obecnie wykonywanej prośby?"),
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
                print(user.uid);
                DatabaseService(uid: user.uid).abandonRequest(currentRequest);
                print("abandoning request");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(User user) {
    if (currentRequest.status != true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Uwaga!"),
            content:
                new Text("Czy na pewno chcesz zrezygnowac ze złożonej prośby?"),
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
                  DatabaseService(uid: user.uid)
                      .deleteOwnRequest(currentRequest);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Uwaga!"),
            content:
                new Text("Nie możesz zrezygnować z prośby którą ktoś zmienia"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Rozumiem"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showRequestFinishedDialogTaker(
      User user, CurrentUserRequest userRequest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content: new Text(
              "Czy na pewno chcesz oznaczyć zamowienie jako wykonane?"),
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
              onPressed: () async {
                ConfirmRequest confirmRequest = ConfirmRequest(
                    orderId: userRequest.requestId,
                    makerUid: userRequest.customer,
                    takerUid: user.uid,
                    received: false);
                await DatabaseService(uid: user.uid)
                    .createNewConfirmRequst(confirmRequest);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CompleteRequest(userRequest.requestId)),
                    ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  void _showRequestFinishedDialogMaker(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content: new Text(
              "Czy na pewno chcesz oznaczyć zamowienie jako wykonane?"),
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
              onPressed: () async {
                await DatabaseService().confirmGettingOrder(orderId);
                Navigator.popUntil(context, ModalRoute.withName('/'));
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
    for (var i = 0; i < currentRequest.request.length; i++) {
      if (checkbox_values[i] == false) {
        newCheckboxString += "0";
      } else {
        newCheckboxString += "1";
      }
    }
    prefs.setString("checkBoxString", newCheckboxString);
    prefs.setString("cachedID", currentRequest.requestId);
    cachedID = currentRequest.requestId;
    checkBoxString = newCheckboxString;
  }
}
