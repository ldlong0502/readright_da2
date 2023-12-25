import 'dart:async';
import 'dart:math';

import 'package:ebook/api/api_audio_book.dart';
import 'package:ebook/api/api_ebook.dart';
import 'package:ebook/blocs/player_cubit.dart';
import 'package:ebook/blocs/user_cubit.dart';
import 'package:ebook/components/audio_image.dart';
import 'package:ebook/components/cache_image_ebook.dart';
import 'package:ebook/models/book_download.dart';
import 'package:ebook/models/recent_audio_book.dart';
import 'package:ebook/models/user_model.dart';
import 'package:ebook/util/const.dart';
import 'package:ebook/util/functions.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/book_history_provider.dart';
import 'package:ebook/view_models/history_provider.dart';
import 'package:ebook/view_models/remind_provider.dart';
import 'package:ebook/views/ebook/ebook_home.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/views/home/recently_audio_book_view.dart';
import 'package:ebook/views/home/recently_widget.dart';
import 'package:ebook/views/home/remind_book.dart';
import 'package:ebook/views/search_page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../components/custom_search.dart';
import '../../configs/constants.dart';
import '../../util/api.dart';
import '../../util/dialogs.dart';
import '../audio_books/audio_home.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
     });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late DateTime _dateTime = DateTime.now();
  var listSubject = [
    {
      'title': 'SÁCH NÓI',
      'asset': 'assets/images/audio_book.png',
      'widget': const AudioHome()
    },
    {
      'title': 'EBOOK',
      'asset': 'assets/images/ebook.png',
      'widget': const EbookHome()
    },
  ];
  List<String> bookQuotes = [
    "Sách là hành trang tốt nhất của con người.",
    "Cuốn sách hay nhất là người bạn trung thành nhất.",
    "Sách là cầu nối giữa quá khứ và tương lai.",
    "Đọc sách giúp con người mở rộng tầm nhìn và khám phá thế giới.",
    "Có cuốn sách phù hợp, bạn sẽ luôn có một người bạn đáng tin cậy.",
    "Sách là kho báu vô hạn của tri thức và trí tưởng tượng.",
    "Một cuốn sách hay có thể thay đổi cuộc đời của bạn.",
    "Từng trang sách là một chặng đường khám phá mới.",
    "Sách giúp ta tìm thấy những ý tưởng và suy nghĩ mới.",
    "Đọc sách không chỉ giúp ta tăng kiến thức, mà còn nuôi dưỡng tâm hồn."
  ];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<BookHistoryProvider>(context, listen: false).getInfo(),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HistoryProvider>(context, listen: false).loadHistory(),
    );
    Timer.periodic(const Duration(seconds:1), (timer) {
      if (!mounted) return;
      setState(() {
        _dateTime = DateTime.now();
      });
      sendNotification();
    });

    
    super.initState();
  }
  void sendNotification() async {
      final remindProvider = context.read<RemindProvider>();
      if(remindProvider.isRemind) {
          var alarm = remindProvider.timeAlarm;
          if(_dateTime.hour == alarm.hour && _dateTime.minute == alarm.minute && _dateTime.second == 0 ) {
            


            Random random =  Random();
            var isEbook = random.nextInt(2) == 0;
            if(isEbook) {
              var listEbook = await ApiEbook.instance.getListBook();
              var indexBook = random.nextInt(listEbook.length);
              var indexQuote = random.nextInt(bookQuotes.length);
              Functions().sendNotification(listEbook[indexBook].title, bookQuotes[indexQuote] , 'ebook-${listEbook[indexBook].id}');
            }
            else {
              var listAudioBook = await ApiAudiobook.instance.getListBook();
              var indexBook = random.nextInt(listAudioBook.length);
              var indexQuote = random.nextInt(bookQuotes.length);
              Functions().sendNotification(listAudioBook[indexBook].title, bookQuotes[indexQuote] , 'audio_book-${listAudioBook[indexBook].id}');
            }

          }
      }
   }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height:  size.height * 0.35,
            decoration: linear1Decoration.copyWith(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // IconButton(onPressed: () async{
                  //   Functions().sendNotification('hello', 'hello');
                  // }, icon: const Icon(Icons.text_snippet)),

                  const SizedBox(
                    height: 30,
                  ),
                  _buildHeader(context),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildGreeting(context),
                  _buildStyle(),

                ],
              ),
            ),
          ),
          Container(
            color: purpleColor,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40))),
                child: const Home()),
          ),
        ],
      ),
    );
  }

  _buildHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSearch(context),
         IconButton(
           color: Colors.white,
           onPressed: () {
              showModalBottomSheet(
         
               isScrollControlled: true,
               
               context: context,
               builder: (BuildContext context) {
                 return const RemindBookDialog(
                 );
               },
             );
           },
           icon: Consumer<RemindProvider>(
             builder: (context , event, _) {
               return  Icon( event.isRemind? Icons.alarm : Icons.alarm_off);
             }
           ),
         ),
      ],
    );
  }

  _buildSearch(BuildContext context) {
    return Consumer<AppBarProvider>(
      builder: (context, event, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => MyRouter.pushAnimationChooseType(
                  context, const SearchPage(), PageTransitionType.fade),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5),
                height: 45,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child:
                          Icon(Icons.search, color: ThemeConfig.lightPrimary),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Tìm kiếm tác giả, tên sách...',
                        maxLines: 1,
                        style: TextStyle(
                            color: ThemeConfig.lightPrimary,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _searchBook(BuildContext context) {
    showSearch(context: context, delegate: CustomSearch());
  }

  _buildGreeting(BuildContext context) {
    print(DateTime.now().hour);
    var map = {};
    if (_dateTime.hour >= 4 && _dateTime.hour <= 11) {
      map = {'asset': 'assets/images/sunny.png', 'greeting': 'Chào buổi sáng'};
    } else if (_dateTime.hour >= 12 && _dateTime.hour <= 13) {
      map = {'asset': 'assets/images/noon.png', 'greeting': 'Buổi trưa vui vẻ'};
    } else if (_dateTime.hour > 13 && _dateTime.hour <= 17) {
      map = {'asset': 'assets/images/noon.png', 'greeting': 'Chào buổi chiều'};
    } else if (_dateTime.hour > 17 && _dateTime.hour <= 23) {
      map = {'asset': 'assets/images/night.png', 'greeting': 'Buổi tối vui vẻ'};
    } else {
      map = {'asset': 'assets/images/owl.png', 'greeting': 'Chào cú đêm'};
    }
    return BlocBuilder<UserCubit, UserModel?>(
  builder: (context, state) {
    return ListTile(
      leading: Image.asset(
        map['asset'] as String,
        height: 30,
      ),
      title: Text(
        '${map['greeting'] as String}${state == null ? '' : ', \n${state.fullName}'}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  },
);
  }

  _buildStyle() {
    return SizedBox(
      height: 120,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: listSubject
                .map((e) => InkWell(
                      onTap: () {
                        MyRouter.pushAnimation(context, e['widget'] as Widget);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Colors.grey[350]!.withOpacity(0.2),
                              child: Image.asset(
                                e['asset'] as String,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              e['title'] as String,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList()),
      ),
    );
  }

  _buildText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Đã đọc / nghe gần đây',
          maxLines: 2,
          style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
  
 
}
