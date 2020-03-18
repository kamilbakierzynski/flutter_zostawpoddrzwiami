import 'item_model.dart';
class UserRequest{
  final String name;
  final String time;
  final String price;
  final String requestId;
  final List <Item> request;
  final String address;
  UserRequest({this.name,this.time, this.price, this.requestId, this.request, this.address});
}