import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
class RequestMakingScreen extends StatelessWidget{


  List<String>  requestedCart = new List<String>();

  String tempProduct;
  String address;
  String name;
  String surname;
  String description;
  int itemCount;

  Widget build(BuildContext context){
    return Scaffold(
      body: AnimatedContainer(
        color: Colors.white,
        duration: Duration(seconds: 2),
        padding: EdgeInsets.all(20),
        child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                createFieldName(context),
                createFieldSurname(context),
                createFieldAddress(context),
                createFieldDescription(context),
                createTilesList(context),
              ],
        ),
      ),
    );

  }

  TextFormField createFieldCart(BuildContext context){
    return TextFormField(
       decoration: const InputDecoration(
         icon: Icon(Icons.add_shopping_cart),
         hintText: 'Wypisz przedmioty ktorych potrzebujesz',
         labelText: 'Koszyk',
       ),
      onFieldSubmitted: (String text){
         _addToCart(text);
      }
    );
  }

  TextFormField createFieldName(BuildContext context){
    return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person_add),
          hintText: 'Wpisz swoje imie',
          labelText: 'Imie',
        ),
        onFieldSubmitted: (String text){
          _addName(text);
        }
    );
  }

  TextFormField createFieldSurname(BuildContext context){
    return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person_add),
          hintText: 'Wpisz swoje nazwisko',
          labelText: 'Nazwisko',
        ),
        onFieldSubmitted: (String text){
          _addSurname(text);
        }
    );
  }

  TextFormField createFieldAddress(BuildContext context){
    return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.location_city),
          hintText: 'Wpisz swoj adres',
          labelText: 'Adres',
        ),
        onFieldSubmitted: (String text){
          _addAddress(text);
        }
    );
  }

  TextFormField createFieldDescription(BuildContext context){
    return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.note_add),
          hintText: 'Krotki opis',
          labelText: 'opis',
        ),
        onFieldSubmitted: (String text){
          _addDescritption(text);
        }
    );
  }


  ListTile createTilesList(BuildContext context)
  {
    return ListTile(
      leading: Icon(Icons.add_shopping_cart),
      title : Text("Koszyk"),
    );
  }


  _addToCart(String text ){
    requestedCart.add(text);
    print(text);
  }

  _addName(String text){
    name = text;
  }

  _addSurname(String text){
    surname = text;
  }

  _addAddress(String text){
    address = text;
  }

  _addDescritption(String text){
    description = text;
  }

  updateListLength(List<String> cart)
  {
    itemCount = cart.length;
  }


}