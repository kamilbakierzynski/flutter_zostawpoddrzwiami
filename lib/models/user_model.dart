import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';

class User
{
  final String uid;
  User({this.uid});
}
class UserData
{
  final String uid;
  final String name;
  final String surname;
  final String phone;
  UserData( {this.uid, this.name, this.surname, this.phone});

  // aktualny request kupowany/zamawiany
  UserRequest currentRequest;
}