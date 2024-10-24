// user_info.dart
class UserInfo {
  static final UserInfo _instance = UserInfo._internal();
  String? userName;
  String? phoneNumber;
  String? password;

  UserInfo._internal(); // private constructor

  factory UserInfo() {
    return _instance;
  }
}
