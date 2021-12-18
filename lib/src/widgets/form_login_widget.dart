import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/page/home_page.dart';
import 'package:message_socket_flutter/src/page/signup_page.dart';
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
  late AuthBloc _authBloc;
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
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
            alignment: AlignmentDirectional.centerEnd,
            children: [
              TextField(
                controller: _passController,
                style: AppStyle.h5.copyWith(color: Colors.black),
                obscureText: !_show,
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
        ElevatedButton(
            onPressed: () {
              onSignIn();
            },
            child: Text(
              'SIGN IN!',
              style: AppStyle.h3,
            )),
        RichText(
          text: TextSpan(
              text: "If you don't a account, you can ",
              style: AppStyle.h5.copyWith(color: AppColor.blackGrey),
              children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                    text: 'Sign Up!',
                    style: const TextStyle(color: Colors.blue, fontSize: 16.0))
              ]),
        )
      ],
    ));
  }

  void onSignIn() {
    String _email = _mailController.text;
    String _password = _passController.text;

    LoadingDialog.showLoadingDialog(context, 'Loading.....');
    _authBloc.signIn(_email, _password, () {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, 'Sign In', msg);
    });
  }
}
