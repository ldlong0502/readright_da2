import 'package:ebook/api/api_auth.dart';
import 'package:ebook/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_routes.dart';
import '../../components/custom_button.dart';
import '../../components/loading_progress.dart';
import '../../util/custom_toast.dart';
import '../../util/resizable.dart';
import 'custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final  _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => LoginCubit(),
            child: BlocConsumer<LoginCubit, LoginStatus>(
              listener: (context, state)  async {
                if (state == LoginStatus.loading) {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return const LoadingDialog();
                    },
                  );
                }
                if (state == LoginStatus.failed) {
                 if(context.mounted) {
                   Navigator.pop(context);
                   await showDialog<void>(
                     context: context,
                     builder: (BuildContext dialogContext) {
                       return const LoginErrorDialog();
                     },
                   );
                 }
                }
                if (state == LoginStatus.success) {
                  CustomToast.showBottomToast(context, 'Đăng nhập thành công');
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(AppRoutes.splash, (route) => false);
                }
              },
              builder: (context, state) {
                final cubit = context.read<LoginCubit>();
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset('assets/images/logo.png',
                        height: Resizable.size(context, 150)),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                        child: Column(
                      children: [
                        CustomTextField(
                            controller: userNameController,
                            title: 'Email',
                            onValidate: (String value) {
                              debugPrint('validate: $value');
                              if(value.isEmpty) {
                                return 'Email trống';
                              }
                              return null;
                            },
                            isPassword: false),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            controller: passWordController,
                            title: 'Mật khẩu',
                            onValidate: (String value) {
                              if(value.isEmpty) {
                                return 'Mật khẩu trống';
                              }
                              return null;
                            },
                            isPassword: true),
                      ],
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        title: 'Đăng nhập',
                        onTap: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          _formKey.currentState!.save();
                          cubit.update(LoginStatus.loading);
                          var res = await ApiAuthentication.instance.login(
                              userNameController.text, passWordController.text);
                          if (res != null) {
                            cubit.update(LoginStatus.success);
                          } else {
                            cubit.update(LoginStatus.failed);
                          }
                        },
                        width: Resizable.width(context) * 0.8,
                        backgroundColor: primaryColor,
                        textColor: Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(
                              color: purpleColor,
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).popAndPushNamed(AppRoutes.signUp);
                          },
                          child: Text(
                            'Đăng kí',
                            style: TextStyle(
                                color: purpleColor,
                                fontSize: Resizable.font(context, 16),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum LoginStatus {
  start, loading, failed , success
}
class LoginCubit extends Cubit<LoginStatus> {
  LoginCubit() : super(LoginStatus.start);

  update(LoginStatus value) {
    if(isClosed) return;
    emit(value);
  }
}
class LoginErrorDialog extends StatelessWidget {
  const LoginErrorDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text('Sai tài khoản , mật khẩu',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  color: textColor,
                  fontWeight: FontWeight.w700
              ),),
            const SizedBox(height: 20,),
            Text('Vui lòng nhập lại tài khoản hoặc mật khẩu khác',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 14),
                  color: secondaryColor,
                  fontWeight: FontWeight.w600
              ),),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 20)
      ).copyWith(top: 0),
      actions: [
        Column(
          children: [
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Thử lại' , style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.black , fontSize: 20),)
                  ],
                )),
          ],
        )
      ],
    );
  }
}
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title:  Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 30)
          ),
          child:const LoadingProgress(),
        ),
      ),
    );
  }
}
