import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/genre.dart';
import 'api_provider.dart';

class ApiRecommend {
  ApiRecommend._privateConstructor();

  static final ApiRecommend _instance = ApiRecommend._privateConstructor();

  static ApiRecommend get instance => _instance;
  Future<List<int>> getRecommendBookForUser(int idUser) async {
    var response = await ApiProvider().post('/recommend-books',data:  {
      'user_id': idUser
    });
    debugPrint(response.toString());
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<int> topics = (response.data['recommended_books'] as List).map((e) => e as int).toList();
      return topics;

    } else {
      return [];
    }
  }
  Future<List<int>> getRecommendAudioBookForUser(int idUser) async {
    var response = await ApiProvider().post('/recommend-audiobooks',data:  {
      'user_id': idUser
    });
    debugPrint(response.toString());
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<int> topics = (response.data['recommended_books'] as List).map((e) => e as int).toList();
      return topics;

    } else {
      return [];
    }
  }
}