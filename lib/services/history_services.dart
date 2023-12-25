import 'dart:convert';

import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/history_audio_book.dart';
import 'package:ebook/provider/local_provider.dart';
import 'package:flutter/material.dart';

import '../configs/configs.dart';
import '../provider/history_provider.dart';

class HistoryService {
  HistoryService._privateConstructor();

  static final HistoryService _instance = HistoryService._privateConstructor();

  static HistoryService get instance => _instance;

  updateNewHistory(AudioBook audioBook, int indexChapter, int duration) async {
    var listHistory =
        await HistoryProvider.instance.getListHistoryAudioBook();
    final index =
        listHistory.map((e) => e.audioBook.id).toList().indexOf(audioBook.id);
    if (index != -1) {
      listHistory.removeAt(index);
    }
    var history = HistoryAudioBook(
        audioBook: audioBook,
        duration: duration,
        indexChapter: indexChapter,
        dateUpdated: DateTime.now().millisecondsSinceEpoch);
    listHistory.insert(0, history);
    final json = jsonEncode(listHistory);
    await LocalProvider.instance.setString(AppConfigs.KEY_RECENTLY_PLAYED_AUDIO_BOOK, json);

    debugPrint('=>>>>>>>>>>>>> ${listHistory.length}');
    
  }

  removeHistory(AudioBook audioBook) async {
    var listHistory =
    await HistoryProvider.instance.getListHistoryAudioBook();
    final index =
    listHistory.map((e) => e.audioBook.id).toList().indexOf(audioBook.id);
    if (index != -1) {
      listHistory.removeAt(index);
    }
    final json = jsonEncode(listHistory);
    await LocalProvider.instance.setString(AppConfigs.KEY_RECENTLY_PLAYED_AUDIO_BOOK, json);
  }
}
