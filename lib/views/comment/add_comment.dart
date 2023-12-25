import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/api/api_audio_book.dart';
import 'package:ebook/api/api_comment.dart';
import 'package:ebook/api/api_ebook.dart';
import 'package:ebook/blocs/comment_cubit.dart';
import 'package:ebook/blocs/user_cubit.dart';
import 'package:ebook/components/custom_button.dart';
import 'package:ebook/components/network_custom_image.dart';
import 'package:ebook/configs/constants.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/comment.dart';
import 'package:ebook/util/custom_toast.dart';
import 'package:ebook/util/navigator_custom.dart';
import 'package:ebook/views/audio_books/audio_book_detail_screen.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:ebook/views/login/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../api/api_recommend.dart';
import '../../app_routes.dart';
import '../../models/book.dart';
import '../../util/resizable.dart';

class AddComment extends StatelessWidget {
  const AddComment(
      {super.key,
      required this.type,
      required this.bookId,
      required this.commentCubit, required this.mainContext});

  final int type;
  final int bookId;
  final CommentCubit commentCubit;
  final BuildContext mainContext;
  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      insetPadding: EdgeInsets.zero,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
        child: BlocProvider(
          create: (context) => AddCommentCubit(),
          child: BlocBuilder<AddCommentCubit, int>(
            builder: (context, state) {
              final cubit = context.read<AddCommentCubit>();
              return Column(
                children: [
                  const Text(
                    'Thêm đánh giá của bạn!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: purpleColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                    initialRating: cubit.rate,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: pinkColor,
                    ),
                    onRatingUpdate: (rating) {
                      cubit.updateRate(rating);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      controller: cubit.controller,
                      title: 'Bình luận của bạn',
                      onValidate: () {},
                      isPassword: false),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      title: 'Đánh giá',
                      onTap: () async {

                        if (cubit.controller.text.isEmpty) {
                          CustomToast.showBottomToast(
                              context, 'Đánh giá không được trống');
                          return;
                        }
                        var comment = Comment(
                            bookId: bookId,
                            userId: userCubit.state!.id,
                            rate: cubit.rate,
                            content: cubit.controller.text,
                            createdAt: DateTime.now().millisecondsSinceEpoch);
                        var res = await ApiComment.instance
                            .addCommentToFirebase(type, comment);
                        if (res) {
                          await commentCubit.load(bookId);
                          if (context.mounted) {
                            Navigator.pop(context, true);


                          }
                        } else {
                          if (context.mounted) {
                            CustomToast.showBottomToast(
                                context, 'Có lỗi xảy ra');
                          }
                        }
                      },
                      backgroundColor: purpleColor,
                      textColor: Colors.white)
                ],
              );
            },
          ),
        ),
      ),
    );
  }


}

class AddCommentCubit extends Cubit<int> {
  AddCommentCubit() : super(0);

  double rate = 1;
  TextEditingController controller = TextEditingController();

  updateRate(double value) {
    rate = value;
    emit(state + 1);
  }
}
