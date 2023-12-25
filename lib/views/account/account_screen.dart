import 'package:ebook/configs/constants.dart';
import 'package:ebook/util/convert_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_auth.dart';
import '../../blocs/user_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/date_form_filed_custom.dart';
import '../../components/network_custom_image.dart';
import '../../models/user_model.dart';
import '../../util/resizable.dart';
import '../login/custom_text_field.dart';
import 'none_account_view.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: BlocBuilder<UserCubit, UserModel?>(
            builder: (context, state) {
              if(state == null) return const NoneAccountView();
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  NetworkImageCustom(
                    url: state.imageUrl,
                    borderRadius: BorderRadius.circular(1000),
                    width: Resizable.size(context, 220),
                    height: Resizable.size(context, 220),
                  ) ,
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Resizable.width(context) * 0.8,
                    child: TextFormField(
                      enabled: false,
                      initialValue: state.fullName,
                      cursorColor: Colors.purple,
                      style: const TextStyle(color: Colors.purple,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple))),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: () {

                    },
                    child: IgnorePointer(
                      child: CustomTextField(
                          controller: TextEditingController(text: state.email),
                          title: 'Email',
                          enabled: false,
                          
                          textColor: Colors.purple,
                          onValidate: (String value) {
                            debugPrint('validate: $value');
                            if (value.isEmpty) {
                              return 'Username is empty';
                            }
                            return null;
                          },
                          isPassword: false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  IgnorePointer(
                    child: DateFormFieldCustom(
                      controller: TextEditingController(text: ConvertUtils.convertDob(state.dateOfBirth)),
                      title: 'Ngày sinh',
                      textColor: Colors.purple,
                      onValidate: (String value) {
                        if (value.isEmpty) {
                          return 'Dob is empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(title: 'Đăng xuất',
                      onTap: () {
                        ApiAuthentication.instance.logOut(context);
                      },
                      backgroundColor: purpleColor,
                      textColor: Colors.white),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
