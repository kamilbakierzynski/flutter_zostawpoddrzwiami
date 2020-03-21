import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zostawpoddrzwiami/models/confirm_request.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:shortid/shortid.dart';
import '../models/current_user_request_model.dart';
import '../models/current_user_request_model.dart';
import '../models/current_user_request_model.dart';
import '../models/current_user_request_model.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;
  final String orderId;
  final String name;

  DatabaseService({this.uid, this.orderId, this.name});

  final CollectionReference userDataCollection =
      Firestore.instance.collection('users');
  final CollectionReference itemsDataCollection =
      Firestore.instance.collection('data');
  final CollectionReference requestDataCollection =
      Firestore.instance.collection('requests');
  final CollectionReference appDataCollection =
      Firestore.instance.collection('app-data');
  final CollectionReference confirmDeliveryCollection =
      Firestore.instance.collection('confirmRequests');

  Future createUserData(String name, String surname) async {
    return await userDataCollection
        .document(uid)
        .setData({'name': name, 'surname': surname, 'uid': uid});
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

  Stream<ConfirmRequest> get confirmRequestData {
    return confirmDeliveryCollection
        .document(orderId)
        .snapshots()
        .map(_confirmRequestFromSnapshot);
  }

  ConfirmRequest _confirmRequestFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data != null) {
      return ConfirmRequest(
          makerUid: snapshot.data['makerUid'],
          orderId: snapshot.data['orderId'],
          received: snapshot.data['received'],
          takerUid: snapshot.data['takerUid']);
    }
    return null;
  }

  Future<bool> createNewConfirmRequst(ConfirmRequest confirmRequest) async {
    await confirmDeliveryCollection.document(confirmRequest.orderId).setData({
      'makerUid': confirmRequest.makerUid,
      'orderId': confirmRequest.orderId,
      'received': confirmRequest.received,
      'takerUid': confirmRequest.takerUid
    });
  }

  Future confirmGettingOrder(String orderId) async {
    await confirmDeliveryCollection
        .document(orderId)
        .updateData({'received': true});
  }

  List<UserRequest> _requestFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc != null) {
        List<dynamic> items = doc.data['order'];
        List<Item> itemsFormated = [];
        items.forEach((item) {
          itemsFormated.add(Item(
              item.toString().split('#@?')[0],
              double.parse(item.toString().split('#@?')[1]),
              item.toString().split('#@?')[2],
              item.toString().split('#@?')[3]));
        });
        print(itemsFormated[0].name);
        return UserRequest(
          name: doc.data["name"] ?? '',
          address: doc.data["address"] ?? '',
          request: itemsFormated ?? [Item('', 0, '', '')],
          creatorId: doc.data['customer'] ?? '',
          requestId: doc.data["requestId"] ?? '',
          price: doc.data["price"] ?? '',
          status: doc.data["status"] ?? false,
          time: doc.data["time"] != null
              ? formatTime(doc.data['time'].toDate().toString())
              : '',
          longitude: doc.data["longitude"] ?? 0.0,
          latitude: doc.data["latitude"] ?? 0.0,
          description: doc.data['description'] ?? '',
          phoneNumber: doc.data['phoneNumber'] ?? '',
          carierName: doc.data['carierName'] ?? '',
          carierPhoneNumber: doc.data['carierPhoneNumber'] ?? '',
          pending: doc.data['pending'] ?? false,
        );
      } else {
        return null;
      }
    }).toList();
  }

  List<CurrentUserRequest> _currentUserRequestFromSnapshot(
      QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.documents.map((doc) {
        if (doc != null) {
          List<Item> itemsFormated = [];
          if (doc.data['order'] != null) {
            List<dynamic> items = doc.data['order'];
            items.forEach((item) {
              itemsFormated.add(Item(
                  item.toString().split('#@?')[0],
                  double.parse(item.toString().split('#@?')[1]),
                  item.toString().split('#@?')[2],
                  item.toString().split('#@?')[3]));
            });
          }
          return CurrentUserRequest(
              name: doc.data["name"] ?? '',
              address: doc.data["address"] ?? '',
              request: itemsFormated ?? [Item('', 0, '', '')],
              requestId: doc.data["requestId"] ?? '',
              price: doc.data["price"] ?? '',
              status: doc.data["status"] ?? false,
              customer: doc.data['customer'] ?? '',
              longitude: doc.data["longitude"] ?? 0.0,
              latitude: doc.data["latitude"] ?? 0.0,
              description: doc.data['description'] ?? '',
              phoneNumber: doc.data['phoneNumber'] ?? '',
              carierName: doc.data['carierName'] ?? '',
              carierPhoneNumber: doc.data['carierPhoneNumber'] ?? '',
              pending: doc.data['pending'] ?? false,
              time: doc.data["time"] != null
                  ? formatTime(doc.data['time'].toDate().toString())
                  : '');
        } else {
          return null;
        }
      }).toList();
    }
    return null;
  }

  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data != null) {
      return UserData(
          uid: uid,
          name: snapshot.data['name'] ?? 'Janina',
          surname: snapshot.data['surname']);
    } else {
      return null;
    }
  }

  Future<bool> createNewRequest(UserRequest request) async {
    final id = shortid.generate();
    List<String> output = [];
    request.request.forEach((item) {
      output.add(
          "${item.name}#@?${item.quantity.toString()}#@?${item.unit}#@?${item.description}");
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
      'description': request.description,
      'phoneNumber': request.phoneNumber,
      'time': Timestamp.now(),
      'carierName': request.carierName,
      'carierPhoneNumber': '',
      'pending': false,
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
      'description': request.description,
      'phoneNumber': request.phoneNumber,
      'time': Timestamp.now(),
      'carierName': request.carierName,
      'carierPhoneNumber': '',
      'pending': false,
    });
    return true;
  }

// request operations
  Future<bool> abandonRequest(CurrentUserRequest request) async {
    List<String> output = [];
    request.request.forEach((item) {
      output.add(
          "${item.name}#@?${item.quantity.toString()}#@?${item.unit}#@?${item.description}");
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
      'description': request.description,
      'phoneNumber': request.phoneNumber,
      'time': Timestamp.now(),
      'carierName': '',
      'carierPhoneNumber': '',
      'pending': false,
    });
    await userDataCollection
        .document(request.customer)
        .collection('requests')
        .document(request.requestId)
        .updateData({
      'status': false,
    }).catchError((error) => print(error));
    await userDataCollection
        .document(uid)
        .collection('requests')
        .document(request.requestId)
        .delete();
    return true;
  }

  Future<bool> acceptRequest(UserRequest request) async {
    if (request.status == false) {
      List<String> output = [];
      request.request.forEach((item) {
        output.add(
            "${item.name}#@?${item.quantity.toString()}#@?${item.unit}#@?${item.description}");
      });
      await userDataCollection
          .document(uid)
          .collection('requests')
          .document(request.requestId)
          .setData({
        'name': request.name,
        'price': request.price,
        'address': request.address,
        'order': output,
        'status': true,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'customer': request.creatorId,
        'time': Timestamp.now(),
        'requestId': request.requestId,
        'description': request.description,
        'phoneNumber': request.phoneNumber,
        'carierName': name,
        'carierPhoneNumber': '',
        'pending': request.pending,
      });
      await userDataCollection
          .document(request.creatorId)
          .collection('requests')
          .document(request.requestId)
          .updateData({
        // here should be updateData - check later
        'name': request.name,
        'price': request.price,
        'address': request.address,
        'order': output,
        'status': true,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'customer': request.creatorId,
        'time': request.time,
        'requestId': request.requestId,
        'description': request.description,
        'phoneNumber': request.phoneNumber,
        'carierName': name,
        'carierPhoneNumber': '',
      }).catchError((error) => print(error));
      await requestDataCollection.document(request.requestId).delete();
    }
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

  Future<bool> deleteOwnRequest(CurrentUserRequest request) async {
    await userDataCollection
        .document(uid)
        .collection('requests')
        .document(request.requestId)
        .delete();
    await requestDataCollection.document(request.requestId).delete();
    return true;
  }

  Future<bool> requestCompleted(ConfirmRequest request) async {
    await userDataCollection
        .document(request.makerUid)
        .collection('requests')
        .document(request.orderId)
        .delete();
    await userDataCollection
        .document(request.takerUid)
        .collection('requests')
        .document(request.orderId)
        .delete();
    return true;
  }

  Future<bool> saveDeviceToken(FirebaseMessaging _fcm) async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      var tokenRef = userDataCollection
          .document(uid)
          .collection('tokens')
          .document(fcmToken);
      await tokenRef.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return true;
  }
}
