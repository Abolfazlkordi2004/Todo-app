import 'package:todo_app/class/cache_handler.dart';
import 'package:todo_app/class/user_info.dart';

Future<void> loadUserInfo() async {
  final userInfo = await CacheHandler.getUserInfo();
  UserInfo().userName = userInfo['userName'];
  UserInfo().phoneNumber = userInfo['phoneNumber'];
  UserInfo().password = userInfo['password'];
}
