import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/confirm_request.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';

class CompleteRequest extends StatefulWidget {
  final String orderId;

  CompleteRequest(this.orderId);

  @override
  createState() => _CompleteRequestState();
}

class _CompleteRequestState extends State<CompleteRequest> {
  String flareState = 'Waiting';

  bool status = false;
  bool showAnim = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return StreamBuilder<ConfirmRequest>(
        stream: DatabaseService(orderId: widget.orderId).confirmRequestData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ConfirmRequest confirmRequest = snapshot.data;
            if (confirmRequest.takerUid == user.uid) {
              return Scaffold(
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Text(
                      'Potwierdź dostarczenie',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        confirmRequest.received == false
                            ? SpinKitRing(
                                color: Color(0xFF583CDF),
                                size: 80,
                              )
                            : Icon(
                                Icons.check,
                                color: Colors.green[600],
                                size: 150,
                              ),
                        SizedBox(
                          height: 40,
                        ),
                        confirmRequest.received == false
                            ? Text('Oczekuję odpowiedzi z drugiej strony',
                                style: TextStyle(color: Colors.grey[500]))
                            : Text(''),
                        confirmRequest.received == true
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.grey[100],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(
                                            Icons.credit_card,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Container(
                                              width: 100,
                                              height: 60,
                                              child: Image.asset(
                                                'assets/images/paypal.png',
                                              )),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      'Kliknij, żeby otrzymać zapłatę za zakupy.',
                                      style: TextStyle(color: Colors.grey[500]),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ));
            } else {
              return Scaffold(
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Text(
                      'Potwierdź odebranie',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      _showRequestFinishedDialogMaker(widget.orderId);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: Text('Potwierdź odebranie'),
                    backgroundColor: Colors.green[600],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 200,
                            height: 200,
                            child: SpinKitRing(
                              color: Color(0xFF583CDF),
                              size: 80,
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        confirmRequest.received == false
                            ? Text('Oczekuję na twoje potwierdzenie',
                                style: TextStyle(color: Colors.grey[500]))
                            : Text('Potwierdzono'),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ));
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  'Zamówienie w trakcie realizacji',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 200,
                        height: 200,
                        child: SpinKitRing(
                          color: Color(0xFF583CDF),
                          size: 80,
                        ))
                  ],
                ),
              ),
            );
          }
        });
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
}
