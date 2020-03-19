import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/screens/details_screen.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zostawpoddrzwiami/models/locatioan_data_model.dart';

class HomeScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<UserRequest> userRequests =
        Provider.of<List<UserRequest>>(context);
    if (userRequests != null) {
      return FutureBuilder(
        future: _getDistanceAndSort(userRequests),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<UserRequest> sorted_userRequests = snapshot.data;
            return Scaffold(
              extendBody: true,
              backgroundColor: Colors.white,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 200,
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () => Navigator.pushNamed(context, '/preferences_screen'),
                        color: Colors.black,
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(left: 20.0, bottom: 16.0),
                      title: Text(
                        'Prośby blisko Ciebie',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      centerTitle: false,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final UserRequest request = sorted_userRequests[index];
                      return Padding(
                        padding: index != sorted_userRequests.length - 1
                            ? const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0)
                            : EdgeInsets.only(
                                top: 20.0,
                                left: 40.0,
                                right: 40.0,
                                bottom: 100.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  request.time,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFB1B1B1),
                                      fontSize: 16.0),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        size: 20.0, color: Color(0xFFB1B1B1)),
                                    Text(
                                      request.distance > 10
                                          ? request.distance
                                                  .toStringAsFixed(0) +
                                              ' km'
                                          : request.distance
                                                  .toStringAsFixed(1) +
                                              ' km',
                                      style: TextStyle(
                                          color: Color(0xFFB1B1B1),
                                          fontSize: 16.0),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFFECECEC),
                                            Colors.white
                                          ],
                                          stops: [
                                            0.3,
                                            0.9
                                          ]),
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: Offset(0, 10))
                                      ]),
                                  width: double.infinity,
                                  height: 300,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0)),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 300.0 - 80,
                                          child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: request.request.length,
                                              itemBuilder: (builder, index) {
                                                if (index == 6) {
                                                  return Center(
                                                      child: Text(
                                                    '...',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ));
                                                } else if (index < 6) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 20.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(request
                                                                .request[index]
                                                                .name),
                                                            Text(
                                                                '${request.request[index].quantity.toStringAsFixed(0)} x'),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 1.0,
                                                          width:
                                                              double.infinity,
                                                          color:
                                                              Colors.grey[300],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox.shrink();
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0))),
                                  width: double.infinity,
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              request.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.shopping_cart,
                                                  color: Color(0xFFB1B1B1),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  '~' + request.price + 'zł',
                                                  style: TextStyle(
                                                      fontSize: 21.0,
                                                      color: Color(0xFFB1B1B1)),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsScreen(request))),
                                          child: Container(
                                            width: 130,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFEDEDED),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Pomagam',
                                                  style: TextStyle(
                                                      color: Color(0xFF707070)),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Icon(Icons.arrow_forward,
                                                    color: Color(0xFF707070))
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }, childCount: sorted_userRequests.length),
                  )
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 3.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            size: 30.0,
                            color: Color(0xFF583CDF),
                          ),
                          Text('Home',
                              style: TextStyle(
                                color: Color(0xFF583CDF),
                              )),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            size: 30.0,
                            color: Colors.transparent,
                          ),
                          Text('Home',
                              style: TextStyle(
                                color: Colors.transparent,
                              )),
                        ],
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/current_request'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.shopping_basket,
                              size: 30.0,
                              color: Colors.grey[300],
                            ),
                            Text(
                              'Lista',
                              style: TextStyle(color: Colors.grey[300]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                shape: CircularNotchedRectangle(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  UserRequest test_request = UserRequest(
                    name: 'Kamil',
                    address: 'Sosnowa',
                    price: '13',
                    request: [
                      Item('Mleko', 1, '', ''),
                      Item('Jajka', 1, '', ''),
                      Item('Pomidory', 1, '', ''),
                      Item('Pieczarki', 1, '', ''),
                      Item('Kuskus', 1, '', ''),
                      Item('Papier toaletowy', 1, '', ''),
                      Item('Jagody', 1, '', ''),
                      Item('Truskawki', 1, '', ''),
                      Item('epet lq', 1, '', '')
                    ],
                    status: false,
                    latitude: 23.3248,
                    longitude: 28.6768,
                  );
                  await DatabaseService(uid: user.uid)
                      .createNewRequest(test_request);
                  Navigator.pushNamed(context, '/request');
                },
                child: Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          } else {
            return Scaffold(
              body: Center(
                child: Loading(),
              ),
            );
          }
        },
      );
    } else {
      return Scaffold(
        body: Center(
          child: Loading(),
        ),
      );
    }
  }

  Future<List<UserRequest>> _getDistanceAndSort(
      List<UserRequest> userRequests) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await Future.wait(userRequests.map((request) async {
      request.distance = await Location(
              latitude: position.latitude, longitude: position.longitude)
          .calculateDistance([request.latitude, request.longitude]);
    }));
//    userRequests.forEach((request) async {
//      request.distance = await Location(
//              latitude: position.latitude, longitude: position.longitude)
//          .calculateDistance([request.latitude, request.longitude]);
//    });
    userRequests.sort((a, b) => a.distance.compareTo(b.distance));
    return userRequests;
  }
}
