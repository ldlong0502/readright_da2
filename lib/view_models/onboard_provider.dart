import 'package:ebook/api/api_genre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/genre.dart';

class OnboardCubit extends Cubit<int> {
  OnboardCubit() : super(0);
  List<Genre> listGenre = [];

  load() async {
    listGenre = await ApiGenre.instance.getListGenre();
    emit(state+1);
  }

}