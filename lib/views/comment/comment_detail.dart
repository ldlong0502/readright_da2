import 'package:ebook/blocs/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../blocs/comment_cubit.dart';
import '../../configs/constants.dart';
import '../../util/convert_utils.dart';
import '../../util/dialogs.dart';
import '../../util/resizable.dart';




class CommentDetail extends StatelessWidget {
  const CommentDetail({super.key, required this.commentCubit });
  final CommentCubit commentCubit;
  @override
  Widget build(BuildContext context) {
    final listComment = commentCubit.listComment;
    final userCubit = context.read<UserCubit>();

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...listComment.take(2).toList().map((e) {
          final time = ConvertUtils.convertIntToDateTime(e.createdAt);
          final index = listComment.indexOf(e);
          var model = commentCubit.listUserModel[index];
          var who = userCubit.state != null && userCubit.state!.id == model.id ? 'BẠN': model.fullName;
          return Container(
            margin: EdgeInsets.only(
              bottom: Resizable.padding(context, 20),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20),
                vertical: Resizable.padding(context, 10)),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bởi $who vào lúc $time'.toUpperCase(),
                    style: TextStyle(
                        fontSize: Resizable.font(context, 12),
                        color: pinkColor,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Text(
                      'ĐÁNH GIÁ',
                      style: TextStyle(
                          fontSize: Resizable.font(context, 12),
                          color: purpleColor,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 20,),
                    RatingBarIndicator(
                      rating: e.rate,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star_rounded,
                        color: purpleColor,
                      ),
                      unratedColor: Colors.grey.shade300,
                      itemCount: 5,
                      itemSize: 15.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Text(
                  e.content,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(
          height: 10,
        ),
        if(listComment.length > 2)
          GestureDetector(
            onTap: () {
              Dialogs.showComment(context, commentCubit);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hiển thị tất cả ${listComment.length} đánh giá',
                  style: TextStyle(
                      fontSize: Resizable.font(context, 13),
                      color: pinkColor,
                      fontWeight: FontWeight.w700),
                ),
                const Icon(Icons.keyboard_arrow_right_outlined , color: pinkColor, size: 20,)
              ],
            ),
          ),
        const SizedBox(height: 20,),
      ],
    );
  }

}


