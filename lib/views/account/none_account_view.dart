import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../app_routes.dart';
import '../../components/custom_button.dart';
import '../../configs/constants.dart';
import '../../util/resizable.dart';


class NoneAccountView extends StatelessWidget {
  const NoneAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30,),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 50, bottom: 20, right: 30, left: 30),
                decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Text(
                      'Đăng nhập để trải nghiệm tốt nhất',
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: textColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10,),
                    CustomButton(
                        title: 'Đăng nhập',
                        onTap: () {

                          Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.login);
                        },
                        radius: 1000,
                        height: 30,
                        width: 120,
                        fontWeight: FontWeight.bold,
                        backgroundColor: secondaryColor,
                        textColor: Colors.white),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.signUp);
                      },
                      child: Text(
                        'Đăng ký tài khoản mới',
                        style: TextStyle(
                            fontSize: Resizable.font(context, 15),
                            color: primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: primaryColor.withOpacity(0.4),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ],
    );
  }
}
