import 'dart:ffi';

import 'package:ebook/views/audio_books/audio_book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../app_routes.dart';
import '../../blocs/recently_play_cubit.dart';
import '../../components/app_bar_custom.dart';
import '../../components/network_custom_image.dart';
import '../../configs/constants.dart';
import '../../util/navigator_custom.dart';
import '../../util/resizable.dart';
class RecentlySeeAll extends StatelessWidget {
  const RecentlySeeAll(
      {super.key, required this.cubit, required this.title});

  final RecentlyPlayCubit cubit;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom('', context),
      body: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<RecentlyPlayCubit, int>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        var text = title;
                        return Text(
                          text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 24),
                              color: textColor,
                              fontWeight: FontWeight.w600),
                        );
                      }),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                cubit.updateView();
                              },
                              splashRadius: 20,
                              iconSize: Resizable.size(context, 25),
                              color: primaryColor,
                              icon: Icon(
                                cubit.isGrid ? Icons.grid_view_rounded : Icons.sort,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                if (cubit.listHistory.isNotEmpty && cubit.isGrid)
                  Expanded(
                      child: GridView.builder(
                          itemCount: cubit.listHistory.length,
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15),
                              horizontal: Resizable.padding(context, 20)),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: Resizable.padding(context, 15),
                            mainAxisSpacing: Resizable.padding(context, 15),
                          ),
                          itemBuilder: (context, index) {
                            var playlist = cubit.listHistory[index];
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, AudioBookDetailScreen(audioBook: playlist.audioBook), AppRoutes.audioBookDetail + playlist.audioBook.id.toString());
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                      child: LayoutBuilder(builder: (context, c) {
                                        return NetworkImageCustom(
                                          url: playlist.audioBook.image,
                                          width: c.maxWidth,
                                          height: c.maxHeight,
                                          borderRadius: BorderRadius.circular(20),
                                        );
                                      })),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    playlist.audioBook.title,
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
                                  Text(
                                    playlist.audioBook.listMp3[playlist.indexChapter].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 15)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            );
                          })),
                if (cubit.listHistory.isNotEmpty && !cubit.isGrid)
                  Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 20)
                        ),
                        children: [
                          ...cubit.listHistory.map((e) {
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, AudioBookDetailScreen(audioBook: e.audioBook), AppRoutes.audioBookDetail + e.audioBook.id.toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    NetworkImageCustom(
                                      url: e.audioBook.image,
                                      width: Resizable.size(context, 100),
                                      height: Resizable.size(context, 100),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.audioBook.title,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 20)),
                                          ),
                                          Text(
                                            e.audioBook.listMp3[e.indexChapter].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 15)),
                                          ),
                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}
