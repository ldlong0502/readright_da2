
import 'package:ebook/api/api_auth.dart';
import 'package:ebook/api/api_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/comment.dart';
import '../models/user_model.dart';
class CommentCubit extends Cubit<int> {
  CommentCubit(this.type) : super(0);
  final int type;
  List<Comment> listComment = [];
  List<UserModel> listUserModel = [];

  load( int bookId ) async {
    listComment = await ApiComment.instance.getAllAudioBookComments(bookId);

    for(var i in listComment) {
      final user = await ApiAuthentication.instance.getUser(i.userId);
      if(user != null) {
        listUserModel.add(user);
      }
    }


    debugPrint('=>>>>>>> listUserModel: ${listUserModel.length}');
    emit(state+1);
  }

}
