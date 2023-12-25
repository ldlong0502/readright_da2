import 'dart:convert';

import 'package:ebook/models/history_audio_book.dart';
import 'package:ebook/provider/local_provider.dart';


import '../configs/configs.dart';

class HistoryProvider {
  HistoryProvider._privateConstructor();

  static final HistoryProvider _instance = HistoryProvider._privateConstructor();

  static HistoryProvider get instance => _instance;

  final local = LocalProvider.instance;
  Future<List<HistoryAudioBook>> getListHistoryAudioBook() async {
    var response = await local.getString(AppConfigs.KEY_RECENTLY_PLAYED_AUDIO_BOOK);

    if(response.isEmpty) {
      return [];
    } else {
      List<HistoryAudioBook> podcasts =
      (jsonDecode(response) as List).map((e) => HistoryAudioBook.fromJson(e)).toList();
      podcasts.sort((a , b) => b.dateUpdated.compareTo(a.dateUpdated));
      return podcasts;
    }
  }
}