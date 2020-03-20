import 'dart:ffi';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/screens/details_screen.dart';
import 'package:zostawpoddrzwiami/screens/preferences_screen.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';
import 'package:zostawpoddrzwiami/widgets/home_requests_list.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zostawpoddrzwiami/models/locatioan_data_model.dart';

import '../models/current_user_request_model.dart';
import '../models/current_user_request_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<UserRequest> userRequests =
        Provider.of<List<UserRequest>>(context);
    final List<CurrentUserRequest> currentUserRequestList =
        Provider.of<List<CurrentUserRequest>>(context);
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
                        onPressed: () {
                          final UserData userData =
                              Provider.of<UserData>(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Preferences(
                                        originalName: userData.name,
                                        originalSurname: userData.surname,
                                      )));
                        },
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
                  HomeRequestsList(sorted_userRequests),
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
                            Stack(
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_basket,
                                  size: 30.0,
                                  color: Colors.grey[400],
                                ),
                                currentUserRequestList.length > 0
                                    ? Positioned(
                                        top: 20,
                                        left: 20,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: Center(
                                              child: Text(
                                            '1',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 7),
                                          )),
                                        ),
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                            Text(
                              'Lista',
                              style: TextStyle(color: Colors.grey[400]),
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
                onPressed: () {
                  if(currentUserRequestList.length >=1)
                  {
                  print('DIALOG ALERT');
                  }
                  else Navigator.pushNamed(context, '/request');},
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
