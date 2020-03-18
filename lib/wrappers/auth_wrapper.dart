import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/screens/home_screen.dart';
import 'package:zostawpoddrzwiami/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    if (user == null) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}
