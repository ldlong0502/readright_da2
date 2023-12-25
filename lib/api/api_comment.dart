import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/book.dart';
import '../models/comment.dart';
import '../models/genre.dart';
import 'api_provider.dart';

class ApiComment {
  ApiComment._privateConstructor();

  static final ApiComment _instance = ApiComment._privateConstructor();

  static ApiComment get instance => _instance;
  final db = FirebaseFirestore.instance;
  Future<List<Comment>> getAllAudioBookComments(int bookId) async {
    final snapshot = await db
        .collection("audiobook_comments")
        .where('book_id', isEqualTo: bookId)
        .orderBy('createdAt', descending: true)
        .get();
    if(snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Comment.fromJson(e.data())).toList();
  }

  Future<bool> addCommentToFirebase(int type , Comment comment) async {
   try {
     var create =  db.collection(type == 0 ? 'ebooks_comments' : 'audiobook_comments');
     await create.doc('${type == 0 ?'ebook': 'audio_book'}_${comment.bookId}_user_${comment.userId}_comment_${comment.createdAt}')
         .set(comment.toMap());
     return true;
   }
   catch(err) {
     return false;
   }
  }
}