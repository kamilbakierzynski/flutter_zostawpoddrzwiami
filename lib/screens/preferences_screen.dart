import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';

class Preferences extends StatefulWidget {
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ustawienia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            onPressed: () => AuthService().signOut(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.directions_run,
                      color: Colors.black,
                    ),
                    Text(
                      'Wyloguj',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      Icons.directions_run,
                      color: Colors.transparent,
                    ),
                  ]),
            ),
            color: Colors.white10,
          )
        ],
      ),
    );
  }
}
