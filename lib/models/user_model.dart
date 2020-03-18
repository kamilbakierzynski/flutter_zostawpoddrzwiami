import 'package:zostawpoddrzwiami/models/request_model.dart';

class User
{
  final String uid;
  User({this.uid});
}
class UserData
{
  final String uid;
  final String name;
  UserData( {this.uid, this.name});

  // aktualny request kupowany/zamawiany
  UserRequest currentRequest;
}