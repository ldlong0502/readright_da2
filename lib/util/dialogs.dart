import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:ebook/app_routes.dart';
import 'package:ebook/blocs/player_cubit.dart';
import 'package:ebook/components/chapter_dialog.dart';
import 'package:ebook/components/download_alert.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/convert_utils.dart';
import 'package:ebook/util/enum.dart';
import 'package:ebook/util/resizable.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/library_provider.dart';
import 'package:ebook/views/audio_books/audio_book_detail_screen.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../blocs/comment_cubit.dart';
import '../components/custom_alert.dart';
import '../components/speed_dialog.dart';
import '../configs/constants.dart';
import '../models/book.dart';
import '../models/mp3_file.dart';
import '../view_models/subject_provider.dart';
import '../views/ebook/book_detail_screen.dart';
import 'const.dart';
import 'custom_toast.dart';
import 'navigator_custom.dart';

class Dialogs {
  static void showComment(BuildContext context, CommentCubit cubit) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SizedBox(
            height: Resizable.height(context) * 0.8,
            child:  ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(
              Resizable.padding(context, 20)
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              ...cubit.listComment.toList().map((e) {
                final time = ConvertUtils.convertIntToDateTime(e.createdAt);
                final index = cubit.listComment.indexOf(e);
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
                      const SizedBox(height: 5,),
                      Text('Boi ${cubit.listUserModel[index].fullName} vào lúc $time'.toUpperCase(),
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
              const SizedBox(height: 20,),
            ],
          ),
          );
        });
  }

  static void showChapter(BuildContext context, PlayerCubit cubit) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SizedBox(
            height: Resizable.height(context) * 0.9,
            child: Column(
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chương ',
                        style: TextStyle(
                            color: purpleColor,
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      CircleAvatar(
                          radius: 15,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.clear_rounded,
                                size: 15,
                              )))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Resizable.padding(context, 20)),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...cubit.currentAudioBook!.listMp3.toList().map((e) {
                          final isListen = cubit.indexChapter + 1 == e.id;
                          return GestureDetector(
                            onTap: () {
                              if (!isListen) {
                                Navigator.pop(context);
                                cubit.changeChapter(e.id - 1);
                              } else {
                                CustomToast.showBottomToast(
                                    context, 'Bạn đang nghe chương này rồi!');
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: Resizable.padding(context, 20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 20),
                                  vertical: Resizable.padding(context, 10)),
                              decoration: BoxDecoration(
                                  color: !isListen
                                      ? Colors.white70
                                      : Colors.deepOrangeAccent
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1000),
                                  border: !isListen
                                      ? Border.all(color: purpleColor)
                                      : null),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.headset,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        if (isListen)
                                          AutoSizeText(
                                            'Bạn đang nghe',
                                            style: TextStyle(
                                                fontSize:
                                                Resizable.font(context, 12),
                                                color: Colors.black
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        AutoSizeText(
                                          e.title,
                                          style: TextStyle(
                                              fontSize:
                                              Resizable.font(context, 18),
                                              color:
                                              purpleColor.withOpacity(0.9),
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isListen)
                                    AvatarGlow(
                                      glowColor: Colors.blue,
                                      endRadius: 30.0,
                                      duration:
                                      const Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration:
                                      const Duration(milliseconds: 100),
                                      child: Material(
                                        // Replace this child with your own
                                        elevation: 8.0,
                                        shape: const CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade300,
                                          radius: 15.0,
                                          child: Icon(
                                            Icons.volume_down_rounded,
                                            color: pinkColor,
                                            size: Resizable.size(context, 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
  showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15.0),
              Text(
                Constants.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 25.0),
              const Text(
                'Bạn muốn thoát?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: TextButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => exit(0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  showSetUpBottomDialog(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 400,
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
                _buildTitle(context , 'Thiết lập'),
                const SizedBox(
                  height: 10,
                ),
                _buildText('Hiển thị'),
                _buildDisplay(context),
                _buildText('Sắp xếp'),
                _buildSort(context),
              ],
            ),
          );
        });
  }

  showChapterBottomDialog(
      BuildContext context,
      List<Mp3File> listMp3,
      int index,
      Function onChooseChapter) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ChapterDialog(
            listMp3: listMp3,
            index: index,
            onChooseChapter: onChooseChapter,
          );
        });
  }

  showSpeedBottomDialog(BuildContext context, Function onChooseSpeed) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SpeedDialog(
            onChooseSpeed: onChooseSpeed,
          );
        });
  }

  showDownloadsDialog(BuildContext context , Book book) {
    var actionDownloads = [
      {
        'icon': Icon(
          Icons.menu_book_rounded,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Đọc ngay',
        'onTap': () async {
          Navigator.of(context).pop();
          Dialogs().showEpub(context, book);
        }
      },
      {
        'icon': Icon(
          Icons.info,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Thông tin sách',
        'onTap': () {
          Navigator.of(context).pop();
          NavigatorCustom.pushNewScreen(context, BookDetailScreen(
            book: book,
          ), AppRoutes.bookDetail + book.id.toString());
        }
      },
      {
        'icon': Icon(
          Icons.share,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Chia sẻ',
        'onTap': () {
         Navigator.of(context).pop();
        }
      },
      {
        'icon': Icon(
          Icons.remove_circle_outline_rounded,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Xóa khỏi danh sách đã tải/đang đọc',
        'onTap': () {
          Navigator.of(context).pop();
          context.read<LibraryCubit>().removeBookDownload(book);
          showSnackBar(context, 'Đã xóa khỏi danh sách');
        }
      }
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45 + 20,
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
                const SizedBox(
                  height: 10,
                ),
                _buildTitle(context, 'Tùy chọn thêm'),
                ListView(
                  shrinkWrap: true,
                  children: actionDownloads
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                        onTap: e.value['onTap'] as Function(),
                        child: ListTile(
                          leading: e.value['icon'] as Widget,
                          title: Text(e.value['title'] as String),
                        ),
                      ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }

  showFavoritesDialog(BuildContext context, dynamic item) {
    var actionFavorites = [
      {
        'icon': Icon(
         item is Book ? Icons.menu_book_rounded : Icons.headphones,
          color: ThemeConfig.thirdAccent,
        ),
        'title': item is Book ? 'Đọc ngay' : 'Nghe ngay',
        'onTap': () async {
          Navigator.of(context).pop();
          if(item is Book) {
             Dialogs().showEpub(context, item);
          }
          else if (item is AudioBook){
            context.read<AudioProvider>().createPlayer(item, AudioPlayer(), context);
          }
        }
      },
      {
        'icon': Icon(
          Icons.info,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Thông tin sách',
        'onTap': () {
          Navigator.of(context).pop();
          if(item is Book){
            NavigatorCustom.pushNewScreen(context, BookDetailScreen(
              book: item,
            ), AppRoutes.bookDetail + item.id.toString());
          }
          else if (item is AudioBook){
            NavigatorCustom.pushNewScreen(context,  AudioBookDetailScreen(
                audioBook: item ) , AppRoutes.audioBookDetail + item.id.toString());
          }
        }
      },
      {
        'icon': Icon(
          Icons.share,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Chia sẻ',
        'onTap': () {
          Navigator.of(context).pop();
        }
      },
      {
        'icon': Icon(
          Icons.remove_circle_outline_rounded,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Xóa khỏi danh sách yêu thích',
        'onTap': () {
          Navigator.of(context).pop();
          if(item is Book){
             context.read<LibraryCubit>().removeBookFavorites(item);
          }
         else if (item is AudioBook){
          context.read<LibraryCubit>().removeAudioBookFavorites(item);
         }
         showSnackBar(context, 'Đã xóa khỏi danh sách');
        }
      }
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45 + 20,
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
                const SizedBox(
                  height: 10,
                ),
                _buildTitle(context, 'Tùy chọn thêm'),
                ListView(
                  shrinkWrap: true,
                  children: actionFavorites
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                            onTap: e.value['onTap'] as Function(),
                            child: ListTile(
                              leading: e.value['icon'] as Widget,
                              title: Text(e.value['title'] as String),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }

  showHistoryDialog(BuildContext context, dynamic item) {
    var actionFavorites = [
      {
        'icon': Icon(
          item is Book ? Icons.menu_book_rounded : Icons.headphones,
          color: ThemeConfig.thirdAccent,
        ),
        'title': item is Book ? 'Đọc ngay' : 'Nghe ngay',
        'onTap': () async {
          Navigator.of(context).pop();
          if (item is Book) {
            Dialogs().showEpub(context, item);
          } else if (item is AudioBook) {
            context
                .read<AudioProvider>()
                .createPlayer(item, AudioPlayer(), context);
          }
        }
      },
      {
        'icon': Icon(
          Icons.info,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Thông tin sách',
        'onTap': () {
          Navigator.of(context).pop();
          if (item is Book) {
            NavigatorCustom.pushNewScreen(context, BookDetailScreen(
              book: item,
            ), AppRoutes.bookDetail + item.id.toString());
          } else if (item is AudioBook) {
            NavigatorCustom.pushNewScreen(context,  AudioBookDetailScreen(
                audioBook: item ) , AppRoutes.audioBookDetail + item.id.toString());
          }
        }
      },
      {
        'icon': Icon(
          Icons.share,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Chia sẻ',
        'onTap': () {
          Navigator.of(context).pop();
        }
      },
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35 + 20,
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
                const SizedBox(
                  height: 10,
                ),
                _buildTitle(context, 'Tùy chọn thêm'),
                ListView(
                  shrinkWrap: true,
                  children: actionFavorites
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                            onTap: e.value['onTap'] as Function(),
                            child: ListTile(
                              leading: e.value['icon'] as Widget,
                              title: Text(e.value['title'] as String),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }
  _buildTitle(context, String s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
       
         Center(
           child: Text(
             s,
             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: ThemeConfig.lightAccent),
           ),
         ),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 18,
            child: IconButton(
              icon: const Icon(Icons.clear_outlined , size: 18,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ]),
    );
  }

  _buildDisplay(BuildContext context) {
    var listDisplay = [
      {
        'icon': const Icon(Icons.grid_view),
        'title': 'Lưới',
        'value': EnumDisplay.grid,
        'text': 'grid'
      },
      {
        'icon': const Icon(Icons.list_rounded),
        'title': 'Danh sách',
        'value': EnumDisplay.list,
        'text': 'list'
      }
    ];
    return Consumer<SubjectProvider>(
      builder: (context, event, _) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
              itemCount: listDisplay.length,
              itemBuilder: (ctx, index) => ListTile(
                    onTap: () {
                      if (listDisplay[index]['value'] == event.display) {
                        Navigator.pop(context);
                        return;
                      }
                      Provider.of<SubjectProvider>(context, listen: false)
                          .setDisplay(listDisplay[index]['value'],
                              listDisplay[index]['text']);
                      Navigator.pop(context);
                    },
                    leading: listDisplay[index]['icon'] as Icon,
                    title: Text(listDisplay[index]['title'] as String),
                    trailing: event.display ==
                            (listDisplay[index]['value'] as EnumDisplay)
                        ? const Icon(Icons.check)
                        : null,
                  )),
        );
      },
    );
  }

  _buildSort(BuildContext context) {
    var listSort = [
      {'title': 'Mới nhất', 'value': EnumSort.latest, 'text': 'latest'},
      {'title': 'Nổi bật', 'value': EnumSort.outstanding, 'text': 'outstanding'}
    ];
    return Consumer<SubjectProvider>(
      builder: (context, event, _) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
              itemCount: listSort.length,
              itemBuilder: (ctx, index) => ListTile(
                  onTap: () {
                    if (listSort[index]['value'] == event.sort) {
                      Navigator.pop(context);
                      return;
                    }
                    Provider.of<SubjectProvider>(context, listen: false)
                        .setSort(
                            listSort[index]['value'], listSort[index]['text']);
                    Navigator.pop(context);
                  },
                  title: Text(listSort[index]['title'] as String),
                  trailing: event.sort == (listSort[index]['value'] as EnumSort)
                      ? const Icon(Icons.check)
                      : null)),
        );
      },
    );
  }

  _buildText(String s) {
    return SizedBox(
      height: 50,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            s,
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeConfig.thirdAccent
            ),
          ),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          thickness: 1,
        )
      ]),
    );
  }

  showEpub(BuildContext context, Book book) async {
   
    await showDialog(
        context: context,
        builder: (context) => DownloadAlert(
              book: book,
            ));
    context.read<LibraryCubit>().getData();
  }


  showSnackBar( BuildContext context ,String title){ 
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
            title,
            style: TextStyle(color: ThemeConfig.lightAccent),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 15),
      padding: const EdgeInsets.all(15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ));
  }
}
