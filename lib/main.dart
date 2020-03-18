import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/screens/current_request.dart';
import 'package:zostawpoddrzwiami/screens/details_screen.dart';
import 'package:zostawpoddrzwiami/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zostaw Pod Drzwiami',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF583CDF), elevation: 5)),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => CurrentRequest(),
          '/details': (context) => DetailsScreen()
        });
  }
}
