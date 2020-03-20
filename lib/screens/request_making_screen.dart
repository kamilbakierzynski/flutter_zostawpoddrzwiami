import 'dart:async';
import 'package:zostawpoddrzwiami/services/database_service.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:geolocator/geolocator.dart';
import '../models/request_model.dart';

class RequestMakingScreen extends StatefulWidget {
  @override
  _State createState() {
    _State firstState = _State();
    return firstState;
  }
}

class _State extends State<RequestMakingScreen> {
  List<Item> requestedCart = [Item("Blank", 0.0, "Blank", "Blank")];
  final _formKey = GlobalKey<FormState>();

//  String tempProduct = '';
  String address = '';
  String phoneNumber = '';
  String optionalInfo = '';

//  String name = '';
//  String surname = '';
//  String description = '';
//  int itemCount = 0;
//  bool isListClicked = false;

  bool firstFilled = false;

  ScrollController _controller = ScrollController();

  _addItem() {
    setState(() {
      requestedCart.add(Item("Blank", 0.0, "Blank", "Blank"));
    });
  }

  _removeIfBlank()
  {
    for(int i = 0 ; i < requestedCart.length;i++)
    {
      if(requestedCart[i].name == "Blank")
      {
        requestedCart.removeAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // DB providers
    final User user = Provider.of<User>(context);
    final UserData userData = Provider.of<UserData>(context);
    final List<UserRequest> userRequests =
        Provider.of<List<UserRequest>>(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Stwórz nową prośbę',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) => val.isEmpty ? 'Wpisz adres' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          hintText: "Wpisz swoj adres",
                          labelText: "Adres",
                        ),
                        maxLines: 2,
                        minLines: 1,
                        onChanged: (String text) {
                          this.address = text;
                        },
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Wpisz numer telefonu' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_android),
                          hintText: "Wpisz swoj numer telefonu",
                          labelText: "Numer telefonu",
                        ),
                        onChanged: (String text) {
                          this.phoneNumber = text;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.description),
                          hintText: "Opcjonalnie",
                          labelText: "Uwagi do zamowienia",
                        ),
                        onChanged: (String text) {
                          this.optionalInfo = text;
                        },
                        maxLines: 6,
                        minLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: requestedCart.length + 1,
                      itemBuilder: (context, index) {
                        if (index == requestedCart.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 60.0,
                                  top: requestedCart.length == 0 ? 20.0 : 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Material(
                                  color: Colors.grey[300],
                                  child: InkWell(
                                    onTap: () {
                                      _addItem();
                                      Timer(
                                          Duration(milliseconds: 50),
                                          () => _controller.animateTo(
                                              _controller
                                                  .position.maxScrollExtent,
                                              curve: Curves.easeInOut,
                                              duration:
                                                  Duration(milliseconds: 500)));
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        '+',
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (_) {
                            setState(() {
                              requestedCart.removeAt(index);
                            });
                          },
                          child: _buildRow(index),
                          key: Key(requestedCart[index].toString()),
                        );
                      }),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 30.0)),
      floatingActionButton: firstFilled
          ? FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  List<double> coordinates = await getCurrentCoordinates();
                  UserRequest newRequest = UserRequest(
                    name: userData.name,
                    price: '13',
                    address: address,
                    request: requestedCart,
                    status: false,
                    latitude: coordinates[0],
                    longitude: coordinates[1],
                  );
                  await DatabaseService(uid: user.uid)
                      .createNewRequest(newRequest);
                }
              },
              label: Text('Wyślij'),
              icon: Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  Future<List<double>> getCurrentCoordinates() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<double> coordinates = [];
    coordinates.add(position.latitude);
    coordinates.add(position.longitude);
    return coordinates;
  }

  Widget _buildRow(int index) {
    const InputDecoration textFormFieldStyle = InputDecoration(
      icon: Icon(
        Icons.add_shopping_cart,
        color: Colors.white70,
      ),
      hintText: 'Wpisz Produkt',
      labelText: 'Produkt',
      labelStyle: TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white70),
    );
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
            onChanged: (String text) {
              if (requestedCart[0].name != 'Blank') {
                setState(() {
                  firstFilled = true;
                });
              }
              this.requestedCart[index].name = text;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.confirmation_number),
              hintText: 'Wpisz ilosc',
              labelText: 'ilosc',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onChanged: (String text) {
              this.requestedCart[index].quantity = double.parse(text);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.info),
              hintText: 'Wpisz jednostke',
              labelText: 'jednostka',
            ),
            onChanged: (String text) {
              this.requestedCart[index].unit = text;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.warning),
              hintText: 'Wpisz uwagi',
              labelText: 'Uwagi',
            ),
            onChanged: (String text) {
              this.requestedCart[index].description = text;
            },
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
