import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/page/home_page.dart';
import 'package:message_socket_flutter/src/page/main_page.dart';
import 'package:message_socket_flutter/src/page/signup_page.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/msg_dialog.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SignInPage extends StatefulWidget {
  //io.Socket socket;
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _show = false;
  late AuthBloc _authBloc;
  late SocketBloc _socketBloc;
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    super.initState();
    // print('socket: ' + widget.socket.toString());
    // print(widget.socket.connected);
    // _socketBloc.addSocket(widget.socket);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: AppColor.secondColor,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Container(
              child: Column(
            children: [
              Container(
                child: TextField(
                  controller: _mailController,
                  style: AppStyle.h5.copyWith(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle:
                          AppStyle.h4.copyWith(color: AppColor.blackGrey)),
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
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                          text: 'Sign Up!',
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 16.0))
                    ]),
              )
            ],
          )),
        ),
      ),
    );
  }

  void onSignIn() {
    String _email = _mailController.text;
    String _password = _passController.text;

    LoadingDialog.showLoadingDialog(context, 'Loading.....');
    _authBloc.signIn(_email, _password, () {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, 'Sign In', msg);
    });
  }
}
