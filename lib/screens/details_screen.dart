import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            floating: false,
            pinned: true,
            centerTitle: true,
            title: Text('Detale', style: TextStyle(color: Colors.black),),
            expandedHeight: 200,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  Align(alignment: Alignment.bottomLeft, child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Text(
                      'Janina',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ),),
            ),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 15.0,
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Data dodania: 12:34'),
                  Text('Koszt: ~15zł'),
                  Text('Adres: Ukryty'),
                  Text(
                      'Opis: Witam, potrzebuje pomocy z zakupami. Jestem osobą starszą i boje się chodzić do sklepu.')
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Mleko'),
                    subtitle: Text('Bez laktozy'),
                    trailing: Text('2x'),
                  ));
            }, childCount: 10),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 60.0,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.thumb_up),
        label: Text('Pomagam'),
      ),
    );
  }
}
