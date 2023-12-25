import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../api/api_auth.dart';
import '../../app_routes.dart';
import '../../components/custom_button.dart';
import '../../components/date_form_filed_custom.dart';
import '../../configs/constants.dart';
import '../../util/convert_utils.dart';
import '../../util/custom_toast.dart';
import '../../util/resizable.dart';
import '../login/custom_text_field.dart';
import '../login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController =
      TextEditingController(text: ConvertUtils.convertDob(DateTime.now()));
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryColor),
        automaticallyImplyLeading: false,
        title: const Text('Đăng ký',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => SignUpCubit(),
            child: BlocConsumer<SignUpCubit, SignUpStatus>(
              listener: (context, state) async {
                if (state == SignUpStatus.loading) {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return const LoadingDialog();
                    },
                  );
                }
                if (state == SignUpStatus.failed) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return const LoginErrorDialog();
                      },
                    );
                  }
                }
                if (state == SignUpStatus.success) {
                  CustomToast.showBottomToast(context, 'Sign up successfully');
                  Navigator.of(context, rootNavigator: true)
                      .popAndPushNamed(AppRoutes.login);
                }
              },
              builder: (context, state) {
                final cubit = context.read<SignUpCubit>();
                return Column(
                  children: [
                    Image.asset('assets/images/logo.png',
                        height: Resizable.size(context, 150)),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                                controller: emailController,
                                title: 'Email',
                                onValidate: (String value) {
                                  debugPrint('validate: $value');
                                  if (value.isEmpty) {
                                    return 'Email thì trống';
                                  }
                                  return null;
                                },
                                isPassword: false),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                                controller: fullNameController,
                                title: 'Họ Và Tên',
                                onValidate: (String value) {
                                  debugPrint('validate: $value');
                                  if (value.isEmpty) {
                                    return 'Tên is empty';
                                  }
                                  return null;
                                },
                                isPassword: false),
                            const SizedBox(
                              height: 20,
                            ),
                            DateFormFieldCustom(
                              controller: dobController,
                              title: 'Ngày sinh',
                              onValidate: (String value) {
                                if (value.isEmpty) {
                                  return 'Ngày sinh is empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                                controller: passWordController,
                                title: 'Mật khẩu',
                                onValidate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Mật khẩu is empty';
                                  }
                                  return null;
                                },
                                isPassword: true),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        title: 'Đăng ký',
                        onTap: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          // _formKey.currentState!.save();
                          // cubit.update(SignUpStatus.loading);
                          // var res = await ApiAuthentication.instance.signUp(
                          //       emailController.text,
                          //   fullNameController.text,
                          //   userNameController.text,
                          //   dobController.text,
                          //   passWordController.text
                          // );
                          // if (res) {
                          //   cubit.update(SignUpStatus.success);
                          // } else {
                          //   cubit.update(SignUpStatus.failed);
                          // }
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
                          'Đã có tài khoản?',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .popAndPushNamed(AppRoutes.login);
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                                color: primaryColor,
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

enum SignUpStatus { start, loading, failed, success }

class SignUpCubit extends Cubit<SignUpStatus> {
  SignUpCubit() : super(SignUpStatus.start);

  update(SignUpStatus value) {
    if (isClosed) return;
    emit(value);
  }
}
