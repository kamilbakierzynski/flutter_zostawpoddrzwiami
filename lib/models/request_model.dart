// uniwersalny request zakupowy

import 'item_model.dart';

class UserRequest{
  final String name;
  final String price;
  final String requestId;
  final List <Item> request;
  final String address;
  final bool status;
  final String time;
  final double longitude;
  final double latitude;
  final String creatorId;
  final String phoneNumber;
  final String description;
  final String carierName;
  final String carierPhoneNumber;
  final bool pending;
  double distance;

  UserRequest({this.name, this.price, this.requestId, this.request, this.address, this.status, this.longitude, this.latitude, this.time, this.creatorId, this.description, this.phoneNumber, this.carierName, this.carierPhoneNumber, this.pending});
}