import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/provider/local_provider.dart';
import 'package:flutter/cupertino.dart';

import '../app_routes.dart';
import '../models/book.dart';
import '../models/comment.dart';
import '../models/genre.dart';
import '../models/user_model.dart';
import '../util/custom_toast.dart';
import 'api_provider.dart';

class ApiAuthentication {
  ApiAuthentication._privateConstructor();

  static final ApiAuthentication _instance = ApiAuthentication._privateConstructor();

  static ApiAuthentication get instance => _instance;
  final db = FirebaseFirestore.instance;
  Future<UserModel?> getUser(int userId) async {
    final snapshot =
    await db.collection("user").where('user_id', isEqualTo: userId).get();
    return snapshot.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
  }
  Future<UserModel?> login(String email, String password) async {
    final snapshot =
    await db.collection("user").where('email', isEqualTo: email ).where('password', isEqualTo: password ).get();
    var model = snapshot.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
    if(model != null) {
      await LocalProvider.instance.saveJsonToPrefs( model.toJson(), 'user');
    }
    return model;

  }

  Future<bool> logOut(BuildContext context) async {

    await LocalProvider.instance.removeJsonToPref('user');
    if(context.mounted){
      CustomToast.showBottomToast(context, 'Log out successfully!');
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.splash, (route) => false,);
    }
    return true;


  }
}