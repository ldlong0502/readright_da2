import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/blocs/user_cubit.dart';
import 'package:ebook/components/custom_button.dart';
import 'package:ebook/models/user_model.dart';
import 'package:ebook/util/dialogs.dart';
import 'package:ebook/views/comment/add_comment.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../api/api_audio_book.dart';
import '../../api/api_ebook.dart';
import '../../api/api_recommend.dart';
import '../../app_routes.dart';
import '../../blocs/app_bar_audio_book_cubit.dart';
import '../../blocs/comment_cubit.dart';
import '../../components/network_custom_image.dart';
import '../../configs/constants.dart';
import '../../models/audio_book.dart';
import '../../models/book.dart';
import '../../util/custom_toast.dart';
import '../../util/navigator_custom.dart';
import '../../util/resizable.dart';
import '../comment/comment_detail.dart';
import '../comment/empty_comment.dart';
import '../comment/shimmer_loading_comment.dart';
import '../ebook/book_detail_screen.dart';
import '../ebook/details_ebook.dart';
import 'app_bar_audio_book.dart';
import 'audio_catalogue.dart';

class AudioBookDetailScreen extends StatelessWidget {
  const AudioBookDetailScreen({super.key, required this.audioBook});

  final AudioBook audioBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AppBarAudioBookCubit(audioBook),
        child: BlocBuilder<AppBarAudioBookCubit, int>(
          builder: (context, state) {
            final cubit = context.read<AppBarAudioBookCubit>();
            return CustomScrollView(
              controller: cubit.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppBarAudioBook(
                  audioBook: audioBook,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        getTitle(context, 'Giới thiệu về truyện'),
                        const SizedBox(
                          height: 20,
                        ),
                        ExpandableText(
                          audioBook.description,
                          expandText: 'Xem thêm',
                          collapseText: 'Hiển thị ít hơn',
                          maxLines: 6,
                          linkStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Resizable.font(context, 15),
                              color: Colors.black),
                          linkColor: purpleColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: Resizable.size(context, 50),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            primary: true,
                            children: audioBook.genre
                                .map((e) => Card(
                                      color: Colors.grey.shade300,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: purpleColor),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        getTitle(context, 'Bạn đọc nói gì'),
                        ListComment(bookId: audioBook.id, type: 1),
                        const Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        getTitle(context, 'Mục lục'),
                        AudioCatalogue(
                          audioBook: audioBook,
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  getTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Resizable.font(context, 20),
          color: Colors.black),
    );
  }
}

class ListComment extends StatelessWidget {
  const ListComment({super.key, required this.bookId, required this.type});

  final int bookId;
  final int type;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (cc, state) {
        return BlocProvider(
          create: (context) => CommentCubit(type)..load(bookId),
          child: BlocBuilder<CommentCubit, int>(builder: (ccc, i) {
            final cubit = ccc.read<CommentCubit>();
            if (i == 0) {
              return const ShimmerLoadingComment();
            }
            return Column(
              children: [
                if (cubit.listComment.isEmpty) const EmptyComment(),
                if (cubit.listComment.isNotEmpty)
                  CommentDetail(commentCubit: cubit),
                CustomButton(
                    title: state == null ? 'Đăng nhập để thêm bình luận' : 'Thêm đánh giá của bạn',
                    onTap: () async {
                      if(state == null) {
                        Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.login);
                      }
                      else {

                        var res = await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AddComment(
                              type: 1,
                              bookId: bookId,
                              commentCubit: cubit,
                              mainContext: context,
                            );
                          },
                        );
                        if(res as bool) {
                          if(context.mounted){
                            // CustomToast.showBottomToast(
                            //     context, 'Cảm ơn đánh giá của bạn');
                            showRecommend(
                                bookId, type, userCubit.state!.id, context);
                          }
                        }


                      }
                    },
                    fontSize: 13,
                    border: true,
                    radius: 30,
                    backgroundColor: Colors.white,
                    textColor: pinkColor),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          }),
        );
      },
    );
  }
  showRecommend(int bookId, int type, int userId, BuildContext context) async {
    var listInt = <int>[];
    if (type == 0) {
      listInt = await ApiRecommend.instance.getRecommendBookForUser(userId);
    } else {
      listInt = await ApiRecommend.instance.getRecommendAudioBookForUser(userId);
    }
    var listEbook = <Book>[];
    var listAudiobook = <AudioBook>[];
    for (var item in listInt
      ..shuffle()
      ..take(3).toList()) {
      if (type == 0) {
        var book = await ApiEbook.instance.getBookById(item);
        if (book != null) {
          listEbook.add(book);
        }
      } else {
        var book = await ApiAudiobook.instance.getBookById(item);
        if (book != null) {
          listAudiobook.add(book);
        }
      }
    }
    if(listAudiobook.isEmpty) {
      listAudiobook = await ApiAudiobook.instance.getListBook();
      listAudiobook.removeWhere((element) => element.id == bookId);
    }
    if(listEbook.isEmpty) {
      listEbook = await ApiEbook.instance.getListBook();
      listEbook.removeWhere((element) => element.id == bookId);
    }
    if (context.mounted) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              height: 600,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Text(
                    'Đề xuất cho bạn!!!',
                    style: TextStyle(
                        color: purpleColor,
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.size(context, 20)),
                  ),
                  const SizedBox(height: 20,),
                  CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 240 / 160,
                      viewportFraction: 0.7,
                      enableInfiniteScroll: false,

                      onPageChanged: (index, _) {},
                    ),
                    items: type == 1 ?  listAudiobook.take(3).map((i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            NavigatorCustom.pushNewScreen(context, AudioBookDetailScreen(audioBook: i), AppRoutes.audioBookDetail + i.id.toString());
                          },
                          child: Column(
                            children: [
                              Expanded(child: LayoutBuilder(builder: (context, c) {
                                return NetworkImageCustom(
                                  url: i.image,
                                  width: c.maxWidth,
                                  height: c.maxHeight,
                                  borderRadius: BorderRadius.circular(20),
                                );
                              })),
                              const SizedBox(
                                height: 10,
                              ),
                              RatingBarIndicator(
                                rating: i.rate,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star_rounded,
                                  color: pinkColor,
                                ),
                                unratedColor: Colors.grey.shade300,
                                itemCount: 5,
                                itemSize: 25.0,
                                direction: Axis.horizontal,
                              ),
                              Text(
                                i.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList() : listEbook.take(3).map((i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            NavigatorCustom.pushNewScreen(context, BookDetailScreen(
                              book: i,
                            ), AppRoutes.bookDetail + i.id.toString());
                          },
                          child: Column(
                            children: [
                              Expanded(child: LayoutBuilder(builder: (context, c) {
                                return NetworkImageCustom(
                                  url: i.image,
                                  width: c.maxWidth,
                                  height: c.maxHeight,
                                  borderRadius: BorderRadius.circular(20),
                                );
                              })),
                              const SizedBox(
                                height: 10,
                              ),
                              RatingBarIndicator(
                                rating: i.rate,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star_rounded,
                                  color: pinkColor,
                                ),
                                unratedColor: Colors.grey.shade300,
                                itemCount: 5,
                                itemSize: 25.0,
                                direction: Axis.horizontal,
                              ),
                              Text(
                                i.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          });
    }
  }
}
