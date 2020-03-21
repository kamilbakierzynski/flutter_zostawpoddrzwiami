import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/confirm_request.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';

class CompleteRequest extends StatefulWidget {
  final String orderId;

  CompleteRequest(this.orderId);

  @override
  createState() => _CompleteRequestState();
}

class _CompleteRequestState extends State<CompleteRequest> {
  String flareState = 'Waiting';

  bool status = false;
  int _counter = 0;
  bool showAnim = false;

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
                        Container(
                          width: 200,
                          height: 200,
                          child: FlareActor(
                            'assets/flare/Button.flr',
                            alignment: Alignment.center,
                            animation: "Waiting",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        confirmRequest.received == false
                            ? Text('Oczekuję odpowiedzi z drugiej strony')
                            : Text('Potwierdzono'),
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
                          child: FlareActor(
                            'assets/flare/Button.flr',
                            alignment: Alignment.center,
                            animation: flareState,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        confirmRequest.received == false
                            ? Text('Oczekuję na twoje potwierdzenie')
                            : Text('Potwierdzono'),
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
                      child: FlareActor(
                        'assets/flare/Button.flr',
                        alignment: Alignment.center,
                        animation: flareState,
                        fit: BoxFit.fill,
                      ),
                    )
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
