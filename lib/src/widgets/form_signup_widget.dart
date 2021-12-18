import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/msg_dialog.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool _show = false;
  String gen = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _pass2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context)!;
    return Container(
        child: Column(
      children: [
        Container(
          child: TextField(
            controller: _nameController,
            style: AppStyle.h5.copyWith(color: Colors.black),
            decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: AppStyle.h4.copyWith(color: AppColor.blackGrey)),
          ),
        ),
        Container(
          child: Row(
            children: [
              Text('Gender:'),
              Checkbox(
                checkColor: Colors.green,
                value: gen == 'male',
                onChanged: (bool? value) {
                  setState(() {
                    gen = 'male';
                  });
                },
              ),
              Checkbox(
                checkColor: Colors.green,
                value: gen == 'female',
                onChanged: (bool? value) {
                  setState(() {
                    gen = 'female';
                  });
                },
              ),
            ],
          ),
        ),
        Container(
          child: TextField(
            controller: _mailController,
            style: AppStyle.h5.copyWith(color: Colors.black),
            decoration: InputDecoration(
                labelText: 'EMAIL',
                labelStyle: AppStyle.h4.copyWith(color: AppColor.blackGrey)),
          ),
        ),
        Container(
          child: Stack(
            children: [
              TextField(
                controller: _passController,
                style: AppStyle.h5.copyWith(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    labelStyle:
                        AppStyle.h4.copyWith(color: AppColor.blackGrey)),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _show = !_show;
                  });
                },
                child: _show
                    ? const Text(
                        'HIDE',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    : const Text('SHOW',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        Container(
          child: Stack(
            children: [
              TextField(
                controller: _pass2Controller,
                style: AppStyle.h5.copyWith(color: Colors.black),
                decoration: InputDecoration(
                    labelText: ' ENTER PASSWORD AGAIN',
                    labelStyle:
                        AppStyle.h4.copyWith(color: AppColor.blackGrey)),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _show = !_show;
                  });
                },
                child: _show
                    ? const Text(
                        'HIDE',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    : const Text('SHOW',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        Container(
          child: TextField(
            controller: _phoneController,
            style: AppStyle.h5.copyWith(color: Colors.black),
            decoration: InputDecoration(
                labelText: 'PHONE NUMBER',
                labelStyle: AppStyle.h4.copyWith(color: AppColor.blackGrey)),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (_passController.text == _pass2Controller.text) {
                LoadingDialog.showLoadingDialog(context, 'Sign up');
                _authBloc.signUp(_nameController.text, _mailController.text,
                    _passController.text, gen, () {
                  LoadingDialog.hideLoadingDialog(context);
                  MsgDialog.showMsgDialog(context, 'Sign up', 'Success!!!');
                  _nameController.clear();
                  _mailController.clear();
                  _passController.clear();
                  _pass2Controller.clear();
                  _phoneController.clear();
                  Navigator.pop(context);
                }, (msg) {
                  LoadingDialog.hideLoadingDialog(context);
                  _nameController.clear();
                  _mailController.clear();
                  _passController.clear();
                  _pass2Controller.clear();
                  MsgDialog.showMsgDialog(context, 'Sign up', msg);
                });
              } else {
                MsgDialog.showMsgDialog(
                    context, 'Sign up', 'Your pass does not match');
              }
            },
            child: Text(
              'SIGN UP!',
              style: AppStyle.h3,
            )),
      ],
    ));
  }
}
