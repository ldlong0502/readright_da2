import 'package:auto_size_text/auto_size_text.dart';
import 'package:ebook/models/history_audio_book.dart';
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
import '../../util/navigator_custom.dart';
import '../../util/resizable.dart';

class RecentlyAudioBookView extends StatelessWidget {
  const RecentlyAudioBookView({super.key});


  @override
  Widget build(BuildContext context) {
    context.read<RecentlyPlayCubit>().load();
    return BlocBuilder<RecentlyPlayCubit,int>(
      builder: (context, state) {
        final cubit = context.read<RecentlyPlayCubit>();
        if(state == 0 || cubit.listHistory.isEmpty) return Container();

        var list = cubit.listHistory;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleSeeAll(title: 'Đã nghe gần đây', onSeeAll: () {
              NavigatorCustom.pushNewScreen(context, RecentlySeeAll(cubit:  cubit, title: 'Lịch sử nghe',), AppRoutes.recentlySeeAll);
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

                  var podcast = list[index].audioBook;
                  var episode = list[index].audioBook.listMp3[list[index].indexChapter];
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () async {
                        final cubit = context.read<PlayerCubit>();
                        if( !cubit.checkPermissionBeforeListen(podcast, list[index].indexChapter)) {
                          return;
                        }
                        await showDialog(context: context, builder: (context ) {
                          return DialogPlayHistory(
                            onPlayAgain: () {
                              cubit.listen(podcast,list[index].indexChapter );
                              Navigator.pop(context);

                          }, onPlayContinue: (){
                            cubit.listen(podcast,list[index].indexChapter , list[index].duration );
                            Navigator.pop(context);
                          } , historyAudioBook: list[index],);
                        });
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
                                      url: list[index].audioBook.image,
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
                                          child: Text(episode.title,
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
                                          child: Text('Đang nghe chương ${list[index].indexChapter + 1}',
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


class DialogPlayHistory extends StatelessWidget {
  const DialogPlayHistory({super.key, required this.onPlayAgain, required this.onPlayContinue, required this.historyAudioBook});
  final Function() onPlayAgain;
  final Function() onPlayContinue;
  final HistoryAudioBook historyAudioBook;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text('Lựa chọn của bạn', style: TextStyle(
                fontSize: Resizable.font(context, 20),
                color: textColor,
                fontWeight: FontWeight.w700
            ),),
            const SizedBox(height: 20,),
            Text('Nghe tiếp chương này?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 14),
                  color: secondaryColor,
                  fontWeight: FontWeight.w600
              ),),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 20)
      ).copyWith(top: 0),
      actions: [
        Column(
          children: [
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(onPressed: onPlayAgain,
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(color: primaryColor))
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Chơi lại' , style: TextStyle(fontWeight: FontWeight.w600),)
                        ],
                      )),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: TextButton(onPressed: onPlayContinue,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all( primaryColor)
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Chơi tiếp' , style: TextStyle(fontWeight: FontWeight.w600 ,color: Colors.white),)
                        ],
                      )),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}