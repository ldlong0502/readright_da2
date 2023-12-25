import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/genre.dart';
import 'api_provider.dart';

class ApiGenre {
  ApiGenre._privateConstructor();

  static final ApiGenre _instance = ApiGenre._privateConstructor();

  static ApiGenre get instance => _instance;
  final db = FirebaseFirestore.instance;
  Future<List<Genre>> getListGenre() async {
    final snapshot = await db
        .collection("genre")
        .get();
    return snapshot.docs.map((e) => Genre.fromJson(e.data())).toList();
  }

  Future<List<String>> getGenre(List<int> listIdGenre) async {
    final snapshot =
    await db.collection("genre").where('id', whereIn: listIdGenre).get();
    if(snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }
}