
import 'package:ebook/api/api_ebook.dart';
import 'package:ebook/api/api_genre.dart';
import 'package:ebook/provider/local_provider.dart';
import 'package:ebook/util/api.dart';
import 'package:flutter/foundation.dart';
import 'package:ebook/util/enum.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';
import '../models/category_book.dart';
import '../models/genre.dart';
import '../util/functions.dart';

class HomeProvider with ChangeNotifier {
  final hiveBaseFav = Hive.box('genre');
  final CategoryBook _top = CategoryBook(name: 'top', books: []);
  CategoryBook _recent = CategoryBook(name: 'recent', books: []);
  CategoryBook _autoSubject = CategoryBook(name: 'auto subject', books: []);
  CategoryBook _baseFav = CategoryBook(name: 'base favorite', books: []);
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  BooksApi api = BooksApi();
  List<Book> listBooks = [];
  List<Genre> listGenre = [];

  void setBaseFav(value) {
    _baseFav = value;
    notifyListeners();
  }
  CategoryBook get baseFav => _baseFav;
  void setRecent(value) {
    _recent = value;
    notifyListeners();
  }
  CategoryBook get recent {
    return _recent;
  }
  void setAutoSubject(value) {
    _autoSubject = value;
    notifyListeners();
  }

  CategoryBook get autoSubject {
    return _autoSubject;
  }

  Future<void> getBooks() async {
    try {
      setApiRequestStatus(APIRequestStatus.loading);

      listGenre = await ApiGenre.instance.getListGenre();
      listBooks = await ApiEbook.instance.getListBook();
      print(listBooks);
      var listIdTop5 = await ApiEbook.instance.getTop5RecommendByRateCount();
      setAutoSubject(_autoSubject.copyWith(books: listIdTop5));
      setRecent(_recent.copyWith(books: listBooks.take(5).toList()));

      setApiRequestStatus(APIRequestStatus.loaded);
    }
    catch (e){
      checkError(e);
    }
   
  }

  Future<void> getBaseBooks() async{
    setApiRequestStatus(APIRequestStatus.loading);
    var booksFav = <Book>[];
    var list = await LocalProvider.instance.getList('favorite');

    if(listBooks.isEmpty) {
      listBooks = await ApiEbook.instance.getListBook();
    }
    for(var item in listBooks) {
      for(var i in item.genre) {
        if(list.contains(i.toString())){
          if(!booksFav.contains(item)) {
            booksFav.add(item);
          }
        }
      }
    }
    setBaseFav(_baseFav.copyWith(books: booksFav));
    setApiRequestStatus(APIRequestStatus.loaded);
  }
  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
   void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }
  
}
