import 'package:ebook/models/book.dart';
import 'package:ebook/models/book_download.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import '../provider/local_provider.dart';

class RecentlyReadingCubit extends Cubit<int> {
  RecentlyReadingCubit() : super(0);
  List<BookDownLoad> listHistory = [];

  final local = LocalProvider.instance;
  final hiveBookReading = Hive.box('book_reading_books');
  bool isGrid = false;
  updateView() {
    isGrid = !isGrid;
    emit(state+1);
  }

  load() async {
    listHistory.clear();
    for(var item in hiveBookReading.values.toList() ){
      listHistory.add(BookDownLoad.fromJson(item));
    }

    emit(state + 1);
  }


  removeHistory(Book book) async {
    hiveBookReading.delete(book.id);
    load();
  }
}