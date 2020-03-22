import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
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
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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

  String address = '';
  String phoneNumber = '';
  String optionalInfo = '';
  String price = '';

  bool firstFilled = false;

  ScrollController _controller = ScrollController();
  final TextEditingController _controllerAddress = TextEditingController();

  _addItem() {
    setState(() {
      requestedCart.add(Item("Blank", 0.0, "x", "Blank"));
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

  bool awaitingConfirm = false;

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
                        controller: _controllerAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          hintText: "Ulica, Numer Domu, Numer Mieszkania, Miasto",
                          labelText: "Adres",
                        ),
                        maxLines: 2,
                        minLines: 1,
//                        },
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PlacePicker(
                                  apiKey: 'AIzaSyC5Sp8b9wZSO82x1iwWB69vCMkl_2tvFiM',
                                  initialPosition: LatLng(-33.8567844, 151.213108),
                                  useCurrentLocation: true,
                                  //usePlaceDetailSearch: true,
                                  onPlacePicked: (result) {
                                    print(result.formattedAddress);
                                    print(result.addressComponents);
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _controllerAddress.text = result.formattedAddress;
                                      this.address = result.formattedAddress;
                                    });
                                  },
                                  autocompleteLanguage: "pl",
                                );
                              },
                            ),
                          );
                        },
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Wpisz numer telefonu' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_android),
                          hintText: "Wpisz swój numer telefonu",
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
                        validator: (val) =>
                        val.isEmpty ? 'Wpisz przewidywaną cenę zakupów' : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          hintText: "Wpisz przybliżoną cenę zakupów",
                          labelText: "Przybliżona cena zakupów",
                        ),
                        onChanged: (String text) {
                          this.price = text;
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
                          labelText: "Uwagi do zamówienia (Numer mieszkania)",
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
                          key: ObjectKey(requestedCart[index]),
                        );
                      }),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 5.0)),
      floatingActionButton: firstFilled
          ? FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _removeIfBlank();
                  setState(() {
                    awaitingConfirm = true;
                  });
                  List<double> coordinates = await getCurrentCoordinates();
                  UserRequest newRequest = UserRequest(
                    name: userData.name,
                    price: this.price,
                    address: address,
                    request: requestedCart,
                    status: false,
                    latitude: coordinates[0],
                    longitude: coordinates[1],
                    description: optionalInfo,
                    phoneNumber: phoneNumber,
                  );
                  bool result = await DatabaseService(uid: user.uid)
                      .createNewRequest(newRequest);
                  if (result) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      awaitingConfirm = false;
                      Toast.show('Wystąpił błąd', context);
                    });
                  }
                }
              },
              label: awaitingConfirm ? SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
              ) : Text('Wyślij'),
              icon: awaitingConfirm ? null : Icon(Icons.arrow_forward),
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
            initialValue: requestedCart[index].name != 'Blank'
                ? requestedCart[index].name.toString()
                : null,
            style: TextStyle(color: Colors.white70),
            decoration: const InputDecoration(
              icon: Icon(Icons.add_shopping_cart,color: Colors.white70),
              hintText: 'Wpisz Produkt',
              labelText: 'Produkt',
              labelStyle: TextStyle(color: Colors.white70),
              hintStyle: TextStyle(color: Colors.white70),
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
            initialValue: requestedCart[index].quantity != 0.0
                ? requestedCart[index].quantity.toString()
                : null,
            style: TextStyle(color: Colors.white70),
            decoration: const InputDecoration(
              icon: Icon(Icons.confirmation_number,color: Colors.white70),
              hintText: 'Wpisz ilość',
              labelText: 'ilość',
              labelStyle: TextStyle(color: Colors.white70),
              hintStyle: TextStyle(color: Colors.white70),
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
          initialValue: requestedCart[index].unit != 'Blank'
          ? requestedCart[index].unit.toString()
              : null,
            style: TextStyle(color: Colors.white70),
            decoration: const InputDecoration(
              icon: Icon(Icons.info,color: Colors.white70),
              hintText: 'Wpisz jednostkę',
              labelText: 'Jednostka',
              labelStyle: TextStyle(color: Colors.white70),
              hintStyle: TextStyle(color: Colors.white70),
            ),
            onChanged: (String text) {
              this.requestedCart[index].unit = text;
            },
          ),
        ],
      ),
    );
  }


}
