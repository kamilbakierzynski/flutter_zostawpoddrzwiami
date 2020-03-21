import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:provider/provider.dart';
class CompleteRequest extends StatefulWidget{
  @override
  createState() => _CompleteRequestState();
}

class _CompleteRequestState extends State<CompleteRequest>{
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState(){
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
              label: 'Go',
          onPressed: () => {}
          ),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    DatabaseService(uid: user.uid).saveDeviceToken(_fcm);
    return Scaffold(body: Stack(
      children: <Widget>[
        Text('PANI JANINKA', style:TextStyle(fontSize: 50,),)
      ],
    ),
    );
  }
}