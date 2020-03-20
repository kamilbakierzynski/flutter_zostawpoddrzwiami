import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class DetailsScreen extends StatefulWidget {
  final UserRequest request;

  DetailsScreen(this.request);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // providers
    User user = Provider.of<User>(context);
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
            title: Text(
              'Prośba numer ' + widget.request.requestId,
              style: TextStyle(color: Colors.black),
            ),
            expandedHeight: 300,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.request.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dodano: ${widget.request.time}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          Text('Koszt: ~${widget.request.price}zł',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              'Adres: ${widget.request.address.replaceAll(RegExp('[A-Z|a-z|0-9]'), '*')}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              'Opis: Witam, potrzebuje pomocy z zakupami. Jestem osobą starszą i boje się chodzić do sklepu.',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 15.0,
          )),
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: Delegate(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 10.0, bottom: 20.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              Item current_item = widget.request.request[index];
              return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(current_item.name),
                    subtitle: (current_item.description != null)
                        ? Text(current_item.description)
                        : null,
                    trailing:
                        Text(current_item.quantity.toStringAsFixed(0) + 'x'),
                  ));
            }, childCount: widget.request.request.length),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 60.0,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
         await DatabaseService(uid: user.uid).acceptRequest(widget.request);
         Navigator.of(context).pop();
        },
        icon: Icon(Icons.thumb_up),
        label: Text('Pomagam!'),
      ),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Center(
          child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        decoration: overlapsContent
            ? BoxDecoration(
                color: Color(0xFF583CDF),
                borderRadius: BorderRadius.circular(50.0))
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Lista potrzebnych rzeczy',
            style: overlapsContent
                ? TextStyle(fontWeight: FontWeight.w800, color: Colors.white)
                : TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ));

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
