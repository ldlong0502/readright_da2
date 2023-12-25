
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ebook/blocs/app_bar_book_cubit.dart';
import 'package:ebook/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../blocs/player_cubit.dart';
import '../../configs/constants.dart';
import '../../theme/theme_config.dart';
import '../../util/dialogs.dart';
import '../../util/resizable.dart';
import '../../view_models/library_provider.dart';

class AppBarBook extends StatelessWidget {
  const AppBarBook({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarBookCubit, int>(
      builder: (context, state) {
        final cubit = context.read<AppBarBookCubit>();
        cubit.scrollController.addListener(() {
          if(cubit.scrollController.offset > Resizable.height(context) * 0.4) {
            if(!cubit.isShowTitle) {
              cubit.changeShowTitle(true);

            }
            if(!cubit.isShowMaxButton) {
              cubit.changeShowMaxButton(true);
            }
          }
          else {
            if(cubit.isShowTitle) {
              cubit.changeShowTitle(false);

            }
            if(cubit.isShowMaxButton) {
              cubit.changeShowMaxButton(false);
            }
          }
        });
        return SliverAppBar(
          expandedHeight: Resizable.height(context) * 0.5,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: purpleColor,
          pinned: true,
          title: cubit.isShowTitle ?  Text(book.title , style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: whiteColor
          ),): null,
          actions: [
            IconButton(
                onPressed: () async {
                  if (cubit.isBookMark) {
                    cubit.removeBookMark();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_outlined,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Đã xóa khỏi danh sách yêu thích!',
                            style: TextStyle(color: ThemeConfig.lightAccent),
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 15),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ));
                  } else {
                    cubit.addBookMark();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_outlined,
                            color: Colors.green,
                          ),
                          Text(
                            'Đã thêm vào danh sách yêu thích!',
                            style: TextStyle(color: ThemeConfig.lightAccent),
                          ),
                          InkWell(
                            onTap: () {
                              context.read<PlayerCubit>().persistentTabController.jumpToTab(1);
                              context
                                  .read<LibraryCubit>()
                                  .setCurrentIndex(2);
                              context
                                  .read<LibraryCubit>()
                                  .getData();


                            },
                            child: Text(
                              'Xem',
                              style:
                              TextStyle(color: ThemeConfig.fourthAccent),
                            ),
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ));
                  }
                  context
                      .read<LibraryCubit>()
                      .getData();

                },
                icon: Icon(
                  cubit.isBookMark
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: Colors.white,
                )),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.ios_share_rounded,
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25
                        ),
                        child: Hero(
                          tag: 'book_${book.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              book.image,
                              fit: BoxFit.fill,
                              height: Resizable.height(context) * 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.menu_book, color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('SÁCH NÓI' , style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor
                              ),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          AutoSizeText(book.title ,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                fontSize: Resizable.font(context, 25)
                            ),),
                          Row(
                            children: [
                              AutoSizeText(book.author , style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor
                              ),),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          RatingBarIndicator(
                            rating: book.rate,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                            ),
                            unratedColor: Colors.blue,
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          bottom:  PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: (){
                  Dialogs().showEpub(context, book);
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.blueAccent,
                          pinkColor
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: cubit.isShowMaxButton ? Resizable.width(context) * 0.9 : 200,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book, size: 30, color: Colors.white,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Đọc ngay',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}