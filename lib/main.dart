import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:zostawpoddrzwiami/screens/current_request.dart';
=======
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
>>>>>>> a912c29718f5803e38785e4f1685bae7e1ef8c2c
import 'package:zostawpoddrzwiami/screens/details_screen.dart';
import 'package:zostawpoddrzwiami/screens/home_screen.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/wrappers/auth_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
        title: 'Zostaw Pod Drzwiami',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF583CDF), elevation: 5)),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/details': (context) => DetailsScreen()
        });
=======
    return MultiProvider(
      providers: [StreamProvider<User>.value(value: AuthService().user,)],
      child: MaterialApp(
          title: 'Zostaw Pod Drzwiami',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF583CDF), elevation: 5)),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => AuthWrapper(),
            '/details': (context) => DetailsScreen()
          }),
    );
>>>>>>> a912c29718f5803e38785e4f1685bae7e1ef8c2c
  }
}
