import 'package:ebook/configs/constants.dart';
import 'package:ebook/views/account/account_screen.dart';
import 'package:ebook/views/book_library/book_library.dart';
import 'package:ebook/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../blocs/player_cubit.dart';
import '../../configs/configs.dart';
import '../../view_models/library_provider.dart';
import '../audio_books/custom_mini_player.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with  LifecycleAware, LifecycleMixin {
  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if(event == LifecycleEvent.push || event == LifecycleEvent.visible || event == LifecycleEvent.active) {
      debugPrint('actice');
    }
    else {
      if(context.mounted){
        context.read<PlayerCubit>().pause();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    AppConfigs.contextApp = context;
    var child = [
      const HomePage(),
      const BookLibrary(),
      const AccountScreen(),
    ];

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
         icon: const Icon(Icons.home_outlined),
          title: ('Trang chủ'),
          activeColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  const Icon(Icons.menu_book),
          title: ("Thư viện"),
          activeColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  const Icon(Icons.account_circle_rounded),
          title: ("Tài khoản"),
          activeColorPrimary: purpleColor,
        ),
      ];
    }
    return Scaffold(
      body: BlocBuilder<PlayerCubit, int>(
        builder: (context, state) {
          final cubit = context.read<PlayerCubit>();

          return Scaffold(
            body: Stack(
              children: [
                PersistentTabView(
                  context,
                  screens: child,
                  controller: cubit.persistentTabController,
                  hideNavigationBar: !cubit.isMiniPlayer || cubit.isHideBottomNavigator,
                  items: navBarsItems(),
                  confineInSafeArea: true,
                  backgroundColor: Colors.white,
                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset: true,
                  stateManagement: true,
                  onItemSelected: (value) {
                    print(value);
                    if(value == 1) {
                      context
                          .read<LibraryCubit>()
                          .getData();
                    }
                  },
                  hideNavigationBarWhenKeyboardShows: true,
                  decoration: NavBarDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15)
                    ),
                    colorBehindNavBar: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: const ItemAnimationProperties(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle
                      .style9, // Choose the nav bar style with this property.
                ),
                const CustomMiniPlayer()
              ],
            ),
          );
        },
      ),

    );
  }
}
