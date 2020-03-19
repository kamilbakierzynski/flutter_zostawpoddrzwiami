import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';

class RequestMakingScreen  extends StatefulWidget {
@override
_State createState() {
  _State firstState = _State();
 // firstState.requestedCart.add(firstState.first);
  firstState.requestedCart.add(firstState.second);
  return firstState;
  }
}

class _State extends State<RequestMakingScreen>{
  @override

  static Item first = Item('mleko',3);
  Item second = Item('maslanka',4);

  List<Item>  requestedCart = [first];

  String tempProduct = '';
  String address = '';
  String name = '';
  String surname = '';
  String description = '';
  int itemCount = 0;
  bool isListClicked = false;
  int value = 1;




  _addItem() {
    setState(() {
      value = value + 1;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: ListView.builder(
          itemCount: this.value,
          itemBuilder: (context, index) => this._buildRow(index)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }

  _buildRow(int index) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xFF583CDF).withOpacity(1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 0.5, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                10.0, // vertical, move down 10
              ),
            )
          ],

      ),
      child: Column(
        children: <Widget>[
          TextFormField(
              decoration: const InputDecoration(
              icon: Icon(Icons.add_shopping_cart),
                hintText: 'Wpisz Produkt',
                labelText: 'Produkt',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
            icon: Icon(Icons.confirmation_number),
            hintText: 'Wpisz ilosc',
            labelText: 'ilosc',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
            icon: Icon(Icons.person_add),
            hintText: 'Wpisz uwagi',
            labelText: 'Uwagi',
            ),
          ),
        ],
      ),
    );
  }




//  Widget build(BuildContext context){
//    return Scaffold(
//      body: AnimatedContainer(
//        color: Colors.white,
//        duration: Duration(seconds: 2),
//        padding: EdgeInsets.all(20),
//        child: Column(
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                createFieldName(context),
//                createFieldSurname(context),
//                createFieldAddress(context),
//                createFieldDescription(context),
//                AnimatedContainer(
//                  width: isListClicked ? 10 : 200,
//                  height: isListClicked ? 10 : 300,
//                  color: Colors.lightBlue,
//                  duration: Duration(seconds: 1),
//
//                  child: ListView.builder(
//                      itemCount: 2,
//                      itemBuilder: (context,index){
//                        return Card(
//                          child: ListTile(
//                            title: Text(requestedCart[index].name ?? "doopa"),
//                            subtitle: Text(requestedCart[index].name ?? "doopsko"),
//                            onTap: (){
//                              setState(() {
//                                Item temp = requestedCart[index];
//                                requestedCart.removeAt(index);
//                                requestedCart.insert(0, temp);
//                              });
//
//                            },
//                          ),
//                        );
//                      }
//                  ),
//                ),
//
//
//              ],
//        ),
//      ),
//    );
//
//  }
//
//  TextFormField createFieldCart(BuildContext context){
//    return TextFormField(
//       decoration: const InputDecoration(
//         icon: Icon(Icons.add_shopping_cart),
//         hintText: 'Wypisz przedmioty ktorych potrzebujesz',
//         labelText: 'Koszyk',
//       ),
//      onFieldSubmitted: (String text){
//         _addToCart(text);
//      }
//    );
//  }
//
//  TextFormField createFieldName(BuildContext context){
//    return TextFormField(
//        decoration: const InputDecoration(
//          icon: Icon(Icons.person_add),
//          hintText: 'Wpisz swoje imie',
//          labelText: 'Imie',
//        ),
//        onFieldSubmitted: (String text){
//          _addName(text);
//        }
//    );
//  }
//
//  TextFormField createFieldSurname(BuildContext context){
//    return TextFormField(
//        decoration: const InputDecoration(
//          icon: Icon(Icons.person_add),
//          hintText: 'Wpisz swoje nazwisko',
//          labelText: 'Nazwisko',
//        ),
//        onFieldSubmitted: (String text){
//          _addSurname(text);
//        }
//    );
//  }
//
//  TextFormField createFieldAddress(BuildContext context){
//    return TextFormField(
//        decoration: const InputDecoration(
//          icon: Icon(Icons.location_city),
//          hintText: 'Wpisz swoj adres',
//          labelText: 'Adres',
//        ),
//        onFieldSubmitted: (String text){
//          _addAddress(text);
//        }
//    );
//  }
//
//  TextFormField createFieldDescription(BuildContext context){
//    return TextFormField(
//        decoration: const InputDecoration(
//          icon: Icon(Icons.note_add),
//          hintText: 'Krotki opis',
//          labelText: 'opis',
//        ),
//        onFieldSubmitted: (String text){
//          _addDescritption(text);
//        }
//    );
//  }


//  Widget listwidget(BuildContext context)
//  {
//    return Scaffold(
//      body: ListView.builder(
//        itemCount: requestedCart.length + 1,
//        itemBuilder: (context,index){
//          return Card(
//            child: ListTile(
//              title:TextField(
//
//              ),
//              subtitle: TextField(
//
//              ),
//
//            ),
//          );
//        }
//      ),
//    );
//  }

//
//  _addToCart(String text ){
//
//    print(text);
//  }
//
//  _addName(String text){
//    name = text;
//  }
//
//  _addSurname(String text){
//    surname = text;
//  }
//
//  _addAddress(String text){
//    address = text;
//  }
//
//  _addDescritption(String text){
//    description = text;
//  }




}

