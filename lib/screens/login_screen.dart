import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Color(0xFF243F38)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black12, width: 2.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 2.0),
    ),
  );

  bool _loadingInProgress;
  final GlobalKey _formKey = GlobalKey<FormState>();

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
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Zostaw Pod Drzwiami',
                    style: TextStyle(color: Colors.blue, fontSize: 22.0),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Wpisz email' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                                labelText: 'email')),
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
                            decoration: textInputDecoration.copyWith(
                                labelText: 'hasło')),
                        RaisedButton(
                          child: Text('Zaloguj'),
                          onPressed: () async {
                            setState(() {
                              _loadingInProgress = true;
                            });
                            User result = await AuthService().signInAnon();
                            setState(() {
                              _loadingInProgress = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          _loadingInProgress
              ? Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black87,
                    ),
                    Center(
                      child: Loading(),
                    )
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
