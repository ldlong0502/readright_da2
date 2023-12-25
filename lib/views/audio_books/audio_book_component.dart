import 'package:ebook/components/build_body.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/views/audio_books/audio_book_subject.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_routes.dart';
import '../../components/audio_image.dart';
import '../../models/genre.dart';
import '../../util/navigator_custom.dart';
import '../home/top5_widget.dart';
import 'audio_book_detail_screen.dart';

class AudioBookComponent extends StatefulWidget {
  const AudioBookComponent({super.key});
  @override
  State<AudioBookComponent> createState() => _AudioBookComponentState();
}

class _AudioBookComponentState extends State<AudioBookComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<AudioProvider>(
        builder: (BuildContext context, AudioProvider event, Widget? child) {
      return BuildBody(
          apiRequestStatus: event.apiRequestStatus,
          child: _buildBodyList(event, size),
          reload: () => event.getBooks());
    });
  }

  _buildBodyList(AudioProvider event, Size size) {
    return RefreshIndicator(
      onRefresh: () => event.getBooks(),
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
          _buildSectionTitle('Danh mục'),
          const SizedBox(height: 20.0),
          _buildGenre(event, size),
          const SizedBox(height: 20.0),
          _buildSectionTitle('Top 5 trending'),
          _buildSlider(event, size),
          const SizedBox(height: 10.0),
          _buildSectionTitle('Mới nhất'),
          const SizedBox(height: 10.0),
          _buildRecentBooks(event),

          // SizedBox(height: 20.0),
          // _buildRecentBooks('Recently Added'),
        ],
      ),
    );
  }

  _buildSlider(AudioProvider event, Size size) {
    final list = event.top5;
    final listWidget = List.generate(
      list.length,
      (index) => _buildBook(event, list[index], index),
    )..add(IconButton(
        onPressed: () {
          MyRouter.pushAnimation(
              context,
              Top5Widget(
                list: event.top5,
                title: 'Top 5 trending',
              ));
        },
        icon: CircleAvatar(
            backgroundColor: ThemeConfig.fourthAccent,
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ))));
    return Container(
        height: 170,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: listWidget));
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              color: ThemeConfig.lightAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBook(AudioProvider event, AudioBook book, int index) {
    return InkWell(
      onTap: () async {
        NavigatorCustom.pushNewScreen(context,  AudioBookDetailScreen(
            audioBook: book ) , AppRoutes.audioBookDetail + book.id.toString());
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            width: 120,
            child: AudioImage(
              audioBook: book,
              size: 50,
            ),
          ),
          Positioned(
              bottom: 10,
              left: 30,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: ThemeConfig.fourthAccent,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }

  _buildRecentBooks(AudioProvider event) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: event.recent.length,
      itemBuilder: (BuildContext context, int index) {
        var book = event.recent[index];

        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 000.0),
            child: InkWell(
              onTap: () async {
                NavigatorCustom.pushNewScreen(context,  AudioBookDetailScreen(
                    audioBook: book ) , AppRoutes.audioBookDetail + book.id.toString());
              },
              child: SizedBox(
                height: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 120,
                          child: AudioImage(
                            audioBook: book,
                            size: 50,
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              child: Text(
                                book.title,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                book.author,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeConfig.lightAccent,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                book.description,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeConfig.authorColor,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ));
      },
    );
  }

 

  _buildGenre(AudioProvider event, Size size) {
    var listGenre =
     event.listGenre.take(  event.listGenre.length ~/ 2).toList();
    var listGenre1 =
      event.listGenre.reversed.take( event.listGenre.length ~/ 2).toList();
    return SizedBox(
        height: size.height * 0.12,
        
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
             children: [
               _buildRowGenre(listGenre , size),
               const SizedBox(height: 10,),
              _buildRowGenre(listGenre1 , size),
             ],
              ),
        ));
  }
 _buildRowGenre(List<Genre> value, size) {
   
    return SizedBox(
      height: size.height * 0.05,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: value.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildItemGenre(value[index]);
          }),
    );
  }

  _buildItemGenre(Genre value) {
    return InkWell(
      onTap: (){
        MyRouter.pushAnimation(context, AudioBookSubject(genre: value));
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                value.icon,
                height: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                value.name,
                style: TextStyle(fontSize: 14, color: ThemeConfig.lightAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
