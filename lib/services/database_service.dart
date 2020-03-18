import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:shortid/shortid.dart';
class DatabaseService
{
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

  Future createUserData(String name) async
  {
    return await userDataCollection.document(uid).setData({'name': name,});
  }
  Stream<UserData> get userData {
    return userDataCollection.document(uid).snapshots().map(_userFromSnapshot);
  }
  Stream<List<UserRequest>> get userRequests {
    final CollectionReference userOrdersCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('request');
    return userOrdersCollection.snapshots().map(_requestFromSnapshot);
  }
  List<UserRequest> _requestFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserRequest(
        name: doc.data["name"] ?? '',
        address: doc.data["name"] ?? '',
        request: doc.data["request"] ?? [],
        requestId: doc.data["requestId"] ?? '',
        price: doc.data["price"] ?? '',
        status: doc.data["price"] ?? '',
      );
    }).toList();
  }
  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? UserData(
        uid: uid ?? 'user',
        name: snapshot.data['name'] ?? 'User',)
        : null;
  }
  Future createNewRequest (String uid, List<Item> items, String price, String address, bool status ) async
  {
    final id =shortid.generate();
    List<String> output = [];
    items.forEach((item)
    {
      output.add("${item.quantity.toString()} x ${item.name}");
    });
    await requestDataCollection.document(id).setData({
      'customer': uid,
      'requestId': id,
      'order': output,
      'status': status,
      'price': price,
      'address': address,

    });
    await userDataCollection
        .document(uid)
        .collection('requests')
        .document(id)
        .setData({
      'customer': uid,
      'orderId': id,
      'order': output,
      'status': 'false',
      'price': price,
    });

    return true;
  }
}
