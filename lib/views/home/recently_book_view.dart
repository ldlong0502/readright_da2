import 'package:auto_size_text/auto_size_text.dart';
import 'package:ebook/blocs/recently_reading_cubit.dart';
import 'package:ebook/models/history_audio_book.dart';
import 'package:ebook/views/home/recently_book_see_all.dart';
import 'package:ebook/views/home/recently_see_all.dart';
import 'package:ebook/views/home/title_see_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../app_routes.dart';
import '../../blocs/player_cubit.dart';
import '../../blocs/recently_play_cubit.dart';
import '../../components/network_custom_image.dart';
import '../../configs/constants.dart';
import '../../util/dialogs.dart';
import '../../util/navigator_custom.dart';
import '../../util/resizable.dart';

class RecentlyBookView extends StatelessWidget {
  const RecentlyBookView({super.key});


  @override
  Widget build(BuildContext context) {
    context.read<RecentlyReadingCubit>().load();
    return BlocBuilder<RecentlyReadingCubit,int>(
      builder: (context, state) {
        final cubit = context.read<RecentlyReadingCubit>();
        if(state == 0 || cubit.listHistory.isEmpty) return Container();

        var list = cubit.listHistory;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleSeeAll(title: 'Đã đọc gần đây', onSeeAll: () {
              NavigatorCustom.pushNewScreen(context, RecentlyBookSeeAll(cubit:  cubit, title: 'Lịch sử đọc',), AppRoutes.recentlyBookSeeAll);
            }),
            GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                  vertical: Resizable.padding(context, 10),

                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length >=4 ? 4 : list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: Resizable.size(context, 10),
                  mainAxisSpacing: Resizable.size(context, 10),

                ), itemBuilder: (context , index) {

              var book = list[index].item;
              var locator = list[index].location;
              print(locator);
              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: () async {
                    Dialogs().showEpub(context, book);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: LayoutBuilder(
                                builder: (context , c) {
                                  return NetworkImageCustom(
                                    url: book.image,
                                    height: c.maxHeight,
                                    width: c.maxWidth,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  );
                                }
                            )),
                        Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: primaryColor.withOpacity(0.1)
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 15),
                                  vertical: Resizable.padding(context, 10)
                              ),
                              child: Column(
                                children: [

                                  Expanded(
                                    child: Align(
                                      alignment:Alignment.centerLeft,
                                      child: Text(book.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: Resizable.font(context, 14),
                                            color: primaryColor,
                                            fontWeight: FontWeight.w700
                                        ),),
                                    ),
                                  ),
                                  Expanded(
                                    child:  Align(
                                      alignment:Alignment.centerLeft,
                                      child: Text('',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: Resizable.font(context, 14),
                                            color: primaryColor,
                                            fontWeight: FontWeight.w700
                                        ),),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 10,),
          ],
        );
      },
    );
  }
}

