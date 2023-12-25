import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/history_audio_book.dart';
import 'package:ebook/provider/history_provider.dart';
import 'package:ebook/provider/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/history_services.dart';

class RecentlyPlayCubit extends Cubit<int> {
  RecentlyPlayCubit() : super(0);
List<HistoryAudioBook> listHistory = [];

  final local = LocalProvider.instance;

  bool isGrid = false;
  updateView() {
    isGrid = !isGrid;
    emit(state+1);
  }

  load() async {

    listHistory = await HistoryProvider.instance.getListHistoryAudioBook();

    emit(state + 1);
  }


  removeHistory(AudioBook podcast) async {
    await HistoryService.instance.removeHistory(podcast);
    load();
  }
}
