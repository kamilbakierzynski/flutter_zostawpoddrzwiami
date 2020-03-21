import 'item_model.dart';
class CurrentUserRequest
{
  final String name;
  final String price;
  final String requestId;
  final List <Item> request;
  final String address;
  final bool status;
  final double longitude;
  final double latitude;
  final String time;
  final String customer;
  final String phoneNumber;
  final String description;
  final bool pending;
  final String carierName;
  final String carierPhoneNumber;

  CurrentUserRequest({this.name, this.price, this.requestId, this.request, this.address, this.status, this.time, this.longitude, this.latitude, this.customer, this.phoneNumber, this.description, this.pending, this.carierPhoneNumber, this.carierName});
}