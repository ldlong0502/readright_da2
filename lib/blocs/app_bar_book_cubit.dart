import 'package:ebook/models/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/audio_book.dart';
import '../models/fav_audioBook.dart';
import '../models/fav_ebook.dart';

class AppBarBookCubit extends Cubit<int> {
  AppBarBookCubit(this.book) : super(0);

  bool isShowTitle = false;
  bool isShowMaxButton = false;
  final ScrollController scrollController = ScrollController();
  final Book book;
  List<Book> bookMarkList = [];
  bool loading = false;
  bool _isBookMark = false;

  bool get isBookMark => _isBookMark;
  final hiveBookMark = Hive.box('bookmark_books');
  setLoading(value) {
    loading = value;
    notifyListeners();
  }

  getInfo(value) async {
    setLoading(true);
    checkBookMark();
    setLoading(false);
  }

  getBook(value) {
    return book;
  }

  void checkBookMark() async {
    var c =  hiveBookMark.get(book.id);
    if (c != null) {
      setBookMark(true);
    } else {
      setBookMark(false);
    }
  }

  addBookMark() {
    var item = FavoriteEbook(book: book, date: DateTime.now().millisecondsSinceEpoch);
    hiveBookMark.put(book.id , item.toJson());
    checkBookMark();
  }

  removeBookMark() async {
    hiveBookMark.delete(book.id);
    checkBookMark();
  }

  void setBookMark(value) {
    _isBookMark = value;
    notifyListeners();
  }

  void changeShowTitle(bool value){
    isShowTitle = value;
    emit(state+1);
  }
  void changeShowMaxButton(bool value){
    isShowMaxButton = value;
    emit(state+1);
  }

  void notifyListeners() {
    emit(state +1);
  }

}
