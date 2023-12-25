import 'dart:io';

import 'package:ebook/api/api_audio_book.dart';
import 'package:ebook/api/api_ebook.dart';
import 'package:ebook/app_routes.dart';
import 'package:ebook/blocs/user_cubit.dart';
import 'package:ebook/firebase_options.dart';
import 'package:ebook/util/api.dart';
import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/details_audioBook_provider.dart';
import 'package:ebook/view_models/details_ebook_provider.dart';
import 'package:ebook/view_models/history_provider.dart';
import 'package:ebook/view_models/home_provider.dart';
import 'package:ebook/view_models/library_provider.dart';
import 'package:ebook/view_models/remind_provider.dart';
import 'package:ebook/view_models/search_provider.dart';
import 'package:ebook/view_models/speed_provider.dart';
import 'package:ebook/view_models/subject_provider.dart';
import 'package:ebook/views/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/player_cubit.dart';
import 'blocs/recently_play_cubit.dart';
import 'blocs/recently_reading_cubit.dart';
import 'theme/theme_config.dart';
import 'util/const.dart';
import 'view_models/app_provider.dart';
import 'view_models/book_mark_provider.dart';
import 'view_models/book_history_provider.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcmToken', fcmToken!);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var androidInitialize = const AndroidInitializationSettings('@mipmap/logo');
  var initializeSettings = InitializationSettings(android: androidInitialize);
  flutterLocalNotificationsPlugin.initialize(initializeSettings);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatTitle: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('readright', 'readright',
            importance: Importance.high,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
            playSound: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, platformChannelSpecifics,
        payload: message.data['click_action']);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    print('Message clicked!: ${message.data}');
    var clickData = message.data['click_action'] as String;
    var list = clickData.split('-');
    if (list[0] == 'ebook') {
      var listEbook = await ApiEbook.instance.getListBook();
      var item =
          listEbook.firstWhere((element) => element.id.toString() == list[1]);
      navigatorKey.currentState!
          .pushNamed(AppRoutes.bookDetail, arguments: {'book': item});
    } else {
      var listAudioBook = await ApiAudiobook.instance.getListBook();
      var item = listAudioBook
          .firstWhere((element) => element.id.toString() == list[1]);
      navigatorKey.currentState!.pushNamed(AppRoutes.audioBookDetail,
          arguments: {'audio_book': item});
    }
  });

  print('User granted permission: ${settings.authorizationStatus}');
  HttpOverrides.global = PostHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox('bookmark_books');
  await Hive.openBox('bookmark_audioBooks');
  await Hive.openBox('book_reading_books');
  await Hive.openBox('audio_books');
  await Hive.openBox('genre');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..checkWelcome()),
        ChangeNotifierProvider(create: (_) => AppBarProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..getBooks()),
        ChangeNotifierProvider(create: (_) => DetailsEbookProvider()),
        ChangeNotifierProvider(create: (_) => DetailsAudioBookProvider()),
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => BookHistoryProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => SpeedProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()..getBooks()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => RemindProvider()..checkRemind()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlayerCubit(context)),
        BlocProvider(create: (context) => RecentlyPlayCubit()),
        BlocProvider(create: (context) => RecentlyReadingCubit()),
        BlocProvider(create: (context) => LibraryCubit()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: Consumer<AppProvider>(
        builder:
            (BuildContext context, AppProvider appProvider, Widget? child) {
          return MaterialApp(
            key: appProvider.key,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            navigatorObservers: [defaultLifecycleObserver],
            title: Constants.appName,
            theme: themeData(appProvider.theme),
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: ThemeConfig.lightAccent,
      ),
    );
  }
}
