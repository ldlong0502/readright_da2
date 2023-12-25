
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/views/audio_books/audio_book_detail_screen.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:ebook/views/ebook/book_detail_screen.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:ebook/views/login/login_screen.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:ebook/views/on_boarding/on_boarding.dart';
import 'package:ebook/views/sign_up/sign_up_screen.dart';
import 'package:ebook/views/splash/splash.dart';
import 'package:ebook/views/welcome/welcome.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const splash = '/';
  static const onboard = '/onboard';
  static const home = '/home';
  static const main = '/main';
  static const bookDetail = '/bookDetail';
  static const audioBookDetail = '/audioBookDetail';
  static const recentlySeeAll = '/recentlySeeAll';
  static const recentlyBookSeeAll = '/recentlyBookSeeAll';
  static const login = '/login';
  static const signUp = '/signUp';
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
            builder: (context) => const SplashScreen(), settings: settings);
      case AppRoutes.onboard:
        return MaterialPageRoute(
            builder: (context) => const WelcomeScreen(), settings: settings);
      case AppRoutes.login:
        return MaterialPageRoute(
            builder: (context) => const LoginScreen(), settings: settings);
      case AppRoutes.signUp:
        return MaterialPageRoute(
            builder: (context) => const SignUpScreen(), settings: settings);
      case AppRoutes.main:
        return MaterialPageRoute(
            builder: (context) => const MainScreen(),
            settings: settings);
      case AppRoutes.bookDetail:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => BookDetailScreen(
              book: map['book'],
            ),
            settings: settings);
      case AppRoutes.audioBookDetail:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AudioBookDetailScreen(
              audioBook: map['audio_book'],
            ),
            settings: settings);
    }

    return null;
  }
}
