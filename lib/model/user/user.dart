import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  User({required this.email, required this.username, required this.password});
}
