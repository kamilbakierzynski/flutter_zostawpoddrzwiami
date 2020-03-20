import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/screens/details_screen.dart';

class HomeRequestsList extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final List<UserRequest> sorted_userRequests;

  HomeRequestsList(this.sorted_userRequests);

  @override
  Widget build(BuildContext context) {
    if (sorted_userRequests.length != 0) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final UserRequest request = sorted_userRequests[index];
          return Padding(
            padding: index != sorted_userRequests.length - 1
                ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)
                : EdgeInsets.only(
                    top: 20.0, left: 40.0, right: 40.0, bottom: 100.0),
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
                              ? request.distance.toStringAsFixed(0) + ' km'
                              : request.distance.toStringAsFixed(1) + ' km',
                          style: TextStyle(
                              color: Color(0xFFB1B1B1), fontSize: 16.0),
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
                              colors: [Color(0xFFECECEC), Colors.white],
                              stops: [0.3, 0.9]),
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
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: request.request.length,
                                  itemBuilder: (builder, index) {
                                    if (index == 6) {
                                      return Center(
                                          child: Text(
                                        '...',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900),
                                      ));
                                    } else if (index < 6) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 20.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(request
                                                    .request[index].name),
                                                Text(
                                                    '${request.request[index].quantity.toStringAsFixed(0)} x'),
                                              ],
                                            ),
                                            Container(
                                              height: 1.0,
                                              width: double.infinity,
                                              color: Colors.grey[300],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  child: AutoSizeText(
                                    request.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0),
                                  ),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Material(
                                color: Color(0xFFEDEDED),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsScreen(request))),
                                  child: Container(
                                    width: 130,
                                    height: 40,
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
      );
    } else {
      return SliverToBoxAdapter(
          child: Center(
        child: Text(
          'Uff... \n aktualnie nikt nie potrzebuje pomocy.',
          style: TextStyle(color: Colors.grey[600], fontSize: 17),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }
}
