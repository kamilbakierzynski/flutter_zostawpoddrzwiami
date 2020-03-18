import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name = "Pani Janinka"; // name of request author or request handler
    String phoneNumber = "555 444 333"; // -||- phone number
    String optAddress =
        "Gierczaka 24/12"; // address visible only to person shopping

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 40,
            ),
          ),
          Text(
            phoneNumber,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                optAddress,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _launchMapsUrl(38.8951, -77.0364);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    value: false,
                    title: Column(
                      children: <Widget>[
                        Text("Mleko"),
                        Text("10l"),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    onChanged: checkbox,
                    secondary: const Icon(Icons.shopping_basket),
                    //trailing: Icon(Icons.more_vert),
                  );
                }),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));
  }

  void checkbox(bool b) {
    return;
  }

  // not working yet
  void _launchMapsUrl(double lat, double lon) async {
    print("in url func");
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
