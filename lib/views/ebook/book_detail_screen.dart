import 'package:ebook/api/api_genre.dart';
import 'package:ebook/blocs/app_bar_book_cubit.dart';
import 'package:ebook/models/genre.dart';
import 'package:ebook/views/ebook/app_bar_book.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/constants.dart';
import '../../models/book.dart';
import '../../util/resizable.dart';
import '../audio_books/audio_book_detail_screen.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AppBarBookCubit(book),
        child: BlocBuilder<AppBarBookCubit, int>(
          builder: (context, state) {
            final cubit = context.read<AppBarBookCubit>();
            return CustomScrollView(
              controller: cubit.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppBarBook(
                  book: book,
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
                          book.description,
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
                            children: book.genre
                                .map((e) => FutureBuilder<List<String>>(
                                    future: ApiGenre.instance.getGenre([e]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      }
                                      return Card(
                                        color: Colors.grey.shade300,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            snapshot.data!.join(''),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: purpleColor),
                                          ),
                                        ),
                                      );
                                    }))
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
                        ListComment(bookId: book.id, type: 0),
                        const Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 20,
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
