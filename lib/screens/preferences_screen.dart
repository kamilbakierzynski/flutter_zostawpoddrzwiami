import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';
class Preferences extends StatefulWidget
{
  _PreferencesState createState() => _PreferencesState();
}
class _PreferencesState extends State<Preferences>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children:<Widget>[
            Icon(Icons.settings, color: Colors.black,),
            Text('Ustawienia',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0,),textAlign: TextAlign.left,)
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          RaisedButton(
            onPressed: ()=> Navigator.pushNamed(context, '/preferences_screen'),
            child: Row(
              children: <Widget>[
                Icon(Icons.directions_run, color: Colors.black,),
                Text('Wyloguj', style: TextStyle(fontSize: 20.0,), textAlign: TextAlign.center,),
              ]
            ),
            color: Colors.white10,
          )
        ],
      ),
    );
  }
}