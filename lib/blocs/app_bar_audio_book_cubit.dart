import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/audio_book.dart';
import '../models/fav_audioBook.dart';

class AppBarAudioBookCubit extends Cubit<int> {
  AppBarAudioBookCubit(this.audioBook) : super(0);

  bool isShowTitle = false;
  bool isShowMaxButton = false;
  final ScrollController scrollController = ScrollController();
  final AudioBook audioBook;
  bool _isAudioBookMark = false;
  bool loading = false;
  bool get isAudioBookMark => _isAudioBookMark;
  final hiveBookMark = Hive.box('bookmark_audioBooks');
  setLoading(value) {
    loading = value;
    emit(state+1);
  }

  getInfo(value) async {
    setLoading(true);
    checkAudioBookMark();
    setLoading(false);
  }


  getAudioBook() {
    return audioBook;
  }

  void checkAudioBookMark() async {
    var c = hiveBookMark.get(audioBook.id);
    if (c != null) {
      setAudioBookMark(true);
    } else {
      setAudioBookMark(false);
    }
  }

  addAudioBookMark() {
    var item =
    FavoriteAudioBook(audioBook: audioBook, date: DateTime.now().millisecondsSinceEpoch);
    hiveBookMark.put(audioBook.id, item.toJson());
    checkAudioBookMark();
  }

  removeBookMark() async {
    hiveBookMark.delete(audioBook.id);
    checkAudioBookMark();
  }

  void setAudioBookMark(value) {
    _isAudioBookMark = value;
    emit(state+1);
  }

  void changeShowTitle(bool value){
    isShowTitle = value;
    emit(state+1);
  }
  void changeShowMaxButton(bool value){
    isShowMaxButton = value;
    emit(state+1);
  }

}
