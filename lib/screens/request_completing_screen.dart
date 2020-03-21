import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                                size: 70,
                                lineWidth: 2.0,
                              )
                            : SizedBox.shrink(),
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
                      'Potwierdź dostarczenie',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitRing(
                          color: Color(0xFF583CDF),
                          size: 70,
                          lineWidth: 2.0,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text('Oczekuję odpowiedzi z drugiej strony'),
                      ],
                    ),
                  ));
            }
          } else {
            return Loading();
          }
        });
  }
}
