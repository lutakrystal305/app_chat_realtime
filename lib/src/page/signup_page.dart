import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/value/app_assets.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/msg_dialog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        backgroundColor: AppColor.secondColor,
      ),
      backgroundColor: AppColor.primaryColor,
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 15.0),
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Image.asset(AppAssets.logo,
                        width: 70, height: 50, fit: BoxFit.contain),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'KMess',
                        style: AppStyle.h4.copyWith(color: Colors.green),
                      ),
                    )
                  ],
                )),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Text(
                'Sign Up',
                style: AppStyle.h4,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: TextField(
                      controller: _nameController,
                      style: AppStyle.h5.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.0, color: Colors.green)),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.green,
                          ),
                          labelText: 'Name',
                          labelStyle:
                              AppStyle.h5.copyWith(color: AppColor.whiteGrey)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Gender:',
                          style: AppStyle.h5,
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Checkbox(
                            activeColor: Colors.green[200],
                            checkColor: Colors.green,
                            value: gen == 'male',
                            onChanged: (bool? value) {
                              setState(() {
                                gen = 'male';
                              });
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Checkbox(
                            activeColor: Colors.green[200],
                            checkColor: Colors.green,
                            value: gen == 'female',
                            onChanged: (bool? value) {
                              setState(() {
                                gen = 'female';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: TextField(
                      controller: _mailController,
                      style: AppStyle.h5.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.0, color: Colors.green)),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.green,
                          ),
                          labelText: 'EMAIL',
                          labelStyle:
                              AppStyle.h5.copyWith(color: AppColor.whiteGrey)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextField(
                          controller: _passController,
                          style: AppStyle.h5.copyWith(color: Colors.white),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.green)),
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.green,
                              ),
                              labelText: 'PASSWORD',
                              labelStyle: AppStyle.h5
                                  .copyWith(color: AppColor.whiteGrey)),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _show = !_show;
                            });
                          },
                          child: _show
                              ? const Text(
                                  'HIDE  ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text('SHOW  ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextField(
                          controller: _pass2Controller,
                          style: AppStyle.h5.copyWith(color: Colors.white),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.green)),
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.green,
                              ),
                              labelText: ' ENTER PASSWORD AGAIN',
                              // labelText: 'PASSWORD',
                              labelStyle: AppStyle.h5
                                  .copyWith(color: AppColor.whiteGrey)),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _show = !_show;
                            });
                          },
                          child: _show
                              ? const Text(
                                  'HIDE  ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text('SHOW  ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.secondColor),
                        onPressed: () {
                          if (_passController.text == _pass2Controller.text) {
                            LoadingDialog.showLoadingDialog(context, 'Sign up');
                            _authBloc.signUp(
                                _nameController.text,
                                _mailController.text,
                                _passController.text,
                                gen, () {
                              LoadingDialog.hideLoadingDialog(context);
                              MsgDialog.showMsgDialog(
                                  context, 'Sign up', 'Success!!!');
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
                              _phoneController.clear();
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
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'If you had a account, you can',
                          style:
                              AppStyle.h5.copyWith(color: AppColor.whiteGrey),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Login',
                              style: AppStyle.h5.copyWith(color: Colors.green),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
