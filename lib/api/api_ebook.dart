import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/book.dart';
import '../models/genre.dart';
import 'api_provider.dart';

class ApiEbook {
  ApiEbook._privateConstructor();

  static final ApiEbook _instance = ApiEbook._privateConstructor();

  static ApiEbook get instance => _instance;
  final db = FirebaseFirestore.instance;

  Future<List<Book>> getListBook() async {
    final snapshot = await db
        .collection("ebook")
        .get();
    return snapshot.docs.map((e) => Book.fromJson(e.data())).toList();
  }

  Future<List<Book>> getFilterBooks(String query) async {
    final list = await getListBook();
    return list
        .where((element) =>
    element.title.toLowerCase().contains(query.toLowerCase()) ||
        element.author.toLowerCase().contains(query.toLowerCase()))
        .toList();

  }
  Future<List<Book>> getEbookByGenre( int  id) async {
    final snapshot = await db
        .collection("ebook").where('genre', arrayContains: id)
        .get();
    return snapshot.docs.map((e) => Book.fromJson(e.data())).toList();
  }
  Future<List<Book>> getTop5RecommendByRateCount() async {
    var response = await ApiProvider().get('/top_ebooks');
    debugPrint(response.toString());
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Book> topics = await Future.wait<Book>(
        (response.data as List).map((e) async {
          return (await getBookById(e['book_id'] as int))!;
        }),
      );
      return topics;

    } else {
      return [];
    }
  }

  Future<Book?> getBookById(int id) async {
    final snapshot =
    await db.collection("ebook").where('id', isEqualTo: id).get();
    return snapshot.docs.map((e) => Book.fromJson(e.data())).singleOrNull;
  }
}