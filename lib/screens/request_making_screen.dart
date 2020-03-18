import 'package:flutter/material.dart';
class RequestMakingScreen{



  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _createTile(context, 'Lista', Icons.message, _action1),
              _createTile(context, 'Adres', Icons.location_city, _action2),
              _createTile(context, 'Platnosc', Icons.payment, _action3),
            ],
      ),
    );
  }




  ListTile _createTile(BuildContext context, String name, IconData icon, Function action){
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      subtitle: Text("Jakis tytulik"),
      isThreeLine: true,
      onTap: (){
        Navigator.pop(context);
        action();
      },
    );
  }

  _action1(){
    print('action 1');
  }

  _action2(){
    print('action 2');
  }

  _action3(){
    print('action 3');
  }



}