import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';

class Preferences extends StatefulWidget {
  _PreferencesState createState() => _PreferencesState();

  String originalName;
  String originalSurname;

  Preferences({this.originalName, this.originalSurname});
}

class _PreferencesState extends State<Preferences> {
  String name = '';
  String surname = '';
  String email = '';

  bool showButton = false;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  @override
  void initState() {
    _controllerName.text = widget.originalName;
    _controllerSurname.text = widget.originalSurname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = UserData(name: 'Kamil', surname: 'Bakierzyński');
    return Scaffold(
      floatingActionButton: showButton
          ? FloatingActionButton.extended(
              onPressed: null,
              label: Text('Zapisz'),
              icon: Icon(Icons.save),
            )
          : FloatingActionButton.extended(
              onPressed: () => AuthService().signOut(),
              label: Text('Wyloguj'),
              icon: Icon(Icons.directions_run),
            ),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              radius: 40,
              child: Text(
                userData.name[0] + userData.surname[0],
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _controllerName,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: 'Imię',
                      ),
                      onChanged: (String text) {
                        name = text;
                        _valuesChange();
                      },
                    ),
                    TextFormField(
                      controller: _controllerSurname,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: 'Nazwisko',
                      ),
                      onChanged: (String text) {
                        surname = text;
                        _valuesChange();
                      },
                    ),
                    FutureBuilder(
                        future: AuthService().getEmail(),
                        initialData: '',
                        builder: (context, snapshot) {
                          _controllerEmail.text = snapshot.data;
                          return TextFormField(
                            enabled: false,
                            controller: _controllerEmail,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                            onChanged: (String text) {
                              email = text;
                              _valuesChange();
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  void _valuesChange() {
    if (name != widget.originalName || surname != widget.originalSurname || email != '') {
      setState(() {
        showButton = true;
      });
    } else {
      setState(() {
        showButton = false;
      });
    }
  }
}
