import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/screens/current_request.dart';
import 'package:zostawpoddrzwiami/screens/details_screen.dart';
import 'package:zostawpoddrzwiami/screens/preferences_screen.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';
import 'package:zostawpoddrzwiami/wrappers/auth_wrapper.dart';
import 'package:zostawpoddrzwiami/screens/request_making_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<User>.value(value: AuthService().user),
    ], child: GestureDetector(child: MaterialAppLoggedUser(), onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },));
  }
}

class MaterialAppLoggedUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    if (user == null) {
      print('Not logged in');
      return MaterialApp(
          title: 'Zostaw Pod Drzwiami',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF583CDF), elevation: 5)),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => AuthWrapper(),
          });
    } else {
      print('Logged in');
      return MultiProvider(
        providers: [
          StreamProvider<List<UserRequest>>.value(
              value: DatabaseService().requestData),
          StreamProvider<UserData>.value(
              value: DatabaseService(uid: user.uid).userData),
        ],
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
              '/request': (context) => RequestMakingScreen(),
              '/current_request': (context) => CurrentRequest(),
              '/preferences_screen': (context) => Preferences()
            }),
      );
    }
  }
}
