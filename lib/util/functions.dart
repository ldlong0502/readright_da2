import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebook/blocs/recently_reading_cubit.dart';
import 'package:ebook/configs/configs.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import '../models/book.dart';
import '../models/book_download.dart';

class Functions {
  final defaultLocation = {
    "bookId": "2239",
    "href": "/OEBPS/ch06.xhtml",
    "created": 1539934158390,
    "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
  };
  final hiveBookReading = Hive.box('book_reading_books');

  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  Future<Color> getImagePalette(String url) async {
    var imageProvider = NetworkImage(url);
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }

  void openEpub(filePath, BuildContext context, Book book) async {
    print(hiveBookReading.get(book.id));
    var data = BookDownLoad.fromJson(hiveBookReading.get(book.id) ??
        {
          'item': book.toJson(),
          'location': '',
          'dateDown': DateTime.now().millisecondsSinceEpoch,
          'dateReadRecently': DateTime.now().millisecondsSinceEpoch,
        });

    VocsyEpub.setConfig(
      themeColor: ThemeConfig.lightAccent,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: false,
    );

    // get current locator
    VocsyEpub.locatorStream.listen((locator) {
      print(locator.toString());
      var item = BookDownLoad(
          item: book,
          location: locator,
          dateDown: data.dateDown,
          dateReadRecently: DateTime.now().millisecondsSinceEpoch);
      hiveBookReading.put(book.id, item.toJson());
      AppConfigs.contextApp!.read<RecentlyReadingCubit>().load();
    });

    VocsyEpub.open(
      filePath,
      lastLocation: EpubLocator.fromJson(
          data.location == '' ? defaultLocation : json.decode(data.location)),
    );
  }

  Future<String> getPath(Book book) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    return '${appDocDir!.path}/${book.id}.epub';
  }

  void sendNotification( String title, String body, String clickMessage) async {
    try {
      Dio dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('fcmToken');
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] =
          'key=AAAAxCT30J0:APA91bHPCq2Mi6mi-Hwuit3v2MBc9EkUesFLh7gHru2ZLxC4pr_bjQmAVDYpy_TI_MRDRouaYnVU4J6mxeZWqVRakcXbzbVAm-ZZswe6kx7c0onBX2mOIW-rmDLYjGloI4P3YV3hC_CY'; // Replace with your FCM server key

      Map<String, dynamic> notification = {
        'title': title,
        'body': body,
      };

      Map<String, dynamic> message = {
        'notification': notification,
        "data": {
          "click_action": clickMessage,
          "sound": "default",
        },
        'to': token!,
      };

      Response response = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        data: message,
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
