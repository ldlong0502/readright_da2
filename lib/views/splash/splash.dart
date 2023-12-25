

import 'package:ebook/provider/local_provider.dart';
import 'package:ebook/util/const.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:ebook/views/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../app_routes.dart';
import '../../blocs/player_cubit.dart';
import '../../blocs/user_cubit.dart';
import '../../configs/constants.dart';
import '../../models/user_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    applicationInit(context);

    return  Container(
      decoration: linearDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Image.asset('assets/images/logo.png' , fit: BoxFit.cover, height: 50,)),
              const SizedBox(height: 30,),
              const SpinKitSpinningLines(
                color: Colors.orange,
                size: 50,
              )

            ],
          ),
        ),
      ),
    );
  }

  void applicationInit(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var user = await LocalProvider.instance.getJsonFromPrefs("user");
    String onBoarding = await LocalProvider.instance.getString("welcome");
    if(onBoarding.isEmpty || onBoarding == 'false') {
      if(context.mounted) {
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            AppRoutes.onboard, (route) => false);
      }
    } else {
      if(context.mounted) {
        context.read<PlayerCubit>().dismissMiniPlayer();
      }
      if(user == null) {
        if (context.mounted) {
          context.read<UserCubit>().update(null);
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRoutes.main, (route) => false,
              arguments: {'isLogin': false});
        }
      }
      else {
        var model = UserModel.fromJson(user);
        if (context.mounted) {
          context.read<UserCubit>().update(model);
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRoutes.main, (route) => false,
              arguments: {'isLogin': true});
        }
      }

    }

  }
}