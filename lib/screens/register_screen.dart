import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Color(0xFF243F38)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black12, width: 2.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 2.0),
    ),
  );

  bool _loadingInProgress;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String emailReset = '';

  @override
  void initState() {
    super.initState();
    _loadingInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            setState(() {
              _loadingInProgress = true;
            });
            if (_formKey.currentState.validate()) {
              FirebaseUser result = await AuthService()
                  .signInWithEmailAndPassword(email, password);
              if (result == null) {
                Toast.show(
                    'Wystąpił błąd. Sprawdź ponownie dane logowania.', context);
                setState(() {
                  _loadingInProgress = false;
                });
              }
            } else {
              setState(() {
                _loadingInProgress = false;
              });
            }
          },
          label: _loadingInProgress
              ? SpinKitThreeBounce(
            color: Colors.white,
            size: 20,
          )
              : Text('Zarejestruj się')),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Zostaw Pod Drzwiami',
                    style: TextStyle(color: Colors.amber, fontSize: 22.0),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 40.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    TextFormField(
                                        validator: (val) =>
                                        val.isEmpty || !val.contains('@')
                                            ? 'Wpisz email'
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        decoration: textInputDecoration
                                            .copyWith(labelText: 'email')),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                        validator: (val) =>
                                        val.isEmpty ? 'Wpisz hasło' : null,
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                        obscureText: true,
                                        decoration: textInputDecoration
                                            .copyWith(labelText: 'hasło')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Zarejestruj się',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Zapomniałeś hasła?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
