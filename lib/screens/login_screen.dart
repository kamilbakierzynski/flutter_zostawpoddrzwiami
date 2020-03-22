import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
    ),
  );

  bool _loadingInProgress;
  final _formLoginKey = GlobalKey<FormState>();
  final _formRegisterKey = GlobalKey<FormState>();
  final _pageViewController = PageController();

  String email = '';
  String password = '';

  String name = '';
  String surname = '';
  String confirmPassword = '';

  int index = 0; // 0 - login, 1 - register

  @override
  void initState() {
    super.initState();
    _loadingInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(
            'Zostaw Pod Drzwiami',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: Text('Logowanie',
                      style: TextStyle(
                        color:
                            index == 0 ? Color(0xFF583CDF) : Colors.grey[400],
                      )),
                  onPressed: () {
                    setState(() {
                      email = '';
                      password = '';
                      index = 0;
                      _pageViewController.jumpToPage(
                        0,
                      );
                    });
                  },
                ),
                FlatButton(
                  child: Text('Rejestracja',
                      style: TextStyle(
                        color:
                            index == 1 ? Color(0xFF583CDF) : Colors.grey[400],
                      )),
                  onPressed: () {
                    setState(() {
                      email = '';
                      password = '';
                      name = '';
                      surname = '';
                      confirmPassword = '';
                      index = 1;
                      _pageViewController.jumpToPage(
                        1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          shape: CircularNotchedRectangle(),
        ),
        floatingActionButton: index == 0 ? _fABLogin() : _fABRegister(),
        floatingActionButtonLocation:
            MediaQuery.of(context).viewInsets.bottom != 0
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.white,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageViewController,
          children: <Widget>[_loginScreen(), _registerScreen()],
        ));
  }

  Widget _fABRegister() {
    return FloatingActionButton.extended(
        elevation: 10,
        onPressed: () async {
          FocusScope.of(context).unfocus();
          setState(() {
            _loadingInProgress = true;
          });
          if (_formRegisterKey.currentState.validate()) {
            print(name);
            print(surname);
            FirebaseUser result = await AuthService()
                .registerWithEmailAndPassword(email, password, name, surname);
            if (result == null) {
              Toast.show('Wystąpił błąd.', context);
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
            : Text('Zarejestruj się'));
  }

  Widget _registerScreen() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                            key: _formRegisterKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                TextFormField(
                                    validator: (val) =>
                                        val.isEmpty || !val.contains('@')
                                            ? 'Wpisz email'
                                            : null,
                                    onChanged: (val) {
                                      email = val;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Email')),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Wpisz hasło' : null,
                                    onChanged: (val) {
                                      password = val;
                                    },
                                    obscureText: true,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Hasło')),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    validator: (val) => val != password
                                        ? 'Hasła nie są takie same'
                                        : null,
                                    onChanged: (val) {
                                      confirmPassword = val;
                                    },
                                    obscureText: true,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Potwierdź hasło')),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Wpisz imię' : null,
                                    onChanged: (val) {
                                      name = val;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Imię')),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Wpisz nazwisko' : null,
                                    onChanged: (val) {
                                      surname = val;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Nazwisko')),
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
                height: 20.0,
              ),
            ]),
      ),
    );
  }

  Widget _fABLogin() {
    return FloatingActionButton.extended(
        elevation: 10,
        onPressed: () async {
          FocusScope.of(context).unfocus();
          setState(() {
            _loadingInProgress = true;
          });
          if (_formLoginKey.currentState.validate()) {
            FirebaseUser result =
                await AuthService().signInWithEmailAndPassword(email, password);
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
            : Text('Zaloguj się'));
  }

  Widget _loginScreen() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                              horizontal: 30.0, vertical: 0.0),
                          child: Form(
                            key: _formLoginKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/login-app.png'), fit: BoxFit.fitHeight,)),
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
              SizedBox(
                height: 20.0,
              ),
            ]),
      ),
    );
  }
}
