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
  CurrentUserRequest({this.name, this.price, this.requestId, this.request, this.address, this.status, this.longitude, this.latitude});
}