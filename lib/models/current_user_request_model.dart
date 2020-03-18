import 'item_model.dart';
class CurrentUserRequest
{
  final String name;
  final String price;
  final String requestId;
  final List <Item> request;
  final String address;
  final bool status;
  CurrentUserRequest({this.name, this.price, this.requestId, this.request, this.address, this.status});
}