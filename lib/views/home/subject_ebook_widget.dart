import 'package:ebook/components/cache_image_ebook.dart';
import 'package:ebook/util/enum.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import '../../app_routes.dart';
import '../../theme/theme_config.dart';
import '../../util/navigator_custom.dart';
import '../../view_models/subject_provider.dart';
import '../../components/build_body.dart';
import '../ebook/book_detail_screen.dart';

class SubjectEbookWidget extends StatefulWidget {
  const SubjectEbookWidget({super.key, required this.idGenre});
  final int idGenre;
  @override
  State<SubjectEbookWidget> createState() => _SubjectEbookWidgetState();
}

class _SubjectEbookWidgetState extends State<SubjectEbookWidget> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<SubjectProvider>(context, listen: false)
          .getBooks(widget.idGenre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectProvider>(builder: (context, event, _) {
      return event.listBook.isEmpty
          ? _buildEmpty()
          : event.display == EnumDisplay.grid
              ? _buildGrid(event.sort, event)
              : _buildList(event.sort, event);
    });
  }

  _buildGrid(EnumSort sort, SubjectProvider event) {
    return BuildBody(
        apiRequestStatus: event.apiRequestStatus,
        child: _buildBodyGrid(event, sort),
        reload: () => event.getBooks(widget.idGenre));
  }

  _buildList(EnumSort sort, SubjectProvider event) {
    return BuildBody(
        apiRequestStatus: event.apiRequestStatus,
        child: _buildBodyList(event, sort),
        reload: () => event.getBooks(widget.idGenre));
  }

  _buildBodyGrid(SubjectProvider event, EnumSort sort) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: RefreshIndicator(
        onRefresh: () => event.getBooks(widget.idGenre),
        child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: event.listBook.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              var bookSort = [...event.listBook];
              if (event.sort == EnumSort.outstanding) {
                bookSort.sort((a, b) => b.view.compareTo(a.view));
              } else {
                bookSort.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              }
              var item = bookSort[index];
              return InkWell(
                onTap: () async {
                  NavigatorCustom.pushNewScreen(context, BookDetailScreen(
                    book: item,
                  ), AppRoutes.bookDetail + item.id.toString());
                },
                child: Container(
                  margin: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 230,
                          child: CacheImageEbook(url: item.image)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          item.title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Text(
                        item.author,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ThemeConfig.lightAccent,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  _buildBodyList(SubjectProvider event, EnumSort sort) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
      child: RefreshIndicator(
        onRefresh: () => event.getBooks(widget.idGenre),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: event.listBook.length,
            itemBuilder: (context, index) {
              var bookSort = [...event.listBook];
              if (event.sort == EnumSort.outstanding) {
                bookSort.sort((a, b) => b.view.compareTo(a.view));
              } else {
                bookSort.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              }
              var item = bookSort[index];

              return InkWell(
                onTap: () async {
                  NavigatorCustom.pushNewScreen(context, BookDetailScreen(
                    book: item,
                  ), AppRoutes.bookDetail + item.id.toString());
                },
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Colors.grey,
                    )),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                            width: 70, child: CacheImageEbook(url: item.image)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  child: Text(
                                    item.title,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                              Text(
                                item.author,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeConfig.lightAccent,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Container(
                                height: 30,
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.menu_book),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(item.pages.toString())
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(Icons.remove_red_eye),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(item.view.toString())
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(item.year.toString())
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  _buildEmpty() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                alignment: Alignment.center,
                child: const Text(
                  'Danh sách trống! Đợi chúng tôi thêm chủ đề này vào nhé.',
                  maxLines: 2,
                  style: TextStyle(fontSize: 20),
                )),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '^_^',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
