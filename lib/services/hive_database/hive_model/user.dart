import 'package:hive_flutter/adapters.dart';
part 'user.g.dart';


@HiveType(typeId:1)
class UserModel{

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? about;

  @HiveField(2)
  String? image;

  UserModel({required this.name, required this.about, required this.image});
}