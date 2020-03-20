import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:shortid/shortid.dart';
import 'package:intl/intl.dart';

import '../models/current_user_request_model.dart';
import '../models/request_model.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userDataCollection =
      Firestore.instance.collection('users');
  final CollectionReference itemsDataCollection =
      Firestore.instance.collection('data');
  final CollectionReference requestDataCollection =
      Firestore.instance.collection('requests');
  final CollectionReference appDataCollection =
      Firestore.instance.collection('app-data');

  Future createUserData(String name) async {
    return await userDataCollection.document(uid).setData({
      'name': name,
    });
  }

  Stream<UserData> get userData {
    return userDataCollection.document(uid).snapshots().map(_userFromSnapshot);
  }

  Stream<List<UserRequest>> get requestData {
    return requestDataCollection.snapshots().map(_requestFromSnapshot);
  }

  Stream<List<CurrentUserRequest>> get userRequests {
    final CollectionReference currentUserRequestCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('requests');
    return currentUserRequestCollection
        .snapshots()
        .map(_currentUserRequestFromSnapshot);
  }

  List<UserRequest> _requestFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc != null) {
        List<dynamic> items = doc.data['order'];
        List<Item> itemsFormated = [];
        items.forEach((item) {
          itemsFormated.add(Item(item.toString().split('#@?')[0], double.parse(item.toString().split('#@?')[1]), item.toString().split('#@?')[2], item.toString().split('#@?')[3]));
        });
        print(itemsFormated[0].name);
        return UserRequest(
          name: doc.data["name"] ?? '',
          address: doc.data["name"] ?? '',
          request: itemsFormated ?? [Item('',0,'', '')],
          requestId: doc.data["requestId"] ?? '',
          price: doc.data["price"] ?? '',
          status: doc.data["status"] ?? false,
          time: doc.data["time"] != null
              ? formatTime(doc.data['time'].toDate().toString())
              : '',
          longitude: doc.data["longitude"] ?? 0.0,
          latitude: doc.data["latitude"] ?? 0.0,
        );
      } else {
        return null;
      }
    }).toList();
  }

  List<CurrentUserRequest> _currentUserRequestFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc != null) {
        List<Item> itemsFormated = [];
        if (doc.data['order'] != null) {
          List<dynamic> items = doc.data['order'];
        items.forEach((item) {
          itemsFormated.add(Item(item.toString().split('#@?')[0], double.parse(item.toString().split('#@?')[1]), item.toString().split('#@?')[2], item.toString().split('#@?')[3]));
        });
        }
        return CurrentUserRequest(
          name: doc.data["name"] ?? '',
          address: doc.data["address"] ?? '',
          request: itemsFormated ?? [Item('',0,'', '')],
          requestId: doc.data["requestId"] ?? '',
          price: doc.data["price"] ?? '',
          status: doc.data["status"] ?? false,
        );
      } else {
        return null;
      }
    }).toList();
  }

  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data != null) {
      return UserData(uid: uid, name: snapshot.data['name'] ?? 'Janina');
    } else {
      return null;
    }
  }

  Future createNewRequest(UserRequest request) async {
    final id = shortid.generate();
    List<String> output = [];
    request.request.forEach((item) {
      output.add("${item.name}#@?${item.quantity.toString()}#@?${item.unit}#@?${item.description}");
    });
    await requestDataCollection.document(id).setData({
      'name': request.name,
      'customer': uid,
      'requestId': id,
      'order': output,
      'status': request.status,
      'price': request.price,
      'address': request.address,
      'latitude': request.latitude,
      'longitude': request.longitude,
      'time': Timestamp.now()
    });
    await userDataCollection
        .document(uid)
        .collection('requests')
        .document(id)
        .setData({
      'name': request.name,
      'customer': uid,
      'requestId': id,
      'order': output,
      'status': request.status,
      'price': request.price,
      'address': request.address,
      'time': Timestamp.now()
    });
    return true;
  }
  Future returnRequest(CurrentUserRequest request) async {
    List<String> output = [];
    request.request.forEach((item) {
      output.add("${item.name}#@?${item.quantity.toString()}#@?${item.unit}#@?${item.description}");
    });
    await requestDataCollection.document(request.requestId).setData({
      'name': request.name,
      'customer': request.customer,
      'requestId': request.requestId,
      'order': output,
      'status': false,
      'price': request.price,
      'address': request.address,
      'latitude': request.latitude,
      'longitude': request.longitude,
      'time': request.time,
    });
    return true;
  }

  String formatTime(String requestTime) {
    String timeNow = DateTime.now().toString();
    if (requestTime.split(" ")[0].split('-')[2] ==
        timeNow.split(" ")[0].split('-')[2]) {
      return requestTime.split(' ')[1].split('.')[0].substring(0, 5);
    } else {
      return requestTime.split(' ')[0];
    }
  }
}
