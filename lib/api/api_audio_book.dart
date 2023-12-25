import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/api/api_genre.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/mp3_file.dart';
import 'package:flutter/cupertino.dart';

import '../models/book.dart';
import '../models/genre.dart';
import 'api_provider.dart';

class ApiAudiobook {
  ApiAudiobook._privateConstructor();

  static final ApiAudiobook _instance = ApiAudiobook._privateConstructor();

  static ApiAudiobook get instance => _instance;
  final db = FirebaseFirestore.instance;
  Future<AudioBook?> getBookById(int id) async {
    final snapshot =
    await db.collection("ebook").where('id', isEqualTo: id).get();
    return snapshot.docs.map((e) async {
      final listGenreId = List<int>.from(e.data()['genre'] as List);
      final genre = await ApiGenre.instance.getGenre(listGenreId);
      final mp3 = await getMp3(e.data()['id'] as int);
      return AudioBook.fromJson(e.data(), genre, mp3);
    }).singleOrNull;
  }
  Future<List<AudioBook>> getListBook() async {
    final snapshot = await db
        .collection("audio_book")
        .orderBy('listen', descending: true)
        .limit(5)
        .get();
    final audioBooks = await Future.wait(snapshot.docs.map((e) async {
      final listGenreId = List<int>.from(e.data()['genre'] as List);
      final genre = await ApiGenre.instance.getGenre(listGenreId);
      final mp3 = await getMp3(e.data()['id'] as int);
      return AudioBook.fromJson(e.data(), genre, mp3);
    }).toList());

    return audioBooks;
  }
  Future<List<AudioBook>> getListBookByIdGenre(int id) async {
    final snapshot = await db
        .collection("audio_book").where('genre' , arrayContains: id)
        .orderBy('listen', descending: true)
        .get();
    final audioBooks = await Future.wait(snapshot.docs.map((e) async {
      final listGenreId = List<int>.from(e.data()['genre'] as List);
      final genre = await ApiGenre.instance.getGenre(listGenreId);
      final mp3 = await getMp3(e.data()['id'] as int);
      return AudioBook.fromJson(e.data(), genre, mp3);
    }).toList());

    return audioBooks;
  }
  Future<List<Mp3File>> getMp3(int idAudioBook) async {
    final snapshot = await db
        .collection("mp3")
        .where('audio_book_id', isEqualTo: idAudioBook)
        .orderBy('id')
        .get();
    if (snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) {
      return Mp3File.fromJson(e.data());
    }).toList();
  }

  Future<List<AudioBook>> getFilterAudioBooks(String query) async {
    final list = await getListBook();
    return list
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.author.toLowerCase().contains(query.toLowerCase()))
        .toList();

  }

  Future<List<AudioBook>> getRecently() async {
    final snapshot = await db
        .collection("audio_book")
        .orderBy('createdAt', descending: true)
        .limit(5)
        .get();
    final audioBooks = await Future.wait(snapshot.docs.map((e) async {
      final listGenreId = List<int>.from(e.data()['genre'] as List);
      final genre = await ApiGenre.instance.getGenre(listGenreId);
      final mp3 = await getMp3(e.data()['id'] as int);
      return AudioBook.fromJson(e.data(), genre, mp3);
    }).toList());

    return audioBooks;
  }
}
