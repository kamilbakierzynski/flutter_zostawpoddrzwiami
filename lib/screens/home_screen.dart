import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                color: Colors.black,
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20.0, bottom: 16.0),
              title: Text(
                'Ogłoszenia blisko Ciebie',
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
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [Color(0xFF0187F8), Color(0xFF0169F0)],
                          stops: [0.0, 1.0]),
                      borderRadius: BorderRadius.circular(20.0)),
                  width: 100,
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Janina',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0),
                            ),
                            Text(
                              '1.3 km',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 10, bottom: 20.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    'Mleko',
                                    'Frytki',
                                    'Pomidor',
                                    'Ser'
                                  ].map<Widget>((item) {
                                    return Text(
                                      item,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18.0),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '~15 zł',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
//                                      Text(
//                                        'Pomagam!',
//                                        style: TextStyle(
//                                            fontWeight: FontWeight.w500,
//                                            fontSize: 16),
//                                      ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30.0,
                                      color: Colors.blueGrey,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: 100),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
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
              Column(
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
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
