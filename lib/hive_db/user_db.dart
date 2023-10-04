
import 'package:chat_app/hive_model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';


UserModel user=UserModel(name: "name", about: "about", image: "image");
ValueNotifier<UserModel>thisUSer=ValueNotifier(user);

saveUserToDB(UserModel user)async{
  final user_db=await Hive.openBox<UserModel>("user_db");
// ignore: unused_local_variable
int id =await user_db.add(user);
thisUSer.value=user;
// ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
thisUSer.notifyListeners();
}

deleteDB()async{
  final user_db=await Hive.openBox<UserModel>("user_db");
  user_db.deleteAt(0);
}